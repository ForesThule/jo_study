import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_view_pager/infinite_view_pager.dart';
import 'package:intl/intl.dart';
import 'package:jo_study/bloc/blocs.dart';
import 'package:jo_study/bloc/day_bloc.dart';
import 'package:jo_study/bloc/month_bloc.dart';
import 'package:jo_study/model/classwork.dart';
import 'package:jo_study/utils/date_utils.dart';
import 'package:jo_study/widgets/horizontal_wheel.dart';
import 'package:page_view_indicator/page_view_indicator.dart';

class DayScreen extends StatefulWidget {
  @override
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> with TickerProviderStateMixin {
//  TabController controller = TabController();

  final int _startingTabCount = 4;

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
            (0 + direction).toString(),
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
  PageController indicatorPageController;

  ValueNotifier<int> curentPageNotifier;
  ValueNotifier<int> indicatorPageNotifier;
  FixedExtentScrollController fixedExtentScrollController;

  ValueNotifier<int> selectedItemNotifier;

//  int currentPage;

  DateTime currenttime;
  DateTime start;
  DateTime end;
  List<DateTime> daysInRange;

//  final pageIndexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
//    classworksForDate = StreamController.broadcast();


    curentPageNotifier = ValueNotifier(0);
    indicatorPageNotifier = ValueNotifier(0);
    selectedItemNotifier = ValueNotifier(0);

    currenttime = new DateTime.now();
    start = currenttime.subtract(new Duration(days: 7));
    end = currenttime.add(new Duration(days: 7));
    daysInRange = Utils.daysInRange(start, end).toList();

    for (var i = 0; i < daysInRange.length; i++) {
      var day = daysInRange[i];
      if (day.day == currenttime.day) {
        curentPageNotifier.value = i;
        indicatorPageNotifier.value = i;

        fixedExtentScrollController = FixedExtentScrollController(initialItem: i);

      }
    }

    fixedExtentScrollController.addListener(() {});

    _tabs = getTabs(_startingTabCount);
    _tabController = getTabController();

    pageController = PageController(
        initialPage: curentPageNotifier.value, viewportFraction: 1);

    indicatorPageController = PageController(
        initialPage: indicatorPageNotifier.value, viewportFraction: 1);

    pageController.addListener(() {
      var offset = pageController.offset;
      var position = pageController.position;

      debugPrint("offset: $offset");
      debugPrint("position: $position");
    });

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

          Widget indicator() {
            var width = MediaQuery.of(context).size.width;
            return AbsorbPointer(
              absorbing: false,
              child: Container(
                width: width,
                height: 30,
                child: ListWheelScrollViewX(
                  onSelectedItemChanged: (d){
                    selectedItemNotifier.value = d;
                  },
                  controller: fixedExtentScrollController,
                  itemExtent: width / 3,
                  childs: snapShot.data.keys.map((day) {
                    var yestoday = day.subtract(Duration(days: 1));
                    var tomorrow = day.add(Duration(days: 1));
                    DateFormat formatter =
                        DateFormat(DateFormat.WEEKDAY, "ru_Ru");

                    return Center(
                      child: RotatedBox(
                          quarterTurns: 1,
                          child: Text("${formatter.format(day)}",
                              style: TextStyle(
                                  fontSize: 15
                              ))),
                    );
                  }).toList(),

//                builder: (ctx,index){
//                  return Text("$index");
//                },

                  scrollDirection: Axis.horizontal,
                ),
              ),
            );
          }

          return Stack(
            alignment: FractionalOffset.topCenter,
            children: <Widget>[
              PageView.builder(
                onPageChanged: (index) {
                  curentPageNotifier.value = index;
                  indicatorPageNotifier.value = index;
//                  indicatorPageController.jumpTo(index.toDouble());
//                  fixedExtentScrollController.jumpTo(index);

                  fixedExtentScrollController.animateToItem(index,
                      duration: Duration(milliseconds: 230),
                      curve: Curves.easeIn);
                },
                pageSnapping: true,
                itemCount: snapShot.data.length,
                itemBuilder: (ctx, index) {
                  var day = snapShot.data.keys.toList()[index];
                  debugPrint("DAY: $day");
                  var classworksOnDay = snapShot.data[day];
                  debugPrint("CLASSWORKS ON DAY: $classworksOnDay");

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 30, 4, 4),
                    child: Container(
                      child: classworksOnDay != null
                          ? buildPageViewContent(classworksOnDay, day)
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
                physics: ScrollPhysics(),
              ),
              Positioned(
                  top: 1,
                  child: Column(
                    children: <Widget>[
                      indicator(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 8, 2, 2),
                        child: SizedBox(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Color(0xffCC69A6),
                            ),
                            height: 1.0),
                      ),
                    ],
                  )),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildPageViewContent(List<Classwork> classworksOnDay, DateTime date) {
    var classworksWidgets = classworksOnDay.map((classwork) {
      var startDate = classwork.startDate;
      var finishDate = classwork.finishDate;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 60,
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Color(classwork.colorValue),
            ),
            title: Text(classwork.subject ?? "-",style: TextStyle(fontSize: 35),),
            subtitle: Text(classwork.place ?? "-",style: TextStyle(fontSize: 15)),
            trailing: Text("${formatDate(startDate, [hh,':',ss ])} - ${formatDate(finishDate, [hh,':',ss ])}",style: TextStyle(fontSize: 12)),
          ),
        ),
      );
    });

    var yestoday = date.subtract(Duration(days: 1));
    var tomorrow = date.add(Duration(days: 1));
    DateFormat formatter = DateFormat(DateFormat.WEEKDAY, "ru_Ru");

    var indicators = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Center(
            child: Text(
          "${formatter.format(yestoday)}",
          style: TextStyle(fontSize: 10),
        )),
        Center(
            child: Text("${formatter.format(date)}",
                style: TextStyle(fontSize: 18))),
        Center(
            child: Text("${formatter.format(tomorrow)}",
                style: TextStyle(fontSize: 10))),
      ],
    );

    return Column(
      children: <Widget>[
//        indicators,

        ...classworksWidgets
      ],
    );
  }

  Widget getWidget(int i) {
    return Container(
      color: Colors.pink[i],
    );
  }
}
