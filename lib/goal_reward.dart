import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GoalReward extends StatefulWidget {
  const GoalReward({super.key});

  @override
  State<GoalReward> createState() => _GoalRewardState();
}

class _GoalRewardState extends State<GoalReward> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Container(
        child: Text('index 3'),
      );
    });
  }
}
