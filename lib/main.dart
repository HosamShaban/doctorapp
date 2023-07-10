import 'package:doctorapp/Model/login.dart';
import 'package:doctorapp/auth/Register_screen.dart';
import 'package:doctorapp/auth/signin_screen.dart';
import 'package:doctorapp/controller/screenIndexProvider.dart';
import 'package:doctorapp/view/Page.dart';
import 'package:doctorapp/widget/loading_animation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => screenIndexProvider())
          ],
          child: MaterialApp(
            home: LoginScreen(),
            /*FutureBuilder<String?>(
              future: _getToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationPage();
                } else if (snapshot.hasData && snapshot.data != null) {
                  return PersonalPage(); // Replace with your home screen widget
                } else {
                  return const LoginScreen();
                }
              },
            ),*/
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Tajawal'),
          ),
        );
      },
    );
  }
}
