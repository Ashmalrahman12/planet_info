import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:planet_info/ai_voice/gemini.dart';
import 'package:planet_info/home_pages/in_pages/gemini_input_bar.dart';
import 'package:planet_info/model/spaceObject.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchResultPage extends StatefulWidget {
  final String query;
  final String answer;
  final SpaceObject? planet;

  const SearchResultPage({
    super.key,
    required this.query,
    required this.answer,
    this.planet,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  final TextEditingController _msgController = TextEditingController();
  
  Future<void> _startVoiceInput() async {
  final available = await _speech.initialize(
    onStatus: (status) {
      if (status == 'done') {
        setState(() => _isListening = false);
      }
    },
    onError: (error) {
      setState(() => _isListening = false);
    },
  );

  if (!available) return;

  setState(() => _isListening = true);

  _speech.listen(
    listenMode: stt.ListenMode.confirmation,
    onResult: (result) {
      if (result.finalResult) {
        _speech.stop();
        setState(() => _isListening = false);

       
        _sendMessage(result.recognizedWords);
      }
    },
  );
}



  @override
  void initState() {
    super.initState();

   _speech = stt.SpeechToText();
    _messages.add(
      ChatMessage(text: widget.answer, isUser: false),
    );
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });

    final aiReply = message.toLowerCase().contains('nasa') ||
            message.toLowerCase().contains('today')
        ? await nasaToGemini()
        : await askGemini(
            "You are a space assistant. Answer clearly:\n$message",
          );

    if (!mounted) return;

    setState(() {
      _messages.add(ChatMessage(text: aiReply, isUser: false));
      _isLoading = false;
    });

   await _speech.stop();             
  await Future.delayed(
      const Duration(milliseconds: 400));

    await speakWithElevenLabs(aiReply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(widget.query)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];

                return BubbleSpecialOne(
                  text: msg.text,
                  isSender: msg.isUser,
                  tail: true,
                  color: msg.isUser
                      ? Colors.blue
                      : Colors.grey.shade300,
                  textStyle: TextStyle(
                    color: msg.isUser ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

         Align(
  alignment: Alignment.bottomCenter,
  child: GeminiGlowingInputBar(
    controller: _msgController, 
    isListening: _isListening, 
    onVoiceTap: _startVoiceInput, 
    onSend: () {
   
      final text = _msgController.text;
      
    
      if (text.trim().isNotEmpty) {
        _sendMessage(text);
        _msgController.clear(); 
      }
    },
  ),
)
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
