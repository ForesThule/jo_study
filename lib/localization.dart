import 'package:flutter/widgets.dart';

class AppBlocLocalizations {
  String month = "Месяц";

  String day = "День";

  String week = "Неделя";

  String exam = "Экзамен";

  String task = "Задание";

  String addTask = "Добавить задание";

  static AppBlocLocalizations of(BuildContext context) {
    return Localizations.of<AppBlocLocalizations>(
      context,
      AppBlocLocalizations,
    );
  }

  String get appTitle => "Flutter Todos";
}

class AppBlocLocalizationsDelegate
    extends LocalizationsDelegate<AppBlocLocalizations> {
  @override
  Future<AppBlocLocalizations> load(Locale locale) =>
      Future(() => AppBlocLocalizations());

  @override
  bool shouldReload(AppBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) => true;
//      locale.languageCode.toLowerCase().contains("en");
}
