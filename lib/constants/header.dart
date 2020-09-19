import 'package:flutter/material.dart';

AppBar header(context) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    title: Text(
      "Bookie",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
    ),
    centerTitle: true,
  );
}
