
import 'dart:math';

import 'package:ecommers_app/controller/homePageController.dart';
import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/services/itemService.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
class SQLService {
  // Database? db;

     var database = "Shop";
   var ip = "192.168.100.7";
   final connectToSqlServerDirectlyPlugin = ConnectToSqlServerDirectly();
  Future<void> openDB()  {
   return  connectToSqlServerDirectlyPlugin.initializeConnection(
      ip,
      database,
      'ali',   
      '12345',
      instance: 'node',
    ).then((value) {
      //  createTables();
// ItemServices aaa=ItemServices();
// aaa.saveToLocalDB();
      
      // HomePageController.to.getCardList();

    }); 
  }
   
 
  Future<void> post(String query)  {
    print("query: $query");
    // await connection();
    return connectToSqlServerDirectlyPlugin.getStatusOfQueryResult(query);
  }

   Future<dynamic> get(String query)  async {
    print("query: $query");
    // await connection();
    return await connectToSqlServerDirectlyPlugin.getRowsOfQueryResult(query);
  }

   Future<dynamic> Update(String query)  {
    print("query: $query");
    // await connection();

   return  connectToSqlServerDirectlyPlugin.getStatusOfQueryResult(query);
  }
  // createTables() async {
  //   try {
  //     var qry = "CREATE TABLE  shopping ( "
  //         "id int PRIMARY KEY,"
  //         "name varchar(255),"
  //         "image varchar(max),"
  //         "price float,"
  //         "fav bit,"
  //         "rating float,"
  //         "datetime varchar(255))";
  //     await post(qry);
  //     qry = "CREATE TABLE  cartlist ( "
  //         "id int PRIMARY KEY,"
  //         "shop_id int,"
  //         "name varchar(255),"
  //         "image varchar(max),"
  //         "price float,"
  //         "fav bit,"
  //         "rating float,"
  //         "datetime varchar(255))";

  //     await post(qry);
  //   } catch (e) {
  //     print("ERROR IN CREATE TABLE");
  //     print(e);
  //   }
  // }

  Future saveRecord(ShopItemModel data) async {
      var qry =
          "INSERT INTO shopping(id, name, price, image,rating,fav) VALUES(${data.id},'${data.name}',${data.price},'${data.image}',${data.rating},${data.fav ? 1 : 0})";
  await post(qry);
  HomePageController.to.items.add(data);
  HomePageController.to.update();
  }

  Future setItemAsFavourite(int id, bool flag) async {
    var query = "UPDATE shopping set fav = ${flag ? 1 : 0} WHERE id = $id";
    return await Update(query);
  }

  Future getItemsRecord() async {
    try {
      var list = await get('SELECT * FROM shopping');
      
print("listlist$list");
      return list ;
    } catch (e) {
      return Future.error(e);
    }
  }


  Future<List<Map<String, dynamic>>> getCartList() async {
  try {
    final value = await get('SELECT * FROM cartlist');
    if (value != null) {
      print("values$value");
      List<Map<String, dynamic>> tempResult = value.cast<Map<String, dynamic>>();
      print("ok");
      return tempResult;
    } else {
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}

  Future addToCart(ShopItemModel data) async {
    print("fsdfsdferfger");
    try {
      var qry =
          "INSERT INTO cartlist(shop_id, name, price, image,rating,fav,id) VALUES(${data.id}, '${data.name}',${data.price}, '${data.image}',${data.rating},${data.fav ? 1 : 0},${data.id})";

      print("qadad$qry");
    // await  getCartList();
  await post(qry);
    } catch (e) {
        print("errorrrrrr356${e}");
    }
   
  }

  Future removeFromCart(int shopId) async {
    var qry = "DELETE FROM cartlist where shop_id = ${shopId}";
    return await post(qry);
  }
}
// import 'package:flutter/material.dart';

