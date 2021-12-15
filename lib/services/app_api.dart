import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:my_expenses/model/expense/expense.dart';
import 'package:my_expenses/model/expense/expenses_types.dart';

/// The service responsible for networking requests
@lazySingleton
class Api {
  static const endpoint = 'https://jsonplaceholder.typicode.com';

  var client = new http.Client();

  Future<List<Expense>> getExpenses(int userId, int pageSize, int pageNumber) async {
    await new Future.delayed(new Duration(seconds: 2));
    print(pageNumber);
    List<Expense> allExpenses = List.generate(
        pageSize, (index) => new Expense(index, index.toDouble(), DateTime.now(),
            "mock" + index.toString(), [ExpenseType.fun]));

    return allExpenses;
  }

  Future<void> addExpense(int userId, Expense expense) async {
    await new Future.delayed(new Duration(seconds: 4));
    print("Added expense " + expense.toString());
  }


  Future<Image?> getImage(int userId, int imageId) async {
    await new Future.delayed(new Duration(seconds: 2));
    var rng = new Random();
    bool flag = rng.nextBool();

    if (flag) {
      return null;
    }

    return Image.asset(
      'assets/paragon5.png',
      fit: BoxFit.fitWidth,
    );
  }

  // Future<User> getUserProfile(int userId) async {
  //   var response = await client.get('$endpoint/users/$userId');
  //   return User.fromJson(json.decode(response.body));
  // }
  //
  // Future<List<Post>> getPostsForUser(int userId) async {
  //   var posts = List<Post>();
  //   var response = await client.get('$endpoint/posts?userId=$userId');
  //   var parsed = json.decode(response.body) as List<dynamic>;
  //   for (var post in parsed) {
  //     posts.add(Post.fromJson(post));
  //   }
  //
  //   return posts;
  // }
  //
  // Future<List<Comment>> getCommentsForPost(int postId) async {
  //   var comments = List<Comment>();
  //   var response = await client.get('$endpoint/comments?postId=$postId');
  //   var parsed = json.decode(response.body) as List<dynamic>;
  //   for (var comment in parsed) {
  //     comments.add(Comment.fromJson(comment));
  //   }
  //   return comments;
  // }
}