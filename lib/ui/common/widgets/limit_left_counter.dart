import 'package:flutter/material.dart';

class LimitLeftCounter {
  LimitLeftCounter({required this.showAtCharactersLeft});

  final int showAtCharactersLeft;

  Widget? build(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    if (maxLength == null) {
      return null;
    }

    final limitReached = maxLength - currentLength <= showAtCharactersLeft;
    final text = limitReached ? '$currentLength/$maxLength' : '';
    if (text.isEmpty) {
      return null;
    }
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class LimitLeftVisibilitySpacer extends StatelessWidget {
  const LimitLeftVisibilitySpacer({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.showAtCharactersLeft,
    required this.height,
  });

  final TextEditingController controller;
  final int maxLength;
  final int showAtCharactersLeft;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final counterVisible = maxLength - value.text.length <= showAtCharactersLeft;
        return SizedBox(height: counterVisible ? 0 : height);
      },
    );
  }
}
