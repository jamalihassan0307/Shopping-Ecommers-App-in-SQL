import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/services/sqlService.dart';
import 'package:ecommers_app/services/storageService.dart';
import 'package:sqflite/sqflite.dart';

class ItemServices {
  Database? _db;
  SQLService? _sqlService;
  StorageService storageService = StorageService();
  List<ShopItemModel> shoppingList = [];

  Future<void> openDB() async {
    if (_db != null) return;
    _db = await openDatabase(
      'shop.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY,
            name TEXT,
            image TEXT,
            price REAL,
            rating REAL,
            description TEXT,
            isFavorite INTEGER,
            shop_id INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE cart(
            id INTEGER PRIMARY KEY,
            item_id INTEGER,
            FOREIGN KEY (item_id) REFERENCES items (id)
          )
        ''');
      },
    );
  }

  Future<List<ShopItemModel>> getItems() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _db!.query('items');
    return List.generate(maps.length, (i) => ShopItemModel.fromMap(maps[i]));
  }

  Future<List<ShopItemModel>> getCartList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _db!.rawQuery('''
      SELECT i.* FROM items i
      INNER JOIN cart c ON i.id = c.item_id
    ''');
    return List.generate(maps.length, (i) => ShopItemModel.fromMap(maps[i]));
  }

  Future<void> addToCart(int itemId) async {
    await openDB();
    await _db!.insert(
      'cart',
      {'item_id': itemId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFromCart(int itemId) async {
    await openDB();
    await _db!.delete(
      'cart',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }

  Future<void> setToFav(int itemId) async {
    await openDB();
    final item = await _db!.query(
      'items',
      where: 'id = ?',
      whereArgs: [itemId],
    );
    if (item.isNotEmpty) {
      final currentFav = item.first['isFavorite'] == 1;
      await _db!.update(
        'items',
        {'isFavorite': currentFav ? 0 : 1},
        where: 'id = ?',
        whereArgs: [itemId],
      );
    }
  }

  Future<bool> isFirstTime() async {
    return await storageService.getItem("isFirstTime") == 'true';
  }

  Future saveToLocalDB() async {
    List<ShopItemModel> items = await getItems();
    for (var i = 0; i < items.length; i++) {
      await _sqlService!.saveRecord(items[i]);
    }
    await storageService.setItem("isFirstTime", "true");
    return await getItems();
  }

  Future getLocalDBRecord() async {
    return await _sqlService!.loadItems();
  }
}
