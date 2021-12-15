import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// The service responsible for networking requests
@lazySingleton
class OcrApi {
  static const endpoint = 'https://jsonplaceholder.typicode.com';

  var client = new http.Client();


  Future<OcrResult> getOcrResult(Image image) async {
    await new Future.delayed(new Duration(seconds: 4));
    return OcrResult("testOcrName", "9.99");
  }
}

class OcrResult {
  final String name;
  final String total;

  OcrResult(this.name, this.total);
}