import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_content/component/card_layout.dart';
import 'package:smart_content/const/const.dart';
import 'package:smart_content/const/font_design.dart';
import 'package:translator/translator.dart';

class TextRecogScreen extends StatefulWidget {
  const TextRecogScreen({super.key});

  @override
  State<TextRecogScreen> createState() => _TextRecogScreenState();
}

class _TextRecogScreenState extends State<TextRecogScreen> {
  bool isScanning = false;
  XFile? imageFile;
  String scannedText = '';
  String translatedText = '';
  final GoogleTranslator _translator = GoogleTranslator();

  void translate(String text) async {
    Translation output = await _translator.translate(text, to: 'ko');
    setState(() {
      translatedText = output.text;
    });
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          isScanning = true;
          imageFile = pickedImage;
        });
        getText(pickedImage);
      }
    } catch (e) {
      setState(() {
        isScanning = false;
        imageFile = null;
        scannedText = 'Error occured while scanning';
      });
    }
  }

  // Function for Text Recognition
  void getText(XFile image) async {
    final selectedImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText =
        await textDetector.processImage(selectedImage);
    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = '$scannedText${line.text}\n';
      }
    }
    setState(() {
      isScanning = false;
    });
  }

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
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isScanning) const CircularProgressIndicator(),
                  if (!isScanning && imageFile == null)
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                  if (imageFile != null)
                    Container(
                      height: 500,
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Image.file(
                        File(imageFile!.path),
                        fit: BoxFit.fill,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // pick image button
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                              translatedText = '';
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                            translatedText = '';
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            setState(() {
                              isScanning = false;
                              imageFile = null;
                              scannedText = '';
                              translatedText = '';
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.refresh_outlined,
                                  size: 30,
                                ),
                                Text(
                                  "Reset",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (imageFile == null)
                    const Text(
                      'Choose or take a picture of text you want',
                      style: primaryTextStyle,
                    ),
                  const SizedBox(height: 20),
                  if (imageFile != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextCard(
                          onRateChanged: null,
                          rate: null,
                          text: scannedText,
                          title: 'Scanned Text',
                        ),
                      ],
                    ),
                  if (scannedText != '')
                    ElevatedButton(
                      onPressed: () => translate(scannedText),
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
                  if (scannedText != '' && translatedText != '')
                    TextCard(
                      title: 'Translated Text',
                      rate: null,
                      onRateChanged: null,
                      text: translatedText,
                    ),
                ],
              ),
            )),
      ]),
    );
  }
}
