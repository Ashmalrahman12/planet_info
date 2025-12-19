import 'dart:convert';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../config/secrets.dart';

final _player = AudioPlayer();



Future<String> askGemini(String prompt) async {
  try {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: geminiApiKey, 
    );

    final response = await model.generateContent([
      Content.text(prompt),
    ]);

    return response.text ?? 'No response from Gemini.';
  } catch (e) {
    return 'Gemini error: $e';
  }
}



Future<String> nasaToGemini() async {
  final nasaRes = await http.get(
    Uri.parse(
      'https://api.nasa.gov/planetary/apod?api_key=$nasaApiKey', 
    ),
  );

  final nasaText = jsonDecode(nasaRes.body)['explanation'];

  return await askGemini(
    "Explain this NASA content in simple, friendly language:\n$nasaText",
  );
}



Future<void> speakWithElevenLabs(String text) async {
  final res = await http.post(
    Uri.parse(
      'https://api.elevenlabs.io/v1/text-to-speech/EXAVITQu4vr4xnSDxMaL',
    ),
    headers: {
      'xi-api-key': elevenLabsApiKey, 
      'Content-Type': 'application/json',
      'Accept': 'audio/mpeg',
    },
    body: jsonEncode({
      "text": text,
      "model_id": "eleven_turbo_v2",
    }),
  );

  final contentType = res.headers['content-type'];

  if (res.statusCode != 200 ||
      contentType == null ||
      !contentType.contains('audio')) {
    print(" ElevenLabs error: ${res.body}");
    return;
  }

  await _player.stop();
  await _player.play(
    BytesSource(
      Uint8List.fromList(res.bodyBytes),
      mimeType: 'audio/mpeg',
    ),
  );
}


Future<String> handleSearch(String query) async {
  if (query.toLowerCase().contains('nasa') ||
      query.toLowerCase().contains('today')) {
    return await nasaToGemini();
  }

  return await askGemini(
    "You are a space assistant. Answer clearly and conversationally:\n$query",
  );
}
