import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:jo_study/bloc/blocs.dart';
import 'package:jo_study/model/task.dart';
import 'package:jo_study/repositoty.dart';
import 'package:jo_study/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'model/classwork.dart';
import 'model/exam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//  var path = Directory.current.p?ath;

  Directory appDocDirectory = await getApplicationDocumentsDirectory();

  new Directory(appDocDirectory.path + '/' + 'dir').create(recursive: true)
// The created directory is returned as a Future.
      .then((Directory directory) {
    print('Path of New Dir: ' + directory.path);
  });

  Hive
    ..init(appDocDirectory.path)
    ..registerAdapter(ClassworkAdapter())
    ..registerAdapter(TaskAdapter())
    ..registerAdapter(ExamAdapter());

  runApp(MyApp());
}

//runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: [
          const Locale('en'), // English
          const Locale('ru'),
          const Locale.fromSubtags(
              languageCode: 'zh'), // Chinese *See Advanced Locales below*
          // ... other locales the app supports
        ],
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Flutter Demo',

        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
          scaffoldBackgroundColor: Colors.black54,
          appBarTheme: AppBarTheme(brightness: Brightness.dark,color: Colors.black54),
//          colorScheme: ColorScheme.dark(),

          fontFamily: 'Raleway',

          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          ),
        ),
//        darkTheme: ThemeData.dark(),

//        darkTheme: ThemeData(
//            textTheme: GoogleFonts.lobsterTextTheme(
//          Theme.of(context).textTheme,
//        )),


//        theme: ThemeData(
//          primarySwatch: Colors.grey,
//        ),
        home: BlocProvider(
          create: (context) => AppBloc(repo: AppRepository()),
          child: HomeScreen(),
        )
//      home: BlocProvider(blocs: [AppBloc(excerciseRepository: ExcerciseRepositoryFlutter())],),
        );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
