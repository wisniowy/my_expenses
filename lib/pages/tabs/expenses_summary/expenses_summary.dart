import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:my_expenses/pages/tabs/expenses_summary/cards/monthly_line_chart.dart';
import 'package:my_expenses/pages/tabs/expenses_summary/cards/total_spending_cards.dart';
import 'package:my_expenses/pages/tabs/expenses_summary/summary_card.dart';
import 'package:my_expenses/services/firestore.dart';
import 'package:provider/src/provider.dart';

import 'cards/expenses_pie_chart.dart';

class ExpensesSummary extends StatefulWidget {
  const ExpensesSummary({Key? key}) : super(key: key);

  @override
  _ExpensesSummaryState createState() => _ExpensesSummaryState();
}

class _ExpensesSummaryState extends State<ExpensesSummary> {
  final ScrollController _sc = ScrollController();

  DateTime selectedDate = DateTime.now();
  late List<SummaryCard> cards;
  late double monthsTotal;
  late List<double> monthly;
  late Map<String, double> monthlyPercentage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  List<SummaryCard> _cards() {
    return [
      SummaryCard(
        child: _isLoading
            ? CircularProgressIndicator(
                color: Colors.black38,
              )
            : TotalSpendingsCard(
                total: monthsTotal,
                selectedDate: selectedDate,
              ),
        tiltle: "Total",
      ),
      SummaryCard(
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Colors.black38,
                )
              : LineChartExample(
                  isShowingMainData: true,
                  monthlyData: monthly,
                ),
          tiltle: "Monthly"),
      SummaryCard(
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Colors.black38,
                )
              : PieChartSample1(
                  expenseTypesTotal: monthlyPercentage,
                ),
          tiltle: 'Percentage')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          _buildDatePickerButton(),
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
        itemCount: _cards().length,
        itemBuilder: (context, index) {
          return _cards()[index];
        });
  }

  TextButton _buildDatePickerButton() {
    return TextButton.icon(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.only(left: 4, top: 0, bottom: 0)),
      onPressed: () {
        showMonthPicker(
          context: context,
          firstDate: DateTime(DateTime.now().year - 5, 1),
          lastDate: DateTime(DateTime.now().year, DateTime.now().month),
          initialDate: DateTime.now(),
          locale: Locale("en"),
        ).then((date) {
          if (date != null) {
            setState(() {
              selectedDate = date;
              _fetchData();
            });
          }
        });
      },
      label: Text(DateFormat('MMMM yyyy').format(selectedDate),
          style: const TextStyle(color: Colors.white24, fontSize: 15)),
      icon: const Icon(CupertinoIcons.calendar_today,
          size: 25, color: Colors.white24),
    );
  }

  void _fetchData() async {
    final resTotal = await context
        .read<FlutterFireStoreService>()
        .getMonthlyExpenses(selectedDate.month, selectedDate.year);

    final List<double> resMonthly = await context
        .read<FlutterFireStoreService>()
        .getMonthly(selectedDate.year);

    setState(() {
      monthsTotal = resTotal.total;
      monthly = resMonthly;
      monthlyPercentage = resTotal.percentage;
      _isLoading = false;
    });
  }
}
