import 'package:flutter/material.dart';
import 'package:knot/pages/welcome/welcome_page.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knot',
      theme: ThemeData(
          textTheme:
              Theme.of(context).textTheme.apply(bodyColor: textColorLight),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      // ignore_for_file: prefer_const_constructors
      home: WelcomePage(),
    );
  }
}
