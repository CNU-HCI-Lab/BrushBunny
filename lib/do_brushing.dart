import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DoBrushing extends StatefulWidget {
  const DoBrushing({super.key});

  @override
  State<DoBrushing> createState() => _DoBrushingState();
}

class _DoBrushingState extends State<DoBrushing> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/brushing_label');
          },
          child: const Text('Do Brushing'));
    });
  }
}
