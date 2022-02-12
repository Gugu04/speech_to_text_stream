import 'dart:async';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTextStream {
  final _textStreamController = StreamController<String>();
  final _buttonStreamController = StreamController<bool>();
  String _lastWords = '';
  String _tempWords = ''; //temporary words
  String _textinput = '';
  bool _status = false;

  Stream<String>? get speechToText {
    return _textStreamController.stream;
  }

  Stream<bool>? get buttonStatus {
    return _buttonStreamController.stream;
  }

  void startListening(SpeechToText speechToText, String textinput) async {
    _status = true;
    _buttonStreamController.add(true);
    _textinput = textinput;
    _tempWords = textinput;
    _textStreamController.onResume;
    _buttonStreamController.onResume;
    await speechToText
        .listen(onResult: _onSpeechResult)
        .catchError((onError) => stopListening);
  }

  void stopListening(SpeechToText speechToText) async {
    await speechToText.stop();
    _tempWords = _textinput;
    _status = false;
    _textStreamController.onPause;
    _buttonStreamController.add(false);
    _buttonStreamController.onPause;
    // _textStreamController.close();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    if (result.finalResult) {
      _buttonStreamController.add(false);
      _buttonStreamController.onPause;
    }
    if (_status) {
      if (_textinput.isEmpty || _tempWords.isEmpty) {
        _textStreamController.sink.add(_lastWords);
      } else if (_tempWords.isNotEmpty) {
        _textStreamController.sink.add("$_tempWords. $_lastWords");
      }
    }
  }

  void closeStreamController() async {
    _textStreamController.close();
  }
}
