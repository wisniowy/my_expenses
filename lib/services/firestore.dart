import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses/model/expense/expense.dart';
import 'package:my_expenses/model/expense/expenses_types.dart';

class FlutterFireStoreService {
  final FirebaseFirestore _firebaseStore;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  FlutterFireStoreService(this._firebaseStore);

  Future<void> addUser(String userId) async {
    return users
        .doc(userId)
        .set({"info": "test", "expenses": []}, SetOptions(merge: true));
  }

  Future<Image?> getImage(String? imageRef) async {
    if (imageRef == null) {
      return null;
    }

    try {
      String downloadURL =
          await _firebaseStorage.ref(imageRef).getDownloadURL();
      return Image.network(downloadURL, fit: BoxFit.fitWidth);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> addExpense(
      String userId, Expense expense, FileImage? image) async {
    String? imageRef = null;
    if (image != null) {
      print("Uploging image");
      final id = new DateTime.now().millisecondsSinceEpoch;
      imageRef = 'uploads/$id.png';
      _firebaseStorage.ref(imageRef).putFile(image.file);
      expense.imageRef = imageRef;
    }
    final year = expense.date.year;
    final month = expense.date.month;

    DocumentReference summaryRef = users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('summary')
        .doc('$year-$month');

    _firebaseStore.runTransaction((transaction) async {
      DocumentSnapshot res = await transaction.get(summaryRef);
      if (!res.exists) {
        transaction.set(summaryRef, {
          "total": expense.price,
          "food": (expense.type == ExpenseType.food ? expense.price : 0.0),
          "transportation": (expense.type == ExpenseType.transportation
              ? expense.price
              : 0.0),
          "utilities":
              (expense.type == ExpenseType.utilities ? expense.price : 0.0),
          "healthcare":
              (expense.type == ExpenseType.healthcare ? expense.price : 0.0),
          "fun": (expense.type == ExpenseType.fun ? expense.price : 0.0)
        });
      } else {
        final newTotal = res.get('total') + expense.price;
        final newFood = res.get('food') +
            (expense.type == ExpenseType.food ? expense.price : 0.0);
        final newTransport = res.get('transportation') +
            (expense.type == ExpenseType.transportation ? expense.price : 0.0);
        final newUtils = res.get('utilities') +
            (expense.type == ExpenseType.utilities ? expense.price : 0.0);
        final newHealthcare = res.get('healthcare') +
            (expense.type == ExpenseType.healthcare ? expense.price : 0.0);
        final newFun = res.get('fun') +
            (expense.type == ExpenseType.fun ? expense.price : 0.0);
        transaction.set(summaryRef, {
          "total": newTotal,
          "food": newFood,
          "transportation": newTransport,
          "utilities": newUtils,
          "healthcare": newHealthcare,
          "fun": newFun
        });
      }
    });

    return users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('expenses')
        .add(expense.toJson())
        .then((value) => print("Expense Added"))
        .catchError((error) => print("Failed to add expense: $error"));
  }

  Future<void> removeExpense(Expense expense) async {
    if (expense.imageRef != null) {
      await _firebaseStorage.ref(expense.imageRef).delete();
    }

    final year = expense.date.year;
    final month = expense.date.month;

    DocumentReference summaryRef = users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('summary')
        .doc('$year-$month');

    _firebaseStore.runTransaction((transaction) async {
      DocumentSnapshot res = await transaction.get(summaryRef);
      if (!res.exists) {
        throw Exception();
      } else {
        final newTotal = res.get('total') - expense.price;
        final newFood = res.get('food') -
            (expense.type == ExpenseType.food ? expense.price : 0.0);
        final newTransport = res.get('transportation') -
            (expense.type == ExpenseType.transportation ? expense.price : 0.0);
        final newUtils = res.get('utilities') -
            (expense.type == ExpenseType.utilities ? expense.price : 0.0);
        final newHealthcare = res.get('healthcare') -
            (expense.type == ExpenseType.healthcare ? expense.price : 0.0);
        final newFun = res.get('fun') -
            (expense.type == ExpenseType.fun ? expense.price : 0.0);
        transaction.set(summaryRef, {
          "total": newTotal,
          "food": newFood,
          "transportation": newTransport,
          "utilities": newUtils,
          "healthcare": newHealthcare,
          "fun": newFun
        });
      }
    });

    return users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('expenses')
        .doc(expense.id)
        .delete();
  }

  Future<List<Expense>> getExpenses() async {
    final List<Expense> expenses = [];
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('expenses')
        .orderBy('date', descending: true)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        final expense = Expense.fromJson(result.data());
        expense.id = result.id;
        expenses.add(expense);
      });
    });

    return expenses;
  }

  Future<MonthlyExpenses> getMonthlyExpenses(int month, int year) async {
    DocumentSnapshot summary = await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('summary')
        .doc('$year-$month')
        .get();

    if (!summary.exists) {
      return MonthlyExpenses(0.0, {});
    }

    Map<String, double> resMap = {
      "Food": summary.get('food'),
      "Transportation": summary.get('transportation'),
      "Utilities": summary.get('utilities'),
      "Healthcare": summary.get('healthcare'),
      "Fun": summary.get('fun')
    };

    return await MonthlyExpenses(summary.get('total'), resMap);
  }

  Future<List<double>> getMonthly(int year) async {
    List<double> result = [];
    for (int i = 1; i < 13; ++i) {
      DocumentSnapshot summary = await users
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('summary')
          .doc('$year-$i')
          .get();
      if (!summary.exists) {
        result.add(0.0);
        continue;
      }
      result.add(await summary.get('total'));
    }
    return result;
  }

  Future<List<double>> getPercentage(int month, int year) async {
    List<double> result = [];
    for (int i = 0; i < 12; ++i) {
      DocumentSnapshot summary = await users
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('summary')
          .doc('$year-$i')
          .get();
      if (!summary.exists) {
        result.add(0.0);
        continue;
      }
      result.add(await summary.get('total'));
    }
    return result;
  }
}

class MonthlyExpenses {
  final double total;
  final Map<String, double> percentage;

  MonthlyExpenses(this.total, this.percentage);
}
