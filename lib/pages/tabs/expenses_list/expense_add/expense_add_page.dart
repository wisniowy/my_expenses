import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/main.dart';
import 'package:my_expenses/model/expense/expense.dart';
import 'package:my_expenses/model/expense/expenses_types.dart';
import 'package:my_expenses/pages/tabs/expenses_list/expense_page/expense_page.dart';
import 'package:my_expenses/pages/tabs/expenses_list/expense_page/photo_view_page.dart';
import 'package:my_expenses/services/firestore.dart';
import 'package:my_expenses/utils/loading_screen.dart';
import 'package:provider/src/provider.dart';

class ExpenseAddPage extends StatefulWidget {
  const ExpenseAddPage(
      {Key? key,
      required this.onAccept,
      this.name,
      this.total,
      this.image,
      this.date})
      : super(key: key);

  final Function onAccept;

  final String? name;
  final double? total;
  final FileImage? image;
  final DateTime? date;

  @override
  State<ExpenseAddPage> createState() => _ExpenseAddPageState();
}

class _ExpenseAddPageState extends State<ExpenseAddPage> {
  static const primColor = const Color(0xfff9844a);

  late TextEditingController nameController;
  bool _nameValidate = false;
  late TextEditingController totalController;
  bool _totalValidate = false;
  bool _chipValidate = false;

  late DateTime date;

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
    final total = widget.total == null ? "" : widget.total.toString();
    nameController = TextEditingController(text: widget.name ?? "");
    totalController = TextEditingController(text: total.toString());
    date = widget.date ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    _dateLabel = DateFormat(_dateFormat).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return !_saveLoading
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.black45,
              iconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor.withOpacity(0.7)),
              actionsIconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor.withOpacity(0.7)),
              titleTextStyle: TextStyle(color: Colors.white38, fontSize: 15),
              toolbarTextStyle: TextStyle(color: Colors.white38),
              actions: [
                _buildAddButton(context),
              ],
              title: const Text("Add new receipt"),
            ),
            body: buildExpenseInfo(),
          )
        : LoadingScreen();
  }

  _getImage() {
    return ImageContainer(
      image: Image(fit: BoxFit.fitWidth, image: widget.image!),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => PhotoViewPage(
                file: Image(fit: BoxFit.fitWidth, image: widget.image!).image),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  Column buildExpenseInfo() {
    return Column(
      children: [
        widget.image != null ? _getImage() : Container(),
        SizedBox(
          height: 10,
        ),
        _buildChips(),
        SizedBox(
          height: 20,
        ),
        buildTextFormField(
            CupertinoIcons.money_dollar_circle_fill,
            'Total',
            totalController,
            TextInputType.numberWithOptions(decimal: true, signed: false),
            () => _totalValidate ? 'Total is Empty or in wrong format' : null),
        buildTextFormField(
            CupertinoIcons.chat_bubble_text_fill,
            'Name',
            nameController,
            TextInputType.text,
            () => _nameValidate ? 'Name Can\'t Be Empty' : null),
        SizedBox(
          height: 15,
        ),
        _buildDatePickerButton(),
      ],
    );
  }

  Widget buildTextFormField(
      IconData iconData,
      String name,
      TextEditingController textEditingController,
      TextInputType textInputType,
      String? Function() errorTestFunc) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
      child: TextFormField(
        keyboardType: textInputType,
        controller: textEditingController,
        style: TextStyle(color: Colors.white70),
        cursorColor: Theme.of(context).primaryColor.withOpacity(0.6),
        decoration: InputDecoration(
          icon: Icon(iconData, size: 25, color: Colors.white24),
          border: UnderlineInputBorder(),
          labelText: name,
          errorText: errorTestFunc(),
          focusColor: Theme.of(context).primaryColor,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.6))),
        ),
      ),
    );
  }

  IconButton _buildAddButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: () async {
        setState(() {
          nameController.text.isEmpty
              ? _nameValidate = true
              : _nameValidate = false;
          totalController.text.isEmpty
              ? _totalValidate = true
              : _totalValidate = false;
        });

        if (nameController.text.isEmpty || totalController.text.isEmpty) {
          return;
        }

        final totalPrice =
            double.tryParse(totalController.text.replaceAll(",", '.'));

        if (totalPrice == null) {
          setState(() {
            _totalValidate = true;
          });
          return;
        }

        final name = nameController.text;

        if (_openedFilters.isEmpty) {
          setState(() {
            _chipValidate = true;
          });
          return;
        }

        setState(() {
          _saveLoading = true;
        });
        await context.read<FlutterFireStoreService>().addExpense(
            "",
            Expense(
              price: totalPrice,
              date: date,
              name: name,
              type: _openedFilters[0],
            ),
            widget.image);

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (_, __, ___) => Authenticate(),
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
            style: TextButton.styleFrom(
                padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0)),
            onPressed: () {
              _dateTimeRangePicker();
            },
            label: Text("  " + _dateLabel,
                style: TextStyle(
                    color: Colors.white38.withOpacity(0.4), fontSize: 17)),
            icon: const Icon(CupertinoIcons.calendar_today,
                size: 25, color: Colors.white24),
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
          return Theme(
            data: ThemeData.dark().copyWith(
              textSelectionColor: Colors.white10,
              accentColor: primColor,
              primaryColor: primColor, //Head background
              // : Colors.red, //selection color
              // dialogBackgroundColor: Colors.white, //Background color
              colorScheme:  ColorScheme.fromSwatch().copyWith(
                  primary: Colors.black26,
                  secondary: primColor,
                  onSurface: Colors.white38,
                  onPrimary: primColor.withOpacity(0.7),
                  onBackground: Colors.black45
              ),
              dialogBackgroundColor: Colors.black,
              highlightColor: primColor,

              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.grey, // button text color
                ),
              ),
            ),
            child: Column(
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
            ),
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
      padding: const EdgeInsets.only(
        left: 15,
      ),
      child: Column(children: [
        const SizedBox(
          height: 30,
        ),
        Row(children: [
          const SizedBox(
            width: 10,
          ),
          _createFilterChip(0),
          const SizedBox(
            width: 8,
          ),
          _createFilterChip(1),
          const SizedBox(
            width: 8,
          ),
          _createFilterChip(2),
          const SizedBox(
            width: 8,
          )
        ]),
        Row(children: [
          const SizedBox(
            width: 10,
          ),
          _createFilterChip(3),
          const SizedBox(
            width: 8,
          ),
          _createFilterChip(4),
          const SizedBox(
            width: 4,
          )
        ]),
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
      shape: StadiumBorder(side: BorderSide(color: getChipColor(index))),
      onSelected: (bool value) {
        _onFilterChipSelected(value, index);
      },
      selected: _selectedFilters[index],
    );
  }

  Color getChipColor(int index) {
    if (_chipValidate) {
      return Colors.redAccent;
    }
    return _selectedFilters[index]
        ? Theme.of(context).primaryColor.withOpacity(0.5)
        : Colors.black87;
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

      _chipValidate = false;
    });
  }
}
