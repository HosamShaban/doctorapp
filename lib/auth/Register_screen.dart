import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:doctorapp/Consts/colors.dart';
import 'package:doctorapp/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  final String baseUrl = "https://diabetes-2023.000webhostapp.com";
  String? passwordError;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  Future<void> initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> register() async {
    final Dio dio = Dio();
    var response = await dio.post("$baseUrl/api/doctor/register", data: {
      "name": namecontroller.text.trim(),
      "email": emailcontroller.text.trim(),
      "password": passwordcontroller.text.trim()
    });
    await FirebaseFirestore.instance.collection('Doctors').add({
      'name': namecontroller.text.trim(),
      'email': emailcontroller.text.trim(),
      'password': passwordcontroller.text.trim(),
      'confirmPassword': confirmpasswordcontroller.text.trim()
    });
    _preferences.setString('name', namecontroller.text.trim());
    _preferences.setString('email', emailcontroller.text.trim());
    _preferences.setString('password', passwordcontroller.text.trim());
    _preferences.setString(
        'confirmPassword', confirmpasswordcontroller.text.trim());
    print(response.data);
  }

  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter an name';
    } else if (name.length < 2) {
      return 'Invalid name format';
    }
    return null;
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

  void _signUpProcess(BuildContext context) {
    var validate = _formKey.currentState!.validate();

    if (validate) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
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
                children: const <Widget>[
                  Text(
                    "إنشاء حساب",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "انشئ حساب جديد على تطبيقنا",
                    style: TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
              SizedBox(width: 30),
              Text(
                'الاسم كامل',
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
                controller: namecontroller,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'الاسم كامل',
                    hintStyle: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: Color(0xff888888),
                        fontSize: 13),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: const Icon(Icons.person_outline),
                    suffixIconColor: const Color(0xfff888888)),
              ),
            ),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
              SizedBox(width: 30),
              Text(
                'البريد الإلكتروني',
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
                controller: emailcontroller,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'email@gmail.com',
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
                controller: passwordcontroller,
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
            Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
              SizedBox(width: 30),
              Text(
                'تأكيد كلمة السر  ',
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
                controller: confirmpasswordcontroller,
                textAlign: TextAlign.right,
                obscureText: _passwordVisible2,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 2, color: Colors.grey), //<-- SEE HERE
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
                      _passwordVisible2
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible2 = !_passwordVisible2;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
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
                                "إنشاء حساب",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async => {register()}),
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
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    " تسجيل الدخول",
                    style: TextStyle(color: ConstColors.primaryColor),
                  ),
                ),
                const SizedBox(width: 3),
                const Text(
                  "هل بالفعل لديك حساب؟",
                  style: TextStyle(
                    color: ConstColors.text2Color,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
