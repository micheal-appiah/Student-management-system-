import 'package:flutter/material.dart';
import 'package:ses_application/dashboard.dart';
import 'package:ses_application/register.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SES',
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginForm(),
        // Define other routes for your application
      },
    );
  }
}
