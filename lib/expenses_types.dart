
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ExpenseType {
  food,
  utilities,
  transportation,
  healthcare,
  fun
}

extension ParseToString on ExpenseType {
  String str() {
    String short = this.toString().split(".")[1];
    return "${short[0].toUpperCase()}${short.substring(1)}";
  }
}

extension GetIcon on ExpenseType {
  IconData icon() {
    switch (this) {
      case ExpenseType.food:
        return Icons.local_grocery_store_outlined;
      case ExpenseType.utilities:
        return Icons.emoji_objects_outlined;
      case ExpenseType.transportation:
        return Icons.directions_transit_outlined ;
      case ExpenseType.healthcare:
        return Icons.medical_services_outlined;
      case ExpenseType.fun:
        return Icons.local_bar_outlined;
    }
  }
}