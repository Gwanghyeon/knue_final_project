import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smart_content/component/card_layout.dart';
import 'package:smart_content/component/custom_button.dart';
import 'package:smart_content/const/const.dart';
import 'package:smart_content/const/font_design.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _textToSpeech = FlutterTts();
  final GoogleTranslator _translator = GoogleTranslator();

  bool isSpeaking = false;
  String _text = '';
  int currentIdx = 0;
  double speechRate = 0.5;

  void _initSpeech() async {
    // stt
    await _speechToText.initialize();
    // tts
    await _textToSpeech.getDefaultEngine;
    await _textToSpeech.getDefaultVoice;
    await _textToSpeech.getLanguages;
    _textToSpeech.setCompletionHandler(() {
      setState(() => isSpeaking = false);
    });
  }

  // Function for Speech to Text
  void _startListening() async {
    setState(() => _text = '');

    await _speechToText.listen(
        listenMode: ListenMode.dictation,
        localeId: 'en-US',
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {}
          });
        });
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  // Function for Text to Speech
  void _startSpeaking(String text) async {
    await _textToSpeech.setLanguage(selectedLocaleId);
    await _textToSpeech.setSpeechRate(speechRate);
    int isOn = await _textToSpeech.speak(text);
    if (isOn == 1) {
      setState(() => isSpeaking = true);
    } else {
      setState(() => isSpeaking = false);
    }
  }

  void _stopSpeaking() async {
    await _textToSpeech.stop();
    setState(() => isSpeaking = false);
  }

  // Fuction for Trnaslation
  void translate(String text) async {
    Translation output = await _translator.translate(text, to: 'ko');
    setState(() {
      _text = output.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _textToSpeech.stop();
    _speechToText.stop();
    super.dispose();
  }

  String selectedLocaleId = 'en-US';
  Map<String, String> locales = {
    'en-US': 'US',
    'en-GB': 'UK',
    'en-CA': 'CA',
    'en-NZ': 'NZ'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Learning English with AI',
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              DropdownButton<String>(
                iconEnabledColor: Colors.white,
                dropdownColor: primaryColor,
                value: selectedLocaleId,
                items: locales.entries
                    .map((locale) => DropdownMenuItem<String>(
                          value: locale.key,
                          child: Text(
                            locale.value,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: ((value) {
                  setState(() {
                    selectedLocaleId = value!;
                  });
                }),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _speechToText.isListening,
        endRadius: 60,
        glowColor: Colors.red,
        child: FloatingActionButton(
          onPressed:
              _speechToText.isListening ? _stopListening : _startListening,
          backgroundColor:
              _speechToText.isListening ? Colors.red : primaryColor,
          child: Icon(
            _speechToText.isListening ? Icons.mic : Icons.mic_none,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('asset/paper.jpg'),
            fit: BoxFit.cover,
          )),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextCard(
                title: 'Target Sentence',
                text: targetSentences[currentIdx],
                rate: speechRate,
                onRateChanged: (rate) {
                  setState(() {
                    _stopSpeaking();
                    speechRate = rate;
                  });
                },
              ),
              // for button part; moving to the next sentence
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        icon: Icons.keyboard_double_arrow_left,
                        onPressed: (0 > currentIdx - 1)
                            ? null
                            : () => setState(() {
                                  _text = '';
                                  _stopSpeaking();
                                  currentIdx--;
                                }),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        icon: isSpeaking
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline,
                        onPressed: () {
                          if (!isSpeaking) {
                            _startSpeaking(targetSentences[currentIdx]);
                          } else {
                            _stopSpeaking();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        icon: Icons.keyboard_double_arrow_right,
                        onPressed: (targetSentences.length <= currentIdx + 1)
                            ? null
                            : () => setState(() {
                                  _text = '';
                                  _stopSpeaking();
                                  _stopSpeaking();
                                  currentIdx++;
                                }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () => translate(targetSentences[currentIdx]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'TRANSLATE!',
                            style: primaryTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              UserTextCard(
                text: _text,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
