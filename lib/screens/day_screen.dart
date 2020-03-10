import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_view_pager/infinite_view_pager.dart';
import 'package:jo_study/bloc/blocs.dart';
import 'package:jo_study/bloc/day_bloc.dart';
import 'package:jo_study/bloc/month_bloc.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/utils/date_utils.dart';
import 'package:jo_study/widgets/horizontal_wheel.dart';
import 'package:page_view_indicators/step_page_indicator.dart';

class DayScreen extends StatefulWidget {
  @override
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> with TickerProviderStateMixin {
//  TabController controller = TabController();

  final int _startingTabCount = 4;
  int index = 0;

  List<Tab> _tabs = List<Tab>();
  List<Widget> _generalWidgets = List<Widget>();
  TabController _tabController;

  DateTime currentTime = DateTime.now();

  TabController getTabController() {
    return TabController(length: _tabs.length, vsync: this);
  }

  Tab getTab(int widgetNumber) {
    return Tab(
      text: "${currentTime.toIso8601String()}",
    );
  }

  List<Tab> getTabs(int count) {
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      _tabs.add(getTab(i));
    }
    return _tabs;
  }

  List<Widget> getWidgets() {
    _generalWidgets.clear();
    for (int i = 0; i < _tabs.length; i++) {
      _generalWidgets.add(getWidget(i));
    }
    return _generalWidgets;
  }

  Widget _buildPage(BuildContext context, int direction) {
    return Container(
      padding: EdgeInsets.all(100.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        child: Center(
          child: Text(
            (index + direction).toString(),
            style: Theme.of(context).textTheme.display4,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  PageController pageController;
  ValueNotifier<int> curentPageNotifier;

//  int currentPage;

  DateTime currenttime;
  DateTime start;
  DateTime end;
  List<DateTime> daysInRange;

  @override
  void initState() {
//    classworksForDate = StreamController.broadcast();

    curentPageNotifier = ValueNotifier(0);
    currenttime = new DateTime.now();
    start = currenttime.subtract(new Duration(days: 7));
    end = currenttime.add(new Duration(days: 7));
    daysInRange = Utils.daysInRange(start, end).toList();

    for (var i = 0; i < daysInRange.length; i++) {
      var day = daysInRange[i];
      if (day.day == currenttime.day) {
        curentPageNotifier.value = i;
      }
    }
    _tabs = getTabs(_startingTabCount);
    _tabController = getTabController();

    pageController = PageController(
        initialPage: curentPageNotifier.value, viewportFraction: 1);

//    pageController.addListener(() {
//      var page = pageController.page;
//      curentPage.value = page.floor();
////      bloc.getClassworksForDate(daysInRange[page.floor()]);
//    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DayBloc bloc = BlocProvider.of<DayBloc>(context);

//    bloc.getClassworksForPeriod(daysInRange);

    return StreamBuilder<Map<DateTime, List<Classwork>>>(
      stream: bloc.getClassworksForPeriod(daysInRange),
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          debugPrint("CLASSWORKS ON PERIOD ${snapShot.data}");

          snapShot.data.forEach((d, l) {
            debugPrint("CLASSWORKS ON PERIOD $d ${l.toString()}");
          });

          debugPrint("snapShot.data.length ${snapShot.data.length}");

          return PageView.builder(
            pageSnapping: true,
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
                  child: classworksOnDay != null
                      ? ListView.builder(
                          itemCount: classworksOnDay.length,
                          itemBuilder: (context, index) {
                            var classwork = classworksOnDay[index];

                            var startDate = classwork.startDate;
                            var finishDate = classwork.finishDate;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 60,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        Color(classwork.colorValue),
                                  ),
                                  title: Text(classwork.subject ?? "-"),
                                  subtitle: Text(classwork.place ?? "-"),
                                  trailing: Text(
                                      "${Utils.apiDayFormat(startDate)} - ${Utils.apiDayFormat(finishDate)}"),
                                ),
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
                              child: Text(snapShot.data[index].toString()),
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
    );
  }

  Widget getWidget(int i) {
    return Container(
      color: Colors.pink[i],
    );
  }
}
//Container(
//                color: Colors.black,
//                padding: const EdgeInsets.all(16.0),
//                child: StepPageIndicator(
//                  previousStep: Text("sdsdsds"),
//                  nextStep: Text("sdsdsds"),
//                  selectedStep: Text("sdsdsds"),
//                  itemCount: 3,
//                  currentPageNotifier: curentPageNotifier,
//                  size: 16,
//                  onPageSelected: (int index) {
//                    if (curentPageNotifier.value > index)
//                      pageController.jumpToPage(index);
//                  },
//                ),
//              ),