import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/expense.dart';
import 'package:my_expenses/expenses_types.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'expense_page.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key}) : super(key: key);

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  ScrollController _sc = new ScrollController();
  List<Expense> _allExpenses = List.generate(
      15,
      (index) => new Expense(index, index.toDouble(), DateTime.now(),
          "mock" + index.toString(), [ExpenseType.fun]));

  LinkedHashMap<int, Expense> _filteredExpenses = LinkedHashMap();

  final List<ExpenseType> _filter = [
    ExpenseType.food,
    ExpenseType.transportation,
    ExpenseType.utilities,
    ExpenseType.healthcare,
    ExpenseType.fun
  ];
  final List<bool> _selectedFilters = [false, false, false, false, false];
  List<ExpenseType> _openedFilters = List.empty();

  bool isLoading = false;
  int page = 0;
  final String _defaultDateLabel = "All expenses";
  String _dateLabel = "All expenses";
  DateTimeRange _selectedDateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  bool _isDateRangeSelected = false;
  var _dateFormat = 'dd/MM/yyyy';

  @override
  void initState() {
    _buildExpenseMap(_allExpenses);
    _sc.addListener(_onScroll);
    super.initState();
  }

  void _buildExpenseMap(List<Expense> expenses) {
    _filteredExpenses.clear();

    for (Expense ex in expenses) {
      _filteredExpenses.putIfAbsent(ex.id, () => ex);
    }
  }

  bool _dateInSelectedRange(DateTime date) {
    if (_isDateRangeSelected) {
      var startD = _selectedDateRange.start;
      var endD = _selectedDateRange.end;
      var tempDate = DateTime(date.year, date.month, date.day);

      if (tempDate.compareTo(startD) == 0 || tempDate.compareTo(endD) == 0) {
        return true;
      }

      if (tempDate.compareTo(startD) > 0 && tempDate.compareTo(startD) < 0) {
        return true;
      }
      return false;
    }
    return true;
  }

  void _runFilter() {
    LinkedHashMap<int, Expense> resMap = new LinkedHashMap();
    List<Expense> allExpensesAfterDateFilter = _allExpenses
        .where((element) => _dateInSelectedRange(element.date))
        .toList();

    if (_openedFilters.isEmpty) {
      for (Expense ex in allExpensesAfterDateFilter) {
        resMap.putIfAbsent(ex.id, () => ex);
      }
      _filteredExpenses = resMap;
      return;
    }

    for (ExpenseType expenseType in _openedFilters) {
      List<Expense> result = allExpensesAfterDateFilter
          .where((element) => element.types.contains(expenseType))
          .toList();

      for (Expense ex in result) {
        resMap.putIfAbsent(ex.id, () => ex);
      }
    }

    _filteredExpenses = resMap;
  }

  _onScroll() {
    if (_sc.offset >= _sc.position.maxScrollExtent &&
        !_sc.position.outOfRange) {
      setState(() {
        isLoading = true;
      });
      _fetchData();
    }
  }

  Future _fetchData() async {
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {
      _allExpenses.addAll(List.generate(
          15,
          (index) => new Expense(index, index.toDouble(), DateTime.now(),
              "mock" + index.toString(), [ExpenseType.food])));
      isLoading = false;

      _runFilter();
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Widget _buildList() {
    return ListView.builder(
        controller: _sc,
        itemCount:
            isLoading ? _filteredExpenses.length + 1 : _filteredExpenses.length,
        itemBuilder: (context, index) {
          if (_filteredExpenses.length == index)
            return Center(
                child: CircularProgressIndicator(
              color: Colors.black38,
            ));
          return Card(
            color: Colors.black12,
            child: ExpenseTile(
              name: _filteredExpenses.values.elementAt(index).name,
              date: DateFormat(_dateFormat)
                  .format(_filteredExpenses.values.elementAt(index).date),
              price: _filteredExpenses.values.elementAt(index).price,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ExpensePage(expense: _filteredExpenses.values.elementAt(index),),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Column(
          children: [
        const SizedBox(
          height: 30,
        ),
        Row(children: [
          SizedBox(
            width: 10,
          ),
          _createFilterChip(0),
          SizedBox(
            width: 8,
          ),
          _createFilterChip(1),
          SizedBox(
            width: 8,
          ),
          _createFilterChip(2),
          SizedBox(
            width: 8,
          )
        ]),
        Row(children: [
          SizedBox(
            width: 10,
          ),
          _createFilterChip(3),
          SizedBox(
            width: 8,
          ),
          _createFilterChip(4),
          SizedBox(
            width: 4,
          )
        ]),
        Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 4, top: 0, bottom: 0)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // title: Text(''),
                        content: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              getDateRangePicker(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InputChip(
                                    label: Text(
                                      "OK",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white38,
                                      ),
                                    ),
                                    avatar: Icon(Icons.check,
                                        size: 20, color: Colors.white54),
                                    onPressed: () {
                                      setState(() {
                                        String startDate = DateFormat(_dateFormat)
                                            .format(_selectedDateRange.start);
                                        String endDate = DateFormat(_dateFormat)
                                            .format(_selectedDateRange.end);
                                        _dateLabel = startDate + " - " + endDate;
                                        _isDateRangeSelected = true;
                                        _runFilter();
                                        if (_filteredExpenses.isEmpty) {
                                          isLoading = true;
                                          _fetchData();
                                        }
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  InputChip(
                                    label: Text(
                                      "Clear",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white38,
                                      ),
                                    ),
                                    avatar: Icon(Icons.clear_rounded,
                                        size: 20, color: Colors.white54),
                                    onPressed: () {
                                      setState(() {
                                        _dateLabel = _defaultDateLabel;
                                        _isDateRangeSelected = false;
                                        _runFilter();
                                        if (_filteredExpenses.isEmpty) {
                                          isLoading = true;
                                          _fetchData();
                                        }
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              label: Text(_dateLabel,
                  style: TextStyle(color: Colors.white24, fontSize: 15)),
              icon: Icon(CupertinoIcons.calendar_today,
                  size: 25, color: Colors.white24),
            ),
          ],
        ),
        // Row(
        //   children: [for (int i = 4; i < _filter.length; i++) _createFilterChip(i)],
        // ),
        Divider(color: Colors.black45),
        // const SizedBox(
        //   height: 1,
        // ),
        Expanded(child: _buildList())
      ]),
    );
  }

  Widget getDateRangePicker() {
    return Container(
        height: 250,
        child: Card(
            child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: selectionChanged,
                rangeSelectionColor:
                    Theme.of(context).primaryColor.withOpacity(0.5),
                startRangeSelectionColor: Theme.of(context).primaryColor,
                endRangeSelectionColor: Theme.of(context).primaryColor,
                todayHighlightColor:
                    Theme.of(context).primaryColor.withOpacity(0.4),
                selectionTextStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.bold),
                rangeTextStyle: const TextStyle(
                  color: Colors.black45,
                ),
                selectionColor: Theme.of(context).primaryColor,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.white54),
                  todayTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.7)),
                ),
                yearCellStyle: DateRangePickerYearCellStyle(
                  todayTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.7)),
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.white54),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          color: Colors.white70)),
                ))));
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    _selectedDateRange = DateTimeRange(
        start: args.value.startDate,
        end: args.value.endDate ?? args.value.startDate);

    SchedulerBinding.instance!.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  FilterChip _createFilterChip(int index) {
    return FilterChip(
      backgroundColor: Colors.white38.withOpacity(0.1),
      label: Text(_filter[index].str(),
          style: TextStyle(
              color: _selectedFilters[index]
                  ? Theme.of(context).primaryColor.withOpacity(0.9)
                  : Colors.black87)),
      showCheckmark: false,
      // selectedColor: Theme.of(context).primaryColor,
      avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(_filter[index].icon(),
              color: _selectedFilters[index]
                  ? Theme.of(context).primaryColor.withOpacity(0.5)
                  : Colors.black45,
              size: 22)),

      padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      labelPadding: const EdgeInsets.only(left: 0, right: 10),
      shape: StadiumBorder(
          side: BorderSide(
              color: _selectedFilters[index]
                  ? Theme.of(context).primaryColor.withOpacity(0.5)
                  : Colors.black87)),
      onSelected: (bool value) {
        setState(() {
          if (value) {
            _openedFilters = _openedFilters.toList();
            _openedFilters.add(_filter[index]);
          } else {
            _openedFilters = _openedFilters.toList();
            _openedFilters.remove(_filter[index]);
          }
          _runFilter();

          if (_filteredExpenses.isEmpty) {
            isLoading = true;
            _fetchData();
          }

          _selectedFilters[index] = value;
        });
      },
      // backgroundColor: Colors.transparent,
      selected: _selectedFilters[index],
      // shape: StadiumBorder(side: BorderSide()),
    );
  }

  Future<List<Expense>> getMock() {
    List<Expense> l = List.empty();

    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) {
        l.add(new Expense(i, i.toDouble(), DateTime.now(),
            "mock" + i.toString(), [ExpenseType.food]));
      } else {
        l.add(new Expense(i, i.toDouble(), DateTime.now(),
            "mock" + i.toString(), [ExpenseType.fun]));
      }
    }

    return Future.delayed(
      const Duration(seconds: 2),
      () => l,
    );
  }
}

class ExpenseTile extends StatelessWidget {
  final String name;
  final String date;
  final double price;
  final Widget trailingIcon = const Icon(Icons.arrow_right);
  final Function() onTap;

  const ExpenseTile(
      {required this.onTap,
      Key? key,
      required this.name,
      required this.date,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black38,
          radius: 15,
          child: Icon(
            Icons.attach_money,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              price.toString(),
              style: TextStyle(color: Colors.white70),
              textScaleFactor: 1.2,
            ),
            SizedBox(width: 15.0),
            Text(
              "PLN",
              textScaleFactor: 0.9,
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(name),
            Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(width: 4, height: 4),
                )),
            Text(date),
          ],
        ),
        trailing: Icon(Icons.arrow_right, color: Colors.white38),
        selected: false,
        onTap: onTap,
      ),
      textColor: Colors.white38,
      iconColor: Theme.of(context).primaryColor,
    );
  }
}
