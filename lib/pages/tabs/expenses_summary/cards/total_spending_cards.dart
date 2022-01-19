import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalSpendingsCard extends StatefulWidget {
  const TotalSpendingsCard({Key? key, required this.selectedDate, required this.total}) : super(key: key);

  final DateTime selectedDate;
  final double total;

  @override
  State<TotalSpendingsCard> createState() => _TotalSpendingsCardState();
}

class _TotalSpendingsCardState extends State<TotalSpendingsCard> {

  final NumberFormat numberFormat = NumberFormat("###.00");
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Text(numberFormat.format(widget.total),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 35,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                            ),
                            Shadow(
                              color: Colors.orange,
                              blurRadius: 4.0,
                            ),
                          ],),
                      ),

                      Text("  PLN",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 30,),
                      ),

                    ],
                  ),
                ),
              SizedBox(height: 10,)
              ],
            ),
        ],

    );
  }
}
