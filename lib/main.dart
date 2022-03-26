import 'package:flutter/material.dart';
import 'package:starange_reader/screens/reader_screen.dart';
import 'package:starange_reader/screens/texts_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextsScreen(),
      // routes: {
      //   // ReaderScreen.routeName: (context) => const ReaderScreen(),
      // },
    );
  }
}
