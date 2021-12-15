import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/main.dart';
import 'package:my_expenses/model/expense/expense.dart';
import 'package:my_expenses/model/expense/expenses_types.dart';
import 'package:my_expenses/services/app_api.dart';
import 'package:my_expenses/services/locator.dart';
import 'package:my_expenses/tabs/expenses_list/expense_page/expense_page.dart';
import 'package:my_expenses/tabs/expenses_list/expense_page/photo_view_page.dart';
import 'package:my_expenses/utils/expense/expense_text_form.dart';
import 'package:my_expenses/utils/loading_screen.dart';

class ExpenseAddPage extends StatefulWidget {
  const ExpenseAddPage({Key? key, required this.onAccept,
    this.name = "",
    this.total = "",
    this.image = null}) : super(key: key);

  final Function onAccept;
  final String name;
  final String total;
  final Image? image;

  @override
  State<ExpenseAddPage> createState() => _ExpenseAddPageState();
}

class _ExpenseAddPageState extends State<ExpenseAddPage> {
  final _apiService = locator<Api>();

  String name = "";
  double total = 0.0;
  DateTime date = DateTime.now();
  static String _dateFormat = 'dd/MM/yyyy';
  final List<ExpenseType> _filter = [
    ExpenseType.food,
    ExpenseType.transportation,
    ExpenseType.utilities,
    ExpenseType.healthcare,
    ExpenseType.fun
  ];
  final List<bool> _selectedFilters = [false, false, false, false, false];
  List<ExpenseType> _openedFilters = List.empty();
  bool _saveLoading = false;

  late String _dateLabel;

  @override
  void initState() {
    super.initState();
    _dateLabel = DateFormat(_dateFormat).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return !_saveLoading ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor.withOpacity(0.7)),
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor.withOpacity(0.7)),
        titleTextStyle: TextStyle(color: Colors.white38, fontSize: 15),
        toolbarTextStyle: TextStyle(color: Colors.white38),
        actions: [
          _buildAddButton(context),
        ],
        title: const Text("Add new receipt"),
      ),
      body: buildExpenseInfo(),

    ) : LoadingScreen();
  }

  _getImage() {
    return ImageContainer(image: widget.image, onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => PhotoViewPage(file: widget.image!.image),
          fullscreenDialog: true,
        ),
      );
    },);
  }

  Column buildExpenseInfo() {
    return Column(
      children: [
        widget.image != null ? _getImage() : Container(),
        SizedBox(height: 10,),
        _buildChips(),
        SizedBox(height: 20,),
        buildTextFormField(CupertinoIcons.money_dollar_circle_fill,
            'Total', widget.total.toString(), (String value) {setState(() {
              total = double.parse(value.replaceAll(",", "."));
            });},
        TextInputType.numberWithOptions(decimal: true, signed: false)),
        buildTextFormField(CupertinoIcons.chat_bubble_text_fill,
            'Name', widget.name, (value) {setState(() {
              name = value;
            });},
            TextInputType.text),
       SizedBox(height: 15,),
       _buildDatePickerButton(),
      ],
    );
  }

  Widget buildTextFormField(
      IconData iconData,
      String name,
      String initialValue,
      Function onSaved,
      TextInputType textInputType
      ) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 170),
        child: ExpenseTextForm(
          name: name,
          initialValue: initialValue,
          icon: iconData,
          enabled: true,
          onSaved: onSaved,
          textInputType: textInputType,
        ));
  }

  IconButton _buildAddButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: () async {
        setState(() {
          _saveLoading = true;
        });

        var t = total == 0.0 ? double.parse(widget.total) : total;
        var n = name.isEmpty ? widget.name : name;

        await _apiService.addExpense(10, Expense(-1, t, date, n, _openedFilters));

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (_, __, ___) => MyHomePage(title: ""),
          ),
        );
      },
    );
  }

  // Date Range picker
  Widget _buildDatePickerButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 170),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton.icon(
              style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0)),
              onPressed: () {_dateTimeRangePicker();},
              label: Text("  "+_dateLabel, style:  TextStyle(color: Colors.white38.withOpacity(0.4), fontSize: 17)),
              icon: const Icon(CupertinoIcons.calendar_today, size: 25, color: Colors.white24),
          ),
        ],
      ),
    );
  }

  void _dateTimeRangePicker() async {
    DateTime? picked = await showDatePicker(
        initialDate: DateTime.now(),
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
      if (picked != null) {
        date = picked;
        _dateLabel = DateFormat(_dateFormat).format(date);
      }
    });
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.only(left: 15,),
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
      ]),
    );
  }

  FilterChip _createFilterChip(int index) {
    return FilterChip(
      backgroundColor: Colors.white38.withOpacity(0.4),
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
              size: 27)),
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
        _openedFilters = [_filter[index]];
        for (int i = 0; i < _selectedFilters.length; i++) {
          _selectedFilters[i] = false;
        }
      } else {
        _openedFilters = _openedFilters.toList();
        _openedFilters.remove(_filter[index]);
      }
      _selectedFilters[index] = value;
    });
  }
}
