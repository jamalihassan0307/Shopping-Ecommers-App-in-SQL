// import 'dart:math';

import 'package:ecommers_app/controller/homePageController.dart';
import 'package:ecommers_app/models/ItemModel.dart';
// import 'package:ecommers_app/services/itemService.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
class SQLService {
  Database? db;

  Future<void> openDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "shopping.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE shopping(
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL,
            image TEXT,
            rating REAL,
            fav INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE cart(
            shop_id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL,
            image TEXT,
            rating REAL,
            fav INTEGER
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> loadItems() async {
    return await db!.query('shopping');
  }

  Future<List<Map<String, dynamic>>> getCartList() async {
    return await db!.query('cart');
  }

  Future saveRecord(ShopItemModel data) async {
    await db!.insert(
      'shopping',
      {
        'id': data.id,
        'name': data.name,
        'price': data.price,
        'image': data.image,
        'rating': data.rating,
        'fav': data.fav ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    HomePageController.to.items.add(data);
    HomePageController.to.update();
  }

  Future setItemAsFavourite(int id, bool flag) async {
    await db!.update(
      'shopping',
      {'fav': flag ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future addToCart(ShopItemModel data) async {
    try {
      await db!.insert(
        'cart',
        {
          'shop_id': data.id,
          'name': data.name,
          'price': data.price,
          'image': data.image,
          'rating': data.rating,
          'fav': data.fav ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future removeFromCart(int shopId) async {
    await db!.delete(
      'cart',
      where: 'shop_id = ?',
      whereArgs: [shopId],
    );
  }
}
// import 'package:flutter/material.dart';

