import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'MainText.dart';

class Button extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final Color backgroundColor;
  final bool hasIcon;

  const Button({
    Key? key,
    this.onTap,
    required this.label,
    this.backgroundColor = AppColors.primaryVoilet,
    this.hasIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainText(
              text: label,
              color: Colors.white,
              fontSize: 18,
            ),
            if (hasIcon)
              const SizedBox(width: 30),
            if (hasIcon)
              const Icon(
                Icons.arrow_circle_right_outlined,
                color: Colors.white,
                size: 35,
              ),
          ],
        ),
      ),
    );
  }
}
