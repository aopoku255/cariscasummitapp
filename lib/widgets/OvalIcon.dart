import 'dart:ui';

import 'package:flutter/material.dart';

class OvalIcon extends StatelessWidget {
  final IconData icon;
  const OvalIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return  ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adds blur effect
        child: Container(
          color: Colors.black.withOpacity(0.3), // Semi-transparent white background
          child: IconButton(
            icon: Icon(icon, color: Colors.white), // Leading icon
            onPressed: () {
              // Handle back button press
            },
          ),
        ),
      ),
    );
  }
}
