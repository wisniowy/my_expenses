import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/tabs/expenses_list/expense_page/photo_view_page.dart';
import 'package:my_expenses/utils/expense/expense_text_form.dart';
import 'dart:math';

import '../../../model/expense/expense.dart';
import 'expense_delete_dialog.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key, required this.expense, required this.onDelete}) : super(key: key);

  final Expense expense;
  final Function onDelete;

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  bool _imageLoading = true;
  bool _imageAvailable = false;
  Image? _image;

  late Function onDeleteAccept;
  late Function onDeleteCancel;

  var rng = new Random();

  @override
  void initState() {
    super.initState();
    _downloadImage();

    onDeleteAccept = () {
      widget.onDelete();
      Navigator.pop(context);
      Navigator.pop(context);
    };

    onDeleteCancel = () {
      Navigator.pop(context);
    };
  }

  Future<void> _downloadImage() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    bool flag = rng.nextBool();

    setState(() {
      _imageLoading = false;

      if (flag) {
        _imageAvailable = true;
        _image = Image.asset(
          'assets/paragon5.png',
          fit: BoxFit.fitWidth,
        );
      } else {
        _imageAvailable = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor.withOpacity(0.7)),
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor.withOpacity(0.7)),
        titleTextStyle: TextStyle(color: Colors.white38, fontSize: 15),
        toolbarTextStyle: TextStyle(color: Colors.white38),
        actions: [
          buildDeleteButton(context),
        ],
        title: Text(widget.expense.name),
      ),
      body: Column(
        children: [
          _getImage(),
          SizedBox(height: 20,),
          Row(children: [],),
          buildExpenseInfo(),
        ],
      ),
    );
  }

  Column buildExpenseInfo() {
    return Column(
      children: [
        buildTextFormField(CupertinoIcons.chat_bubble_text_fill,
            'Total', widget.expense.price.toString() + " PLN"),
        buildTextFormField(CupertinoIcons.chat_bubble_text_fill,
            'Name', widget.expense.name),
        buildTextFormField(CupertinoIcons.calendar_today,
            'Date', DateFormat("dd/MM/yyyy").format(widget.expense.date)),
      ],
    );
  }

  Widget _getImage() {
    if (_imageLoading) {
      return buildImageLoadingIndicator();
    }

    if (!_imageAvailable) {
      return ImageContainer(image: NoImageAvailableWidget(), onTap: () {});
    }

    return ImageContainer(image: _image, onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => PhotoViewPage(),
          fullscreenDialog: true,
        ),
      );
    },);
  }

  Column buildImageLoadingIndicator() {
    return Column(
      children: const [
        SizedBox(height: 30),
        CircularProgressIndicator(
          color: Colors.black38,
        ),
      ],
    );
  }

  Widget buildTextFormField(
    IconData iconData,
    String name,
    String initialValue,
  ) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 170),
        child: ExpenseTextForm(
          name: name,
          initialValue: initialValue,
          icon: iconData,
          enabled: false,
        ));
  }

  IconButton buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_outlined),
      onPressed: () {
        showOnDeleteDialog(context, onDeleteAccept, onDeleteCancel);
      },
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    required this.image,
    required this.onTap,
  });

  final Widget? image;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 300,
          width: 400,
          child: GestureDetector(
            onDoubleTap: () {onTap();},
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: image,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            ),
          ),
        )
      ],
    );
  }
}

class NoImageAvailableWidget extends StatelessWidget {
  const NoImageAvailableWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: const [
            Text("No image",
                style: TextStyle(fontSize: 30, color: Colors.black38)),
            Icon(Icons.photo_camera_rounded, size: 100, color: Colors.black38),
            Text("Available",
                style: TextStyle(fontSize: 30, color: Colors.black38)),
          ],
        )
      ],
    );
  }
}
