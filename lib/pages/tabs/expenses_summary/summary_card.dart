import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({Key? key, required this.child, required this.tiltle}) : super(key: key);

  final Widget child;
  final String tiltle;

  @override
  Widget build(BuildContext context) {
    return Card(
          color: Colors.black12,
          semanticContainer: true,
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text(tiltle, style: TextStyle(color: Colors.white24)),
              child,
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          elevation: 5,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        );
  }
}
