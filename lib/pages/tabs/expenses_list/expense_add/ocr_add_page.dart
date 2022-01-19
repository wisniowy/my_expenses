import 'package:flutter/material.dart';
import 'package:my_expenses/services/locator.dart';
import 'package:my_expenses/services/ocr_api.dart';
import 'package:my_expenses/utils/loading_screen.dart';

import 'expense_add_page.dart';

class OcrAddPage extends StatefulWidget {
  const OcrAddPage({Key? key, required this.image}) : super(key: key);

  final FileImage image;

  @override
  _OcrAddPageState createState() => _OcrAddPageState();
}

class _OcrAddPageState extends State<OcrAddPage> {
  final _ocrApiService = locator<OcrApi>();
  bool _ocrResultLoading = true;
  late String name;
  late double total;
  late DateTime date;

  @override
  void initState() {
    super.initState();
    _getOcrResults();
  }

  @override
  Widget build(BuildContext context) {
    return _ocrResultLoading ? LoadingScreen() : ExpenseAddPage(
      image: widget.image,
      total: total,
      name: name,
      date: date,
      onAccept: () {},);
  }

  _getOcrResults() async {
    OcrResult ocrResult = await _ocrApiService.getOcrResult(widget.image);
    setState(() {
      name = ocrResult.name;
      total = ocrResult.total;
      date = ocrResult.date;
      _ocrResultLoading = false;
    });
  }
}
