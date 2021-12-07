import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../expense.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key, required this.expense}) : super(key: key);

  final Expense expense;

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {

  bool _imageLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _downloadImage();
  }

  Future<void> _downloadImage() async {
    await Future.delayed(const Duration(seconds: 2),);

    setState(() {
      _imageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.black45,
    iconTheme: IconThemeData(color: Colors.white54),
    actionsIconTheme: IconThemeData(color: Colors.white38),
    titleTextStyle: TextStyle(color: Colors.white38, fontSize: 15),
    toolbarTextStyle: TextStyle(color: Colors.white38),
    actions: [IconButton(
      icon: Icon(Icons.delete_outlined),
      onPressed: () {_onDelete(context);},
    ),],
    title: Text(widget.expense.name),
    ),
    body: Column(
    children: [
      _imageLoading ? Column(
        children: [
          SizedBox(height: 30,),
          CircularProgressIndicator(
            color: Colors.black38,
          ),
        ],
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: 400,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/paragon5.png',
                fit: BoxFit.fitWidth,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            ),
          )
        ],
      ),

    Row(children: [

    ],),

      Padding(
        padding: const EdgeInsets.only(left: 20, right: 170),

        child: TextFormField(
          style: TextStyle(color: Colors.white70),
          initialValue: widget.expense.price.toString() + " PLN",
          enabled: false,
          decoration: const InputDecoration(
            icon: Icon(Icons.attach_money,
                size: 25, color: Colors.white24),
            border: UnderlineInputBorder(),
            labelText: 'Total',
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 20, right: 170),

        child: TextFormField(
          style: TextStyle(color: Colors.white70),
          initialValue: widget.expense.name,
          enabled: false,
          decoration: const InputDecoration(
            icon: Icon(CupertinoIcons.chat_bubble_text_fill,
                size: 25, color: Colors.white24),
            border: UnderlineInputBorder(),
            labelText: 'Name',
          ),
        ),
      ),
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 170),

      child: TextFormField(
        style: TextStyle(color: Colors.white70),
        initialValue: DateFormat("dd/MM/yyyy").format(widget.expense.date),
        enabled: false,
      decoration: const InputDecoration(
        icon: Icon(CupertinoIcons.calendar_today,
            size: 25, color: Colors.white24),
      border: UnderlineInputBorder(),
      labelText: 'Date',
      ),
      ),
    ),
    ],
    ),
    );
  }

  void _onDelete(BuildContext context) {
    Navigator.pop(context);
  }
}
