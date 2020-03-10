import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jo_study/app_keys.dart';
import 'package:jo_study/bloc/day_bloc.dart';
import 'package:jo_study/bloc/exam_bloc.dart';
import 'package:jo_study/bloc/month_bloc.dart';
import 'package:jo_study/bloc/states.dart';
import 'package:jo_study/bloc/task_bloc.dart';
import 'package:jo_study/bloc/week_bloc.dart';
import 'package:jo_study/localization.dart';
import 'package:jo_study/screens/week_screen.dart';
import 'package:jo_study/tab_selector.dart';

import '../bloc/blocs.dart';
import '../bloc/events.dart';
import '../repositoty.dart';
import '../routes.dart';
import 'day_screen.dart';
import 'exam_screen.dart';
import 'month_screen.dart';
import 'task_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppBloc bloc = BlocProvider.of<AppBloc>(context);

    currentStateScreen(AppState state) {
      debugPrint("CURRENT SCREEN STATE: $state");

      if (state is MonthHomeScreenState) {
        return BlocProvider(
          create: (context) => MonthBloc(bloc.repo),
          child: MonthScreen(),
        );
      } else if (state is WeekHomeScreenState) {
        return BlocProvider(
            create: (context) => WeekBloc(bloc.repo), child: WeekScreen());
      } else if (state is DayHomeScreenState) {
        return BlocProvider(
            create: (context) => DayBloc(bloc.repo), child: DayScreen());
      } else if (state is TaskHomeScreenState) {
        return BlocProvider(
            create: (context) => TaskBloc(bloc.repo), child: TaskScreen());
      } else if (state is ExamHomeScreenState) {
        return BlocProvider(
            create: (context) => ExamBloc(bloc.repo), child: ExamScreen());
      } else {
        return MonthScreen();
      }
    }

    return BlocBuilder<AppBloc, AppState>(
      bloc: bloc,
      condition: (oldstate, newstate) {
        print("CHECK CONDITION $newstate");
        return true;
      },
      builder: (context, state) {
        debugPrint("CHECK STATE: ${state}");

        return Scaffold(
          appBar: getAppBar(state),
          body: currentStateScreen(state),
          bottomNavigationBar: TabSelector(
            activeTab: getActiveTab(state),
            onTabSelected: (tab) {
              debugPrint("TAB SELECTOR: $tab");
              bloc.add(ShowTabScreen(tab));
            },
          ),
        );
      },
    );
  }

  getActiveTab(AppState state) {
    print("GET ACTIVE TAB $state");

    if (state is MonthHomeScreenState) {
      return AppTab.month;
    } else if (state is WeekHomeScreenState) {
      return AppTab.week;
    } else if (state is DayHomeScreenState) {
      return AppTab.day;
    } else if (state is TaskHomeScreenState) {
      return AppTab.task;
    } else if (state is ExamHomeScreenState) {
      return AppTab.exam;
    } else {
      return AppTab.month;
    }
  }

  getAppBar(AppState state) {
    if (state is MonthHomeScreenState) {
      return appBar("Месяц");
    } else if (state is WeekHomeScreenState) {
      return appBar("Неделя");
    } else if (state is DayHomeScreenState) {
      return appBar("Обзор дня");
    } else if (state is TaskHomeScreenState) {
      return appBar("Задание");
    } else if (state is ExamHomeScreenState) {
      return appBar("Экзамен");
    }
  }

  AppBar appBar(title) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Image.asset(
            "assets/menu_icon.png",
            height: 16,
            width: 16,
          ),
          height: 16,
          width: 16,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xffCC69A6),
        ),
      ),


//      bottom: TabBar(
//        indicatorSize: TabBarIndicatorSize.tab,
//        indicator: CircleTabIndicator(color: Colors.green, radius: 4),
//        isScrollable: true,
//        labelColor: Colors.black,
//        tabs: <Widget>[
//          Tab(text: 'Week 1'),
//          Tab(text: 'Week 2'),
//          Tab(text: 'Week 3'),
//        ],
//      ),
//


      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 8, 2, 2),
          child: SizedBox(
              child: Container(
                color: Colors.white12,
              ),
              height: 1.0),
        ),
      ),
      actions: [
//              FilterButton(visible: activeTab == AppTab.todos),
//              ExtraActions(),
      ],
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius}) : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}