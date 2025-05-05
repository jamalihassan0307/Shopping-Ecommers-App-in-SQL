import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/services/sqlService.dart';
import 'package:ecommers_app/services/storageService.dart';

class ItemServices {
  SQLService? _sqlService;
  StorageService storageService = StorageService();
  List<ShopItemModel> shoppingList = [];

  Future<void> openDB() async {
    _sqlService = await SQLService();
  }

  Future<List<ShopItemModel>> getItems() async {
    if (_sqlService == null) await openDB();
    List list = await _sqlService!.loadItems();
    return list.map((element) => ShopItemModel.fromJson(element)).toList();
  }

  Future<List<ShopItemModel>> getCartList() async {
    if (_sqlService == null) await openDB();
    List list = await _sqlService!.getCartList();
    return list.map((element) => ShopItemModel.fromJson(element)).toList();
  }

  Future<bool> addToCart(ShopItemModel item) async {
    if (_sqlService == null) await openDB();
    return await _sqlService!.addToCart(item);
  }

  Future<void> removeFromCart(int itemId) async {
    if (_sqlService == null) await openDB();
    await _sqlService!.removeFromCart(itemId);
  }

  Future<void> setToFav(int itemId, bool value) async {
    if (_sqlService == null) await openDB();
    await _sqlService!.setItemAsFavourite(itemId, value);
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
