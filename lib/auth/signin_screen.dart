import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctorapp/auth/ForgotPassword.dart';
import 'package:doctorapp/auth/Register_screen.dart';
import 'package:doctorapp/view/Page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Consts/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? passwordError;
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String baseUrl = "https://diabetes-2023.000webhostapp.com";
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String token = "";
  late SharedPreferences UserData;
  late bool newuser;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void login(email, password) async {
    Dio dio = Dio();
    try {
      var response = await dio.post("$baseUrl/api/doctor/login", data: {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim()
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.toString());
        var data = response.data;
        var status = response.data['code'];
        var message = response.data['message'];
        var token = responseData['data']['token'];
        var id = response.data['doctor_id'];
        print('Data: $data');
        print("================");
        print('Status: $status');
        print('Message: $message');
        print('id : $id');
        print('token is : $token');

        SharedPreferences userData = await SharedPreferences.getInstance();
        userData.setString('email', email);
        userData.setBool('login', true);
        userData.setString('token', token);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalPage()),
        );
      } else {
        print('Error retrieving data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email';
    } else if (!email.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    } else if (password.length < 6) {
      return 'Password should be at least 6 characters long';
    }
    return null;
  }

  void _signInProcess(BuildContext context) {
    var validate = _formKey.currentState!.validate();

    if (validate) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PersonalPage()),
      );
    } else {
      setState(() {
        _autoValidate = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email is not registered'),
        ),
      );
    }
  }

  void checkUser() async {
    SharedPreferences userData = await SharedPreferences.getInstance();
    bool isLoggedIn = userData.getBool('login') ?? false;
    print(isLoggedIn);
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PersonalPage()),
      );
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 50.0, bottom: 40.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    'assets/images/signin.jpg',
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
              SizedBox(width: 40),
              Text(
                'البريد الإلكتروني',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'SST', fontSize: 16),
              ),
            ]),
            Container(
              width: double.infinity,
              height: 80,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                validator: emailValidator,
                controller: emailController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'email@gmail.com',
                  hintStyle: const TextStyle(
                    fontFamily: 'Tajawal',
                    color: Color(0xff888888),
                    fontSize: 13,
                  ),
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.email_outlined),
                  suffixIconColor: const Color(0xfff888888),
                  contentPadding: const EdgeInsets.only(right: 15),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
              SizedBox(width: 30),
              Text(
                'كلمة السر  ',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Tajawal', fontSize: 16),
              ),
            ]),
            Container(
              width: double.infinity,
              height: 80,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                textAlign: TextAlign.right,
                obscureText: true,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: '********',
                    hintStyle: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: Color(0xff888888),
                        fontSize: 13),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: const Icon(Icons.lock_outline),
                    suffixIconColor: const Color(0xfff888888)),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()));
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(bottom: 5, left: 18, right: 18, top: 1),
                child: Text(
                  "هل نسيت كلمة السر؟",
                  style: TextStyle(fontSize: 14, color: ConstColors.text2Color),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        color: ConstColors.primaryColor,
                        child: Row(
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 100),
                              child: Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () => {
                              login(emailController.text.toString(),
                                  passwordController.text.toString()),
                              _signInProcess(context),
                            }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                  },
                  child: const Text(
                    "  انشاء حساب",
                    style: TextStyle(color: ConstColors.primaryColor),
                  ),
                ),
                const SizedBox(width: 3),
                const Text(
                  "ليس لديك حساب؟ ",
                  style: TextStyle(
                    color: ConstColors.text2Color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
