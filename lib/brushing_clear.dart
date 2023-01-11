import 'package:flutter/material.dart';

class BrushingClear extends StatefulWidget {
  const BrushingClear({super.key});

  @override
  State<BrushingClear> createState() => _BrushingClearState();
}

class _BrushingClearState extends State<BrushingClear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('BrushingClear')),
    );
  }
}
