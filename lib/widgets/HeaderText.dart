import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: AppColors.primaryRed, fontSize: 28, fontWeight: FontWeight.bold),);
  }
}
