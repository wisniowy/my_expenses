import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_expenses/tabs/expenses_list/expenses_list.dart';

import 'expandable_fab.dart';
import 'nav_bar.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xffFF8527), //Head background
        // : Colors.red, //selection color
        // dialogBackgroundColor: Colors.white, //Background color
        colorScheme:  ColorScheme.fromSwatch().copyWith(
          primary: Colors.black45,
          secondary: const Color(0xffFF8527),
          onSurface: Colors.white38,
          onPrimary: const Color(0xffFF8527).withOpacity(0.7),
          onBackground: Colors.black45

        ),
        dialogBackgroundColor: Colors.black87,
        highlightColor: const Color(0xffFF8527),
      // theme: ThemeData(
      //     primaryColor: const Color(0xffFF8527),
      //     backgroundColor: const Color(0xffFF8527),
      //     brightness: Brightness.dark, //Selection color
      //   highlightColor: const Color(0xffFF8527),
      //   splashColor: const Color(0xffFF8527),
      //   textSelectionTheme: TextSelectionThemeData(selectionColor: const Color(0xffFF8527)),
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //   secondary: Colors.red, // Your accent color
        //   primary: const Color(0xffFF8527),
        //   brightness: Brightness.dark,
        //   background:  const Color(0xffFF8527),
        //   onBackground: Colors.black45
        // ),
        // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xffFF8527)),
        // accentColor: Colors.black
        // primarySwatch: const Color(0xffFF8527),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIdx = 1;

  final List _children = [
    PlaceholderWidget(Colors.white),
    ExpensesList(),
    PlaceholderWidget(Colors.green)
  ];

  String? _imagePath;

  void onTabTapped(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  Future<void> _getImage() async {
    String? imagePath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      imagePath = (await EdgeDetection.detectEdge);
      print("$imagePath");
    } on PlatformException catch (e) {
      imagePath = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIdx],
        floatingActionButton: ExpandableFab(
            distance: 70.0,
            children: [
            ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.edit),
          ),
          ActionButton(
            onPressed: () => {_getImage()},
            icon: const Icon(Icons.photo_camera_rounded),
          ),
        ]),
        bottomNavigationBar: BottomNavBar(
          children: [ IconBottomBar(
              text: "Charts",
              icon: Icons.insert_chart,
              selected: _selectedIdx == 0,
              onPressed: () => onTabTapped(0)
          ),
            IconBottomBar(
                text: "Home",
                icon: Icons.home,
                selected: _selectedIdx == 1,
                onPressed: () => onTabTapped(1)
            ),
            IconBottomBar(
                text: "Settings",
                icon: Icons.settings,
                selected: _selectedIdx == 2,
                onPressed: () => onTabTapped(2)
            )
          ],
        ));
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}