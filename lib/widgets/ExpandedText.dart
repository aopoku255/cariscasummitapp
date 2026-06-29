import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final Color? color;

  const ExpandableText(
      {super.key,
      required this.text,
      this.maxLines = 3,
      this.color = Colors.white});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
              text: widget.text,
              style: TextStyle(fontSize: 16, color: widget.color)),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: _isExpanded
                    ? widget.text
                    : widget.text.substring(0,
                            widget.text.length > 50 ? 50 : widget.text.length) +
                        (isOverflowing ? '...' : ''),
                style: TextStyle(fontSize: 16, color: widget.color),
                children: isOverflowing
                    ? [
                        TextSpan(
                          text: _isExpanded ? " Show less" : " Read more",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        );
      },
    );
  }
}
