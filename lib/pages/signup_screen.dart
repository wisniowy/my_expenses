import 'package:flutter/material.dart';
import 'package:my_expenses/auth/firebase.dart';
import 'package:my_expenses/pages/constants.dart';
import 'package:provider/src/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController =  TextEditingController();
  String _alertString = "";


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String _getAlertString() {
    return _alertString;
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
                        "SIGN UP",
                        style: Theme.of(context).textTheme.headline4,
                      ),
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
                      children: [GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                Border.all(color: Colors.white.withOpacity(0.5)),
                              ),
                              child: Icon(Icons.arrow_back_ios_outlined,
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                          ),

                        const SizedBox(width: 16),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                              setState(() {
                                _alertString = "Fill Email Address and Password";
                              });
                              return;
                            }

                            final res = await context.read<FlutterFireAuthService>().signUp(email: emailController.text,
                                password: passwordController.text);

                            if (res != null) {
                              setState(() {
                                _alertString = res;
                              });
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