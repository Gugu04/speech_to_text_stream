import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text_stream/components/avatar_glow.dart';
import 'package:speech_to_text_stream/utils/speech_text_stream.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController textinput = TextEditingController(text: '');
  final speechToText = SpeechToText();
  var textStream = SpeechTextStream();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    bool _speechEnabled = false;
    _speechEnabled = await speechToText.initialize();
    if (!_speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          elevation: 2,
          backgroundColor: Colors.red,
          content: Text(
            'Error: Reconocimiento de voz no disponible..',
            style: TextStyle(fontSize: 18),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.multitrack_audio_sharp,
                    size: 40,
                  ),
                  Text(
                    "\u0020Voz a texto",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<String>(
                stream: textStream.speechToText,
                initialData: '',
                builder: (_, snapshot) {
                  textinput.text = snapshot.data!;
                  return TextFormField(
                    // showCursor: speechToText.isNotListening,
                    // readOnly: !speechToText.isNotListening,
                    controller: textinput,
                    maxLines: 8,
                    minLines: 8,
                    decoration: InputDecoration(
                        hintText: 'Note',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color(0xff045de9),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: const Color(0xff045de9).withOpacity(0.6),
                            width: 2.0,
                          ),
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder<bool>(
        stream: textStream.buttonStatus,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return AvatarGlow(
            animate: snapshot.data!,
            glowColor: const Color(0xff045de9),
            endRadius: 85.0,
            duration: const Duration(milliseconds: 900),
            // repeatPauseDuration: const Duration(milliseconds: 10),
            repeat: true,
            child: SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  onPressed: () => !snapshot.data!
                      ? textStream.startListening(speechToText, textinput.text)
                      : textStream.stopListening(speechToText),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, // circular shape
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.topCenter,
                        colors: [Color(0xff045de9), Color(0xff1895F6)],
                      ),
                    ),
                    child: Icon(
                      snapshot.data! ? Icons.mic_off : Icons.mic,
                      size: 38,
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}
