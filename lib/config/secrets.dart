import 'dart:convert';
import 'package:flutter/services.dart';

late String geminiApiKey;
late String elevenLabsApiKey;
late String nasaApiKey;

Future<void> loadSecrets() async {
  final String jsonString =
      await rootBundle.loadString('assets/secrets.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  geminiApiKey = jsonData['geminiAPiKey'];
  elevenLabsApiKey = jsonData['elevenLabsApiKey'];
  nasaApiKey = jsonData['nasaApi'];
}
