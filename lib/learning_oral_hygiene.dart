import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LearningOralHygiene extends StatefulWidget {
  const LearningOralHygiene({super.key});

  @override
  State<LearningOralHygiene> createState() => _LearningOralHygieneState();
}

class _LearningOralHygieneState extends State<LearningOralHygiene> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return const Text('index 1');
    });
  }
}
