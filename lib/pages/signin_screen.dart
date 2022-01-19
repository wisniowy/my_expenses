import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_expenses/auth/firebase.dart';
import 'package:my_expenses/pages/constants.dart';
import 'package:my_expenses/pages/signup_screen.dart';
import 'package:provider/src/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController =  TextEditingController();
  bool _showFillFieldsAlert = false;
  bool _showWrongCredsAlert = false;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String _getAlertString() {
    if (_showWrongCredsAlert) {
      return "Email Address or Password is incorrect";
    }
    if (_showFillFieldsAlert) {
      return "Fill Email Address and Password";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration:  BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/backgroundImage.png"),
                    fit: BoxFit.fill,
                    alignment: Alignment.bottomCenter),

              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SIGN IN",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) => SignUpScreen(),
                              fullscreenDialog: true));
                        },
                        child: Container(
                          child: Text(
                            "SIGN UP",
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.alternate_email,
                            color: kPrimaryColor,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            decoration:
                            InputDecoration(hintText: "Email Address"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.lock,
                          color: kPrimaryColor,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_getAlertString(), style: TextStyle(color: Colors.redAccent),)
                    ],
                  ),

                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<FlutterFireAuthService>().signInWithGoogle(context: context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                              Border.all(color: Colors.white.withOpacity(0.5)),
                            ),
                            child: FaIcon(FontAwesomeIcons.google,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                              setState(() {
                                _showFillFieldsAlert = true;
                              });
                              return;
                            }

                            final res = await context.read<FlutterFireAuthService>().signIn(email: emailController.text,
                                password: passwordController.text);

                            if (!res) {
                              setState(() {
                                _showWrongCredsAlert = true;
                              });
                              return;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: kPrimaryColor),
                            child: const Icon(Icons.arrow_forward, color: Colors.black,),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}