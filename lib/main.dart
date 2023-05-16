// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:omarbaro/screen.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 47, 129, 224),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
          useMaterial3: true,
        ),
        home: Screen());
  }
}
