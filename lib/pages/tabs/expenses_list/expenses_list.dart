import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/model/expense/expense.dart';
import 'package:my_expenses/model/expense/expenses_types.dart';
import 'package:my_expenses/services/app_api.dart';
import 'package:my_expenses/services/firestore.dart';
import 'package:my_expenses/services/locator.dart';
import 'package:provider/src/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import 'expense_page/expense_page.dart';
import 'expense_tile.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  final ScrollController _sc = ScrollController();

  late List<Expense> _allExpenses;
  late LinkedHashMap<String, Expense> _filteredExpenses = LinkedHashMap();

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
  static String _dateFormat = 'dd/MM/yyyy';

  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    _allExpenses = [];
    _fetchData();
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Column(children: [
        const SizedBox(height: 30,),
        Row(children: [
          const SizedBox(width: 10,),
          _createFilterChip(0),
          const SizedBox(width: 8,),
          _createFilterChip(1),
          const SizedBox(width: 8,),
          _createFilterChip(2),
          const SizedBox(width: 8,)]),
        Row(children: [
          const SizedBox(width: 10,),
          _createFilterChip(3),
          const SizedBox(width: 8,),
          _createFilterChip(4),
          const SizedBox(width: 4,)]),
        Row(children: [
          const SizedBox(width: 8,),
          _buildDatePickerButton(),],),
        const Divider(color: Colors.black45),
        Expanded(child: _buildList())
      ]),
    );
  }

  Future _fetchData() async {
    List<Expense> expenses = await context.read<FlutterFireStoreService>().getExpenses();
    print(expenses);
    pageNumber = pageNumber + 1;
    setState(() {
      _allExpenses.addAll(expenses);
      isLoading = false;
      _runFilter();
    });
  }

  Widget _buildList() {
    return StickyGroupedListView<Expense, String>(
        stickyHeaderBackgroundColor: Colors.transparent,
      elements: _filteredExpenses.values.toList(),
      groupBy: (Expense element) => element.date.toString(),
      groupSeparatorBuilder: (Expense element) => _createListGroupSeparator(element),
      itemBuilder: (context, Expense element) => _createExpenseTile(element, context),
      itemComparator: (element1, element2) => compareTo(element1, element2), // optional
      itemScrollController: GroupedItemScrollController(), // optional
      order: StickyGroupedListOrder.DESC, // optional
    );
  }

  int compareTo(Expense element1, Expense element2) {
    final DateTime firstDate = DateTime(element1.date.year, element1.date.month, element1.date.day);
    final DateTime secondDate = DateTime(element2.date.year, element2.date.month, element2.date.day);

    print(firstDate.toString());
    print(secondDate.toString());

    if (firstDate.year == secondDate.year && firstDate.month == secondDate.month && firstDate.day == secondDate.day) {
      return 0;
    }

    return firstDate.compareTo(secondDate);
  }

  Row _createListGroupSeparator(Expense element) {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
          ),
          Text(_getSeparatorText(element), style: TextStyle(color: Colors.grey),),
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
          ),
        ]);
  }

  String _getSeparatorText(Expense element) {
    final today = DateTime.now();
    if (element.date.day == today.day
        && element.date.month == today.month
        && element.date.year == today.year) {
      return "Today";
    }

    final yesterday = DateTime.now().subtract(Duration(days:1));
    if (element.date.day == yesterday.day
        && element.date.month == yesterday.month
        && element.date.year == yesterday.year) {
      return "Yesterday";
    }

    return DateFormat(_dateFormat).format(element.date).toString();
  }

  Card _createExpenseTile(Expense element, BuildContext context) {
    return Card(
          color: Colors.black12,
          child: ExpenseTile(
            name: element.name,
            date: DateFormat(_dateFormat)
                .format(element.date),
            price: element.price,
            onTap: () {
              onExpenseTileTap2(context, element);
            },
          ));
  }

  void onExpenseTileTap(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ExpensePage(expense: _filteredExpenses.values.elementAt(index),
              onDelete: () {resetExpenses();}),
        fullscreenDialog: true,
      ),
    );
  }

  void onExpenseTileTap2(BuildContext context, Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ExpensePage(expense: expense,
                onDelete: () {resetExpenses();}),
        fullscreenDialog: true,
      ),
    );
  }

  // Date Range picker
  TextButton _buildDatePickerButton() {
    return TextButton.icon(
            style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 4, top: 0, bottom: 0)),
            onPressed: () {_dateTimeRangePicker();},
            label: Text(_dateLabel, style: const TextStyle(color: Colors.white24, fontSize: 15)),
            icon: const Icon(CupertinoIcons.calendar_today, size: 25, color: Colors.white24),
          );
  }

  void _dateTimeRangePicker() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                child: child,
              )
            ],
          );
        });

    setState(() {
      if (picked == null) {
        _isDateRangeSelected = false;
        _dateLabel = _defaultDateLabel;
      } else {
        _isDateRangeSelected = true;
        _selectedDateRange = picked;
        String startDate = DateFormat(_dateFormat)
            .format(_selectedDateRange.start);
        String endDate = DateFormat(_dateFormat)
            .format(_selectedDateRange.end);
        _dateLabel = startDate + " - " + endDate;
      }

      _runFilter();
      if (_filteredExpenses.isEmpty) {
        isLoading = true;
        _fetchData();
      }
    });
  }

  bool _dateInSelectedRange(DateTime date) {
    if (_isDateRangeSelected) {
      var startD = _selectedDateRange.start;
      var endD = _selectedDateRange.end;
      var tempDate = DateTime(date.year, date.month, date.day);

      if (tempDate.compareTo(startD) == 0 || tempDate.compareTo(endD) == 0) {
        return true;
      }
      if (tempDate.compareTo(startD) > 0 && tempDate.compareTo(endD) < 0) {
        return true;
      }
      return false;
    }
    return true;
  }

  // Filters
  FilterChip _createFilterChip(int index) {
    return FilterChip(
      backgroundColor: Colors.white38.withOpacity(0.1),
      label: Text(_filter[index].str(),
          style: TextStyle(
              color: _selectedFilters[index]
                  ? Theme.of(context).primaryColor.withOpacity(0.9)
                  : Colors.black87)),
      showCheckmark: false,
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
      onSelected: (bool value) {_onFilterChipSelected(value, index);},
      selected: _selectedFilters[index],
    );
  }

  void _onFilterChipSelected(bool value, int index) {
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
  }

  void _runFilter() {
    LinkedHashMap<String, Expense> resMap = LinkedHashMap();
    List<Expense> allExpensesAfterDateFilter = _allExpenses.where((element) => _dateInSelectedRange(element.date))
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
          .where((element) => element.type == expenseType)
          .toList();

      for (Expense ex in result) {
        resMap.putIfAbsent(ex.id, () => ex);
      }
    }

    _filteredExpenses = resMap;
  }

  void resetExpenses() {
    setState(() {
      _allExpenses.clear();
      _filteredExpenses.clear();
      isLoading = true;
    });

    _fetchData();
  }
}
