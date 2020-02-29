import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jo_study/app_keys.dart';
import 'package:jo_study/bloc/day_bloc.dart';
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

      if (state is Month) {
        return BlocProvider(
          create: (context) => MonthBloc(bloc.repo),
          child: MonthScreen(),
        );
      } else if (state is Week) {
        return BlocProvider(
            create: (context) => WeekBloc(bloc.repo), child: WeekScreen());
      } else if (state is Day) {
        return BlocProvider(
            create: (context) => DayBloc(bloc.repo), child: DayScreen());
      } else if (state is Task) {
        return BlocProvider(
            create: (context) => TaskBloc(bloc.repo), child: TaskScreen());
      } else if (state is Exam) {
        return ExamScreen();
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
//          floatingActionButton:
//              BlocBuilder<AppBloc, AppState>(builder: (context, snapshot) {
//            return FloatingActionButton(
//              key: AppKeys.addTaskFab,
//              onPressed: () {
//                Navigator.pushNamed(context, AppRoutes.addTask);
//              },
//              child: Icon(Icons.add),
//              tooltip: AppBlocLocalizations.of(context).addTask,
//            );
//          }),
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

    if (state is Month) {
      return AppTab.month;
    } else if (state is Week) {
      return AppTab.week;
    } else if (state is Day) {
      return AppTab.day;
    } else if (state is Task) {
      return AppTab.task;
    } else if (state is Exam) {
      return AppTab.exam;
    } else {
      return AppTab.month;
    }
  }

  getAppBar(AppState state) {
    if (state is Month) {
      return AppBar(
        backgroundColor: Colors.black,
        title: Text("Месяц"),
        actions: [
//              FilterButton(visible: activeTab == AppTab.todos),
//              ExtraActions(),
        ],
      );
    } else if (state is Week) {
      return AppBar(
        title: Text("Неделя"),
        actions: [
//              FilterButton(visible: activeTab == AppTab.todos),
//              ExtraActions(),
        ],
      );
    }

//    else if (state is Day) {
//      return AppBar(
//        title: Text("День"),
//        actions: [
////              FilterButton(visible: activeTab == AppTab.todos),
////              ExtraActions(),
//        ],
//      );
//    }

    else if (state is Task) {
      return AppBar(
        title: Text("Задание"),
        actions: [
//              FilterButton(visible: activeTab == AppTab.todos),
//              ExtraActions(),
        ],
      );
    } else if (state is Exam) {
      return AppBar(
        title: Text("Экзамен"),
        actions: [
//              FilterButton(visible: activeTab == AppTab.todos),
//              ExtraActions(),
        ],
      );
    }
//    else {
//      return AppBar(
//        backgroundColor: Colors.black,
//        title: Text("Месяц"),
//        actions: [
////              FilterButton(visible: activeTab == AppTab.todos),
////              ExtraActions(),
//        ],
//      );
//    }
  }
}
