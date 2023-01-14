import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechProvider extends ChangeNotifier {
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  void initSpeech() async {
    lastWords = '';
    speechEnabled = await speechToText.initialize(debugLogging: true);
    debugPrint(speechEnabled.toString());
    notifyListeners();
  }

  void startListening() async {
    lastWords = '';
    await speechToText.listen(onResult: _onSpeechResult);
    notifyListeners();
  }

  void stopListening() async {
    lastWords = '';
    await speechToText.stop();
    notifyListeners();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    notifyListeners();
  }
}
