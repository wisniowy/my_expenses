import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_expenses/pages/tabs/expenses_list/expense_add/expense_add_page.dart';
import 'package:my_expenses/pages/tabs/expenses_list/expense_add/ocr_add_page.dart';
import 'package:my_expenses/pages/tabs/expenses_list/expenses_list.dart';
import 'package:my_expenses/pages/tabs/expenses_summary/expenses_summary.dart';
import 'package:my_expenses/pages/tabs/settings/settings.dart';
import 'package:my_expenses/services/firestore.dart';
import 'package:provider/src/provider.dart';


import 'expandable_fab.dart';
import 'nav_bar.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.user}) : super(key: key);
  final String title;
  final User user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIdx = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print(widget.user.uid);
    _loading();

    _children = [
      ExpensesSummary(),
      ExpensesList(userId: widget.user.uid),
      SettingsPage(),
    ];
  }

  Future _loading() async {
    await context.read<FlutterFireStoreService>().addUser(widget.user.uid);

    setState(() {
      isLoading = false;
    });
  }

  late List _children;

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

    } on PlatformException catch (e) {
      imagePath = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if(imagePath == null) return;

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => OcrAddPage(image: FileImage(File(imagePath!))),
        fullscreenDialog: true,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: _children[_selectedIdx],
        floatingActionButton: ExpandableFab(
            distance: 70.0,
            children: [
              ActionButton(
                onPressed: () => {_onManualEdit()},
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

  _onManualEdit() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ExpenseAddPage(date: DateTime.now(), onAccept: () {},),
        fullscreenDialog: true,
      ),
    );
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