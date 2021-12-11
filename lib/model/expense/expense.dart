import 'package:flutter/material.dart';
import 'package:my_expenses/model/expense/expenses_types.dart';

@immutable
class Expense {
  Expense(this.id, this.price, this.date, this.name, this.types);

  final int id;
  final double price;
  final DateTime date;
  final String name;
  final List<ExpenseType> types;
}