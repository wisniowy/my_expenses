import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses/pages/home.dart';
import 'package:my_expenses/pages/signin_screen.dart';
import 'package:my_expenses/services/firestore.dart';
import 'package:my_expenses/services/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'auth/firebase.dart';
import 'firebase_options.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primColor = const Color(0xfff9844a);
    return MultiProvider(
      providers: [
        Provider<FlutterFireAuthService>(
          create: (_) => FlutterFireAuthService(FirebaseAuth.instance),
        ),
        Provider<FlutterFireStoreService>(
          create: (_) => FlutterFireStoreService(FirebaseFirestore.instance),
        ),
        StreamProvider(
          create: (context) =>
          context.read<FlutterFireAuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'FlutterFire Provider Template',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          textSelectionColor: Colors.white10,
          accentColor: primColor,
          primaryColor: primColor, //Head background
          // : Colors.red, //selection color
          // dialogBackgroundColor: Colors.white, //Background color
          colorScheme:  ColorScheme.fromSwatch().copyWith(
              primary: Colors.black26,
              secondary: primColor,
              onSurface: Colors.white38,
              onPrimary: primColor.withOpacity(0.7),
              onBackground: Colors.black45

          ),
          dialogBackgroundColor: Colors.grey.withOpacity(0.8),
          highlightColor: primColor,
        ),
        home: Authenticate(),
      ),
    );
  }
}


class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      // return SignInScreen();
      return MyHomePage(title: "HomePage", user: firebaseUser);
    }
    return SignInScreen();
  }
}