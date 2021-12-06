import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:my_expenses/expense.dart';
import 'package:my_expenses/expenses_types.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key}) : super(key: key);

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  ScrollController _sc = new ScrollController();
  List<Expense> _allExpenses = List.generate(
      15,
      (index) =>
          new Expense(index, index.toDouble(), "2021-", "mock" + index.toString(), [ExpenseType.fun]));


  LinkedHashMap<int, Expense> _filteredExpenses = LinkedHashMap();


  final List<ExpenseType> _filter = [ExpenseType.food, ExpenseType.transportation,
    ExpenseType.utilities, ExpenseType.healthcare, ExpenseType.fun];
  final List<bool> _selectedFilters = [false, false, false, false, false];
  List<ExpenseType> _openedFilters = List.empty();

  bool isLoading = false;
  int page = 0;

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

  void _runFilter() {
    print(_openedFilters.toString());
    if (_openedFilters.isEmpty) {
      _buildExpenseMap(_allExpenses);
      print(_filteredExpenses.toString());
      return;
    }

    LinkedHashMap<int, Expense> resMap = new LinkedHashMap();
    for (ExpenseType expenseType in _openedFilters) {
      List<Expense> result = _allExpenses
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
    int lastIndex = _allExpenses.length;

    setState(() {
      _allExpenses.addAll(List.generate(
          15,
          (index) => new Expense(index,
              index.toDouble(), "2021-", "mock" + index.toString(), [ExpenseType.food])));
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
        itemCount: isLoading ? _filteredExpenses.length + 1 : _filteredExpenses.length,
        itemBuilder: (context, index) {
          if (_filteredExpenses.length == index)
            return Center(
                child: CircularProgressIndicator(
              color: Colors.black38,
            ));
          return ExpenseTile(
            name: _filteredExpenses.values.elementAt(index).name,
            date: _filteredExpenses.values.elementAt(index).date,
            price: _filteredExpenses.values.elementAt(index).price,
            onTap: () {},
          );
        });
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Container(child: _buildList());

    return  Column(
    children: [
    const SizedBox(
    height: 30,
    ),
      Row(
        children: [SizedBox(width: 10,),
          _createFilterChip(0),
          SizedBox(width: 8,),
          _createFilterChip(1),
          SizedBox(width: 8,),
          _createFilterChip(2),
          SizedBox(width: 8,)]
      ),
      Row(
        children: [SizedBox(width: 10,),
          _createFilterChip(3),
          SizedBox(width: 8,),
        _createFilterChip(4),
          SizedBox(width: 8,)]
      ),
      // Row(
      //   children: [for (int i = 4; i < _filter.length; i++) _createFilterChip(i)],
      // ),
    const SizedBox(
    height: 2,
    ),
      Expanded(child: _buildList())
    ]);
  }

  FilterChip _createFilterChip(int index) {
    return FilterChip(
      label: Text(_filter[index].str(),
          style: TextStyle(
              color: _selectedFilters[index]
                  ? Theme.of(context).primaryColor.withOpacity(0.9)
                  : Colors.black45)),
      showCheckmark: false,
      // selectedColor: Theme.of(context).primaryColor,
      avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(_filter[index].icon(),
              color: _selectedFilters[index]
                  ? Theme.of(context).primaryColor.withOpacity(0.5)
                  : Colors.black38,
              size: 22)),

      padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      labelPadding: const EdgeInsets.only(left: 0, right: 10),
      shape: StadiumBorder(
          side: BorderSide(
              color: _selectedFilters[index]
                  ? Theme.of(context).primaryColor.withOpacity(0.5)
                  : Colors.black38)),
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

          if(_filteredExpenses.isEmpty) {
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

  Future<void> _getMoreData(int index) async {
    // if (!isLoading) {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   final List<Expense> tList = await getMock();

    setState(() {
      isLoading = false;
      // expenses.addAll(tList);
      page++;
    });
    // }
  }

  Future<List<Expense>> getMock() {
    List<Expense> l = List.empty();

    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) {
        l.add(new Expense(i, i.toDouble(), "2021-", "mock" + i.toString(), [ExpenseType.food]));
      } else {
        l.add(new Expense(i, i.toDouble(), "2021-", "mock" + i.toString(), [ExpenseType.fun]));
      }

    }

    return Future.delayed(
      const Duration(seconds: 2),
      () => l,
    );
  }
}

// class ExpenseTile extends StatelessWidget {
//   const ExpenseTile({Key? key, required this.date,
//     required this.price,
//     required this.name}) : super(key: key);
//
//   final String date;
//   final double price;
//   final String name;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(Icons.do),
//       title: Text(name),
//       subtitle: Text(date),
//     );
//   }
// }

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

            // Chip(
            //   visualDensity: VisualDensity.compact,
            //     padding: const EdgeInsets.only(left :0, right : 0, top: 0, bottom: 0),
            //     labelPadding: const EdgeInsets.only(left :2, right : 10),
            //           avatar: CircleAvatar(
            //             maxRadius: 11,
            //             backgroundColor: Colors.grey.shade800,
            //             child: const Icon(Icons.local_grocery_store, size: 15),
            //           ),
            //           label: const Text('Groceries', textScaleFactor: 0.8,)
            //      )
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
