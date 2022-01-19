import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

/// The service responsible for networking requests
@lazySingleton
class OcrApi {
  static const endpoint = 'https://my-expenses-ocr.herokuapp.com/process';
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  var client = new http.Client();


  Future<OcrResult> getOcrResult(FileImage image) async {
    final id = new DateTime.now().millisecondsSinceEpoch;
    final imageRef = 'temp$id.png';
    await _firebaseStorage.ref(imageRef)
        .putFile(image.file);


    Map<String, String> headers = new HashMap();



    final token = await FirebaseAuth.instance.currentUser!.getIdToken(true);
    headers['Authorization'] = "Bearer $token";
    print(Uri.parse('$endpoint/$imageRef').toString());
    final response = await client.get(Uri.parse('$endpoint/$imageRef'), headers: headers);

    if (response.statusCode == HttpStatus.unauthorized) {
      final msg = response.toString();
      print("error $msg");
    }

    await _firebaseStorage.ref(imageRef).delete();

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      OcrResult res = OcrResult.fromJson(jsonDecode(response.body));

      print(res.date.toString());
      if (res.date.isAfter(DateTime.now())) {
        res.date = DateTime.now();
      }
      res.date = DateTime(res.date.year, res.date.month ,res.date.day,);



      return res;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class OcrResult {
  final String name;
  final double total;
  DateTime date;

  OcrResult(this.name, this.total, this.date);

  OcrResult.fromJson(Map<String, dynamic> json)
  : this (
    json['result']['receipt_name']! as String,
    json['result']['receipt_total_price']! as double,
    DateFormat('dd/mm/yyyy').parse(json['result']['receipt_date_in_seconds'])
  );
}