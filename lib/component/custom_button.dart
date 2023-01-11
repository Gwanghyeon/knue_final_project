import 'package:flutter/material.dart';
import 'package:smart_content/const/const.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  const CustomButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
      ),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
