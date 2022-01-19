import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses/auth/firebase.dart';
import 'package:my_expenses/pages/tabs/expenses_summary/summary_card.dart';
import 'package:provider/src/provider.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ScrollController _sc = ScrollController();

  DateTime selectedDate = DateTime.now();
  late  List<SummaryCard> cards;
  late double monthsTotal;
  late List<double> monthly;
  late Map<String, double> monthlyPercentage;

  @override
  void initState() {
    super.initState();
  }

  List<Card> _cards() {
    return [
      Card(
        color: Colors.black12,
        semanticContainer: true,
        child: ListTileTheme(
          textColor: Colors.white38,
          iconColor: Theme.of(context).primaryColor,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 15,
              child: Icon(Icons.lock, color: Theme.of(context).primaryColor.withOpacity(0.5),),),
              title: Text("Sign out"),
              onTap: () {
                context.read<FlutterFireAuthService>().signOut();
              },
          ),
        ),
      )
  ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SETTINGS",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: _sc,
        itemCount:  _cards().length,
        itemBuilder: (context, index) {
          return  _cards()[index];
        });
  }
}