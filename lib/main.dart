import 'package:ecommers_app/pages/HomePage.dart';
import 'package:ecommers_app/services/sqlService.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const Main());
    SQLService sqlService = SQLService();
  sqlService.openDB();
}

class Main extends StatelessWidget{
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
