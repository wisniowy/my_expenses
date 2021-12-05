import 'package:flutter/material.dart';
import 'package:my_expenses/expense.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key}) : super(key: key);

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  ScrollController _sc = new ScrollController();
  List<Expense> expenses = List.generate(
      15,
      (index) =>
          new Expense(index.toDouble(), "2021-", "mock" + index.toString()));
  bool isLoading = false;
  int page = 0;

  @override
  void initState() {
    _sc.addListener(_onScroll);
    super.initState();
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
    int lastIndex = expenses.length;

    setState(() {
      expenses.addAll(List.generate(
          15,
          (index) => new Expense(
              index.toDouble(), "2021-", "mock" + index.toString())));
      isLoading = false;
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
        itemCount: isLoading ? expenses.length + 1 : expenses.length,
        itemBuilder: (context, index) {
          if (expenses.length == index)
            return Center(
                child: CircularProgressIndicator(
              color: Colors.black38,
            ));
          return ExpenseTile(
            name: expenses[index].name,
            date: expenses[index].date,
            price: expenses[index].price,
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
    return Container(child: _buildList());
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
      l.add(new Expense(i.toDouble(), "2021-", "mock" + i.toString()));
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