import 'package:flutter/material.dart';
import 'package:instagram_login/home.dart';

import 'instagram_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const  MaterialApp(
      title: 'Instagram Login',
      home: InstagramView(),
    );
  }
}
