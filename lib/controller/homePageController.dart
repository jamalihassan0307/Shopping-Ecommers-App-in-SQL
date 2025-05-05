import 'dart:convert';
import 'dart:io';

import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/services/itemService.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


class HomePageController extends GetxController {
 static HomePageController get to => Get.find();
  ItemServices itemServices = ItemServices();
  List<ShopItemModel> items = [];
  List<ShopItemModel> cartItems = [];
  bool isLoading = true;
    Future<File> saveImageToFile(String base64String) async {
    List<int> bytes = base64Decode(base64String);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    String filePath = '$appDocPath/image.png';

    File file = File(filePath);
    await file.writeAsBytes(bytes);
    print('Image saved to: $filePath');
  update();
    return file;
  }

  File? image64;

  @override
  void onInit() {
    super.onInit();
    loadDB();
  }

  loadDB() async {
    await itemServices.openDB();
    await loadItems();
    await getCardList();
  }

  getItem(int id) {
    return items.firstWhere((element) => element.id == id);
  }

  bool isAlreadyInCart(int id) {
    return cartItems.any((element) => element.id == id);
  }

  getCardList() async{
    try {
      List list = await itemServices.getCartList();
      cartItems.clear();
      list.forEach((element) {
        cartItems.add(ShopItemModel.fromJson(element));
      });
      print("sdoifjoiwsfjiower${list}");
      

    } catch (e) {
      print(e);
    }
  }

  loadItems()async{
    try {
      isLoading = true;
      update();

      List list = await itemServices.loadItems();
      items.clear();
      list.forEach((element) {
        items.add(ShopItemModel.fromJson(element));
      });

      isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  setToFav(int id, bool flag) async {
    int index = items.indexWhere((element) => element.id == id);

    items[index].fav = flag;
    update();
    try {
      await itemServices.setItemAsFavourite(id, flag);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> addToCart(ShopItemModel item) async {
    try {
      isLoading = true;
      update();
      var result = await itemServices.addToCart(item);
      if (result) {
        await getCardList(); // Refresh cart list after adding
      }
      isLoading = false;
      update();
      return result;
    } catch (e) {
      print(e);
      isLoading = false;
      update();
      return false;
    }
  }

  Future<void> removeFromCart(int shopId) async {
    try {
      await itemServices.removeFromCart(shopId);
      await getCardList(); // Refresh cart list after removing
    } catch (e) {
      print(e);
    }
  }

}