import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeMainFeed extends StatefulWidget {
  const HomeMainFeed({super.key});

  @override
  State<HomeMainFeed> createState() => _HomeMainFeedState();
}

class _HomeMainFeedState extends State<HomeMainFeed> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Container(
        child: Text('index 0'),
      );
    });
  }
}
