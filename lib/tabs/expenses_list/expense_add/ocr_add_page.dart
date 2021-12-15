import 'package:flutter/material.dart';
import 'package:my_expenses/services/locator.dart';
import 'package:my_expenses/services/ocr_api.dart';
import 'package:my_expenses/utils/loading_screen.dart';

import 'expense_add_page.dart';

class OcrAddPage extends StatefulWidget {
  const OcrAddPage({Key? key, required this.image}) : super(key: key);

  final Image image;

  @override
  _OcrAddPageState createState() => _OcrAddPageState();
}

class _OcrAddPageState extends State<OcrAddPage> {
  final _ocrApiService = locator<OcrApi>();
  bool _ocrResultLoading = true;
  late String name;
  late String total;

  @override
  void initState() {
    super.initState();
    _getOcrResults();
  }

  @override
  Widget build(BuildContext context) {
    return _ocrResultLoading ? LoadingScreen() : ExpenseAddPage(image: widget.image, total: total, name: name, onAccept: () {},);
  }

  _getOcrResults() async {
    OcrResult ocrResult = await _ocrApiService.getOcrResult(widget.image);
    setState(() {
      name = ocrResult.name;
      total = ocrResult.total;
      _ocrResultLoading = false;
    });
  }
}
