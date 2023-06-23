import 'package:doctorapp/auth/signin_screen.dart';
import 'package:doctorapp/controller/screenIndexProvider.dart';
import 'package:doctorapp/view/Page.dart';
import 'package:doctorapp/widget/loading_animation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _checkEmailExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email != null;
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
            home: FutureBuilder<bool>(
              future: _checkEmailExists(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    // Email exists, navigate to home screen
                    return PersonalPage(); // Replace with your home screen widget
                  } else {
                    // Email does not exist, navigate to onboarding screen
                    return const LoginScreen();
                  }
                } else {
                  // Show a loading indicator while checking email existence
                  return LoadingAnimationPage();
                }
              },
            ),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Tajawal'),
          ),
        );
      },
    );
  }
}
