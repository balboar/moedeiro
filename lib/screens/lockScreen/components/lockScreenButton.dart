import 'package:flutter/material.dart';

class InputButtonConfig {
  // final double fontSize;
  /// default `MediaQuery.of(context).size.width * 0.095`
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double backgroundOpacity;
  final ShapeBorder? shape;

  const InputButtonConfig({
    this.textStyle,
    this.backgroundColor = const Color(0xFF757575),
    this.backgroundOpacity = 0.4,
    this.shape,
  });
}

class InputButton extends StatelessWidget {
  final InputButtonConfig config;

  final String text;
  final Sink<String> enteredSink;

  InputButton({
    required this.text,
    required this.enteredSink,
    this.config = const InputButtonConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = config.textStyle ??
        TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: MediaQuery.of(context).size.width * 0.095,
        );

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton(
        child: Text(
          text,
          style: textStyle,
        ),
        style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.100))),
        onPressed: () {
          enteredSink.add(text);
        },
      ),
    );
  }
}
