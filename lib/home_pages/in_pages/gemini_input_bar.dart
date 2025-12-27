import 'package:flutter/material.dart';

import 'package:planet_info/home_pages/in_pages/mic_waveform.dart'; 

class GeminiGlowingInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoiceTap;
  final bool isListening;

  const GeminiGlowingInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onVoiceTap,
    required this.isListening,
  });

  @override
  State<GeminiGlowingInputBar> createState() => _GeminiGlowingInputBarState();
}

class _GeminiGlowingInputBarState extends State<GeminiGlowingInputBar> {
  bool _showSendButton = false;

  @override
  void initState() {
    super.initState();
   
    widget.controller.addListener(() {
      final isNotEmpty = widget.controller.text.trim().isNotEmpty;
      if (_showSendButton != isNotEmpty) {
        setState(() {
          _showSendButton = isNotEmpty;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
      
          Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF559F), 
                  Color(0xFFCF57E0),
                  Color(0xFF4285F4), 
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCF57E0).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

       
          Container(
            height: 66,
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(34),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
             
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black54),
                  onPressed: () {},
                ),

           
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    style: const TextStyle(color: Colors.black87),
                    decoration: const InputDecoration(
                      hintText: "Ask Gemini...",
                      hintStyle: TextStyle(color: Colors.black45),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => widget.onSend(),
                  ),
                ),

             
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F4F9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _showSendButton
                        ? IconButton(
                  
                            icon: const Icon(Icons.send, color: Color(0xFF4285F4)),
                            onPressed: widget.onSend,
                          )
                        : MicWaveformButton(
                          
                            isListening: widget.isListening,
                            onPressed: widget.onVoiceTap,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}