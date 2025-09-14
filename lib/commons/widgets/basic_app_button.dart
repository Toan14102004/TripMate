import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  const BasicAppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height
  });

  final Function onPressed;
  final String text;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:() => onPressed(),
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 80)
        // primary: Theme.of(context).colorScheme.primary,
        // onPrimary: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white
        ),
      ),
    );
  }
}