import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:smart_content/const/const.dart';
import 'package:smart_content/const/font_design.dart';

typedef OnRateChanged = Function(double);

class TextCard extends StatelessWidget {
  final String title;
  final String text;
  final double? rate;
  final OnRateChanged? onRateChanged;
  const TextCard({
    required this.title,
    required this.rate,
    required this.onRateChanged,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      margin: const EdgeInsets.only(
        top: 16,
        left: 8,
        right: 8,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0.4,
            spreadRadius: 0.4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextHighlight(
              textAlign: TextAlign.start,
              words: highlights,
              text: text,
              textStyle: primaryTextStyle,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (rate != null && onRateChanged != null)
                Text(
                  '0',
                  style: primaryTextStyle.copyWith(fontSize: 12),
                ),
              if (rate != null && onRateChanged != null)
                Slider(
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: primaryColor,
                  value: rate!,
                  onChanged: onRateChanged,
                ),
              if (rate != null && onRateChanged != null)
                Text(
                  '100',
                  style: primaryTextStyle.copyWith(fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserTextCard extends StatelessWidget {
  final String text;
  const UserTextCard({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(
              bottom: 4,
            ),
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              'Your Text',
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              text,
              style: primaryTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
