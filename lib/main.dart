import 'package:flutter/material.dart';
import 'package:manage_x/features/auth/presentation/pages/login.dart';
import 'package:manage_x/features/auth/presentation/pages/signup.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}