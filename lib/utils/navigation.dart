// lib/utils/navigation.dart
import 'package:flutter/material.dart';

void navigateTo(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => screen),
  );
}
