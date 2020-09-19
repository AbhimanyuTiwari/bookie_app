import 'package:flutter/material.dart';

import 'Wrapper.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bookie",
      theme: ThemeData(
        //primaryColor: Color.fromRGBO(65, 98, 103, 1),
        primaryColor: Colors.cyan,
      ),
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}
