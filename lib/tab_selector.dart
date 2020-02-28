import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jo_study/app_keys.dart';
import 'package:jo_study/localization.dart';

enum AppTab { month, day, week, task, exam }

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.orange,
      key: AppKeys.tabs,
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          backgroundColor: Colors.black,
          activeIcon: getActiveIcon(tab),
          icon: getIcon(tab),
          title: getTitle(tab, context),
        );
      }).toList(),
    );
  }

  Text getTitle(AppTab tab, BuildContext context) {
    switch (tab) {
      case AppTab.month:
//        return Text(AppBlocLocalizations.of(context).month);
        return Text("");
        break;
      case AppTab.day:
        return Text("");
//        return Text(AppBlocLocalizations.of(context).day);
        break;
      case AppTab.week:
        return Text("");
//        return Text(AppBlocLocalizations.of(context).week);
        break;
      case AppTab.task:
        return Text("");

//        return Text(AppBlocLocalizations.of(context).task);
        break;
      case AppTab.exam:
        return Text("");

//        return Text(AppBlocLocalizations.of(context).exam);
        break;
    }
  }

  Widget getIcon(AppTab tab) {
    switch (tab) {
      case AppTab.month:
        return tabIcon("assets/month_grey.png");
        break;
      case AppTab.day:
        return tabIcon("assets/day_gray.png");

        break;
      case AppTab.week:
        return tabIcon("assets/week_gray.png");
        break;
      case AppTab.task:
        return tabIcon("assets/task_gray.png");

        break;
      case AppTab.exam:
        return tabIcon("assets/exam_gray.png");
        break;
    }
  }

  Image tabIcon(String path) {
    return Image.asset(
      path,
      width: 40,
      height: 40,
      key: getKey(path),
    );
  }

  getActiveIcon(AppTab tab) {
    switch (tab) {
      case AppTab.month:
        return activeTabIcon("assets/month.png");
        break;
      case AppTab.day:
        return activeTabIcon("assets/day.png");
        break;
      case AppTab.week:
        return activeTabIcon("assets/week.png");
        break;
      case AppTab.task:
        return activeTabIcon("assets/task.png");
        break;
      case AppTab.exam:
        return activeTabIcon("assets/exam.png");
        break;
    }
  }

  Container activeTabIcon(String path) {
    return Container(
      width: 40,
      height: 40,
      child: Image.asset(
        path,
        key: getKey(path),
      ),
    );
  }

  getKey(String keyString) {
    return Key(keyString);
  }
}
