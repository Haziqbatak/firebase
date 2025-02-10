import 'package:firebase/ui/pages.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('EA054BFD-004F-4C7A-A84E-693F705AD3D3'),
    androidProvider: AndroidProvider.playIntegrity,
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (context) => SignUpPage(),
        '/login': (context) => SignInPage(),
        '/home': (context) => HomePage(),
        '/note': (context) => NotePage(),
        '/profile': (context) => ProfilePage(),
        '/change-password': (context) => ChangePassword(),
      },
    );
  }
}
