import 'package:ecommers_app/pages/HomePage.dart';
import 'package:ecommers_app/services/sqlService.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(Main());
    SQLService sqlService = SQLService();
  sqlService.openDB();
}

class Main extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
