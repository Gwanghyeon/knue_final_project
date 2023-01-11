// for highlighting words
import 'package:highlight_text/highlight_text.dart';
import 'package:smart_content/const/font_design.dart';
import 'package:flutter/material.dart';

// custom Colors
const Color primaryColor = Color(0xFF00695C);

final Map<String, HighlightedWord> highlights = {
  'hello': HighlightedWord(
    textStyle: primaryTextStyle.copyWith(
      fontSize: 32,
      color: Colors.red,
    ),
  ),
};
const List<BoxShadow> primaryShadow = [
  BoxShadow(
    color: Colors.black,
    blurRadius: 2,
    spreadRadius: 2,
  ),
];

const defaultText =
    'Machine learning is a subset of AI that enables computers to learn without humans programming them. It leverages AI power inside apps like language translators, social media algorithms, and streaming services to suggest shows you may like.';

const targetSentences = [
  'machine learning is a subset of AI that enables computers to learn without humans programming them.',
  'it leverages AI power inside apps like language translators, social media algorithms, and streaming services to suggest shows you may like.',
  'machine learning algorithms are typically created using frameworks that accelerate solution development.',
  'machine learning, deep learning, and neural networks are all sub-fields of artificial intelligence.',
  'Deep learning and neural networks are credited with accelerating progress in areas such as natural language processing and speech recognition.',
];
