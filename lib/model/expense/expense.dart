import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses/model/expense/expenses_types.dart';

@immutable
class Expense {
  Expense({required this.price, required this.date, required this.name, required this.type, this.imageRef});

  String id = "";
  final double price;
  final DateTime date;
  final String name;
  final ExpenseType type;
  String? imageRef;

  Expense.fromJson(Map<String, Object?> json)
      : this(
    price: json['price']! as double,
    date: (json['date']! as Timestamp).toDate(),
    name: json['name']! as String,
    type: expenseTypeFromString(json['type']! as String),
    imageRef: (json['imageRef']! as String).isEmpty ? null : (json['imageRef']! as String)
  );


  Map<String, Object?> toJson() {
    return {
      'price': price,
      'date': date,
      'name': name,
      'type': type.toString(),
      'imageRef': imageRef ?? ""
    };
  }

  static ExpenseType expenseTypeFromString(String expenseType) {
    for(ExpenseType et in ExpenseType.values) {
      if (et.toString() == expenseType) {
        return et;
      }
    }
      throw Exception("Wrong expenseType");
  }

  @override
  String toString() {
    return "Expense(name=($name), price=($price), date=($date), types=($type))";
  }
}