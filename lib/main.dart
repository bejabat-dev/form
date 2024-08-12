import 'package:flutter/material.dart';
import 'package:form/register.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xfff2f2f2),
            inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 193, 193, 193))),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                focusedBorder: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 193, 193, 193))))),
        debugShowCheckedModeBanner: false,
        home: const Register());
  }
}
