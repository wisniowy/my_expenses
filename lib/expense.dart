import 'package:flutter/material.dart';

@immutable
class Expense {
  Expense(this.price, this.date, this.name);

  final double price;
  final String date;
  final String name;
}