import 'package:flutter/material.dart';
import 'package:flutter_firebase/myProject/home.dart';


void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pranush personals',
      theme: ThemeData.dark().copyWith(),
      home: defaultscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class defaultscreen extends StatelessWidget {
  const defaultscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Home(
      country: 'in',
    );
  }
}
