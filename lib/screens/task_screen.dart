import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_view_pager/infinite_view_pager.dart';
import 'package:jo_study/bloc/task_bloc.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/model/task.dart';
import 'package:jo_study/utils/date_utils.dart';
import 'package:jo_study/widgets/custom_dialog.dart';
import 'package:vector_math/vector_math.dart' as math;

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  PageController pageController;
  var initPageNumber;

  @override
  void initState() {
//    initPageNumber = 0;

    pageController = PageController(initialPage: DateTime.now().day - 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TaskBloc bloc = BlocProvider.of<TaskBloc>(context);

    void addTask() {
      debugPrint("ADD TASK");

      showGeneralDialog(
          barrierLabel: '',
          barrierDismissible: true,
          context: context,
          transitionDuration: Duration(milliseconds: 200),
          transitionBuilder: (context, anim1, anim2, child) {
            final curvedValue = Curves.easeInOutBack.transform(anim1.value);

            return Transform.scale(
//              transform: Matrix4.translationValues(0.0, curvedValue * 50, 0.0),
              scale: curvedValue,
//              angle: math.radians(anim1.value * 360),
              child: Opacity(
                opacity: anim1.value,
                child: TaskDialog(
                  bloc: bloc,
                  title: "Добавить задание",
                ),
              ),
            );
          },
          pageBuilder: (context, showAnimation, hideAnimation) {});
    }

    return BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is TaskSavedState) {
            debugPrint("TASK SCREEN BUILDER: $state");
          }

          return LayoutBuilder(builder: (context, w) {
            return Container(
              width: w.maxWidth,
              height: w.maxHeight,
              child: Stack(
                children: <Widget>[
//    bloc.getClassworksForPeriod(daysInRange);

                  StreamBuilder<Map<DateTime, List<Task>>>(
                    stream: bloc.getTasksForCurrentMonth(),
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        debugPrint("TASK FOR MONTH: ${snapShot.data}");
                        return PageView.builder(
                          itemCount: snapShot.data.length,
                          itemBuilder: (ctx, index) {
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
                                            child: Text(snapShot.data[index]
                                                .toString()),
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
        });
  }

  getCurrentPageNumber(Map<DateTime, List<Classwork>> data) {
    var now = DateTime.now();
    var indexOf = data.keys
        .toList()
        .map((listday) {
          return Utils.isSameDay(listday, now);
        })
        .toList()
        .indexOf(true);

    debugPrint("CURRENT PAGE NUMBER: $indexOf");
  }
}
