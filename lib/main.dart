import 'package:flutter/material.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: const Color(0xffFF8527),
          backgroundColor: const Color(0xffFF8527),
          brightness: Brightness.dark,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
        floatingActionButton: ExpandableFab(
            distance: 70.0,
            children: [
            ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.edit),
          ),
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.photo_camera_rounded),
          ),
        ]),
        bottomNavigationBar: BottomNavBar(
          children: [ IconBottomBar(
              text: "Charts",
              icon: Icons.insert_chart,
              selected: _selectedIdx == 0,
              onPressed: () {
                setState(() {
                  _selectedIdx = 0;
                });
              }),
            IconBottomBar(
                text: "Home",
                icon: Icons.home,
                selected: _selectedIdx == 1,
                onPressed: () {
                  setState(() {
                    _selectedIdx = 1;
                  });
                }),
            IconBottomBar(
                text: "Settings",
                icon: Icons.settings,
                selected: _selectedIdx == 2,
                onPressed: () {
                  setState(() {
                    _selectedIdx = 2;
                  });
                })
          ],
        ));
  }
}
