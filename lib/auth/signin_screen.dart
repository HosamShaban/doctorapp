import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Consts/colors.dart';
import '../view/Page.dart';
import '../view/errorlogin.dart';
import 'Register_screen.dart';

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
  final String baseUrl = "https://diabetes-23.000webhostapp.com";
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  static String token = "";
  late SharedPreferences UserData;
  late bool newuser;
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void login(email, password) async {
    final Dio dio = Dio();
    try {
      var response = await dio.post("$baseUrl/api/doctor/login", data: {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim()
      });

      if (response.statusCode == 200) {
        if (response.data['token'].toString().isNotEmpty) {
          var responseData = json.decode(response.toString());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = responseData['data']['token'];
          var id = response.data['patient_id'];
          await prefs.setString('token', token);
          print("====================");
          print(prefs.getString("token"));
          print('Login successfully');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalPage()),
          );
          return;
        } else {
          print('Token not found in response');
        }
      } else if (response.statusCode == 400) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FaildLogin()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'فشل تسجيل دخولك',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'فشل تسجيل دخولك',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      // Handle error

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'خطأ في الايميل أو كلمة السر حاول مجددا',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'هذا الحقل مطلوب';
    } else if (!email.contains('@')) {
      return 'من فضلك أدخل ايميل صحيح';
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'هذا الحقل مطلوب';
    } else if (password.length < 6) {
      return 'كلمة السر يجب الا تقل عن 6 حروف';
    }
    return null;
  }

  void _signInProcess(BuildContext context) {
    var validate = _formKey.currentState!.validate();

    if (validate) {
      login(
          emailController.text.toString(), passwordController.text.toString());
      _autoValidate = true; // Move this line inside the if condition
    } else {
      setState(() {
        _autoValidate = true;
      });
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
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              const SizedBox(width: 30),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Text(
                  'البريد الإلكتروني',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Tajawal', fontSize: 16),
                ),
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
                validator: emailValidator,
                controller: emailController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'example@gmail.com',
                    hintStyle: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: Color(0xff888888),
                        fontSize: 13),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: const Icon(Icons.email_outlined),
                    suffixIconColor: const Color(0xfff888888)),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              const SizedBox(width: 30),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Text(
                  'كلمة السر  ',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Tajawal', fontSize: 16),
                ),
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
                validator: passwordValidator,
                controller: passwordController,
                obscureText: !_passwordVisible,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: '********',
                  hintStyle: const TextStyle(
                      fontFamily: 'Tajawal',
                      color: Color(0xff888888),
                      fontSize: 13),
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
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
                            borderRadius: BorderRadius.circular(8.0)),
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
                        onPressed: () {
                          login(emailController.text.toString(),
                              passwordController.text.toString());
                          _signInProcess(context);
                          UserData.setBool("login", false);
                          UserData.setString(
                              "email", emailController.text.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonalPage()));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*void fetchData() async {
    Dio dio = Dio();

    try {
      var response = await dio.post("$baseUrl/api/patient/login", data: {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim()
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        var responseData = json.decode(response.toString());

        // Access the response parameters
        var data = response.data;
        var status = response.data['code'];
        var message = response.data['message'];
        var token = responseData['data']['token'];
        var id = response.data['patient_id'];
        await prefs.setString('token', token);

        print('Data: $data');
        print("================");
        print('Status: $status');
        print('Message: $message');
        print('token is : $token');
        print("================");
        print(prefs.getString('token'));
      } else {
        print('Error retrieving data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }*/
}
