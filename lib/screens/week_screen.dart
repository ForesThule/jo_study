import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeekScreen extends StatefulWidget {
  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Table(),
    );
  }
}
