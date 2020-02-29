import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jo_study/bloc/task_bloc.dart';
import 'package:jo_study/model/classwork.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    final TaskBloc bloc = BlocProvider.of<TaskBloc>(context);

    PageController pageController = PageController();

    return LayoutBuilder(builder: (context, w) {
      return Container(
        width: w.maxWidth,
        height: w.maxHeight,
        child: Stack(
          children: <Widget>[
//    bloc.getClassworksForPeriod(daysInRange);

            StreamBuilder<Map<DateTime, List<Classwork>>>(
              stream: bloc.getTasksForCurrentMonth(),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  debugPrint("CLASSWORKS ON PERIOD ${snapShot.data}");

                  snapShot.data.forEach((d, l) {
                    debugPrint("CLASSWORKS ON PERIOD $d ${l.toString()}");
                  });

                  debugPrint("snapShot.data.length ${snapShot.data.length}");

                  return PageView.builder(
                    itemCount: snapShot.data.length,
                    itemBuilder: (ctx, index) {
//              snapShot.data
                      var day = snapShot.data.keys.toList()[index];
                      debugPrint("DAY: $day");

                      var classworksOnDay = snapShot.data[day];
                      debugPrint("CLASSWORKS ON DAY: $classworksOnDay");

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.deepPurple,
                          child: classworksOnDay != null
                              ? ListView.builder(
                                  itemCount: snapShot.data[day].length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 60,
                                        color: Colors.pink,
                                      ),
                                    );
                                  })
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 60,
                                    color: Colors.orange,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child:
                                          Text(snapShot.data[index].toString()),
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
//      children: week(),
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                  );
                } else {
                  return Container();
                }
              },
            ),

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
