import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, w) {
      return Container(
        width: w.maxWidth,
        height: w.maxHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                  backgroundColor: Color(0xffCC69A6),
                  onPressed: addTask),
            )
          ],
        ),
      );
    });
  }

  void addTask() {
    debugPrint("ADD TASK");
  }
}
