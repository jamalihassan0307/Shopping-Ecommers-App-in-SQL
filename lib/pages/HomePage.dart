import 'dart:convert';
import 'dart:io';

import 'package:ecommers_app/controller/homePageController.dart';
import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/pages/CartPage.dart';
import 'package:ecommers_app/pages/ItemDetail.dart';
import 'package:ecommers_app/services/itemService.dart';
import 'package:ecommers_app/services/sqlService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ItemServices itemServices = ItemServices();
  List<ShopItemModel> items = [];
    File? _image;
    // String? image;



    TextEditingController name = TextEditingController();
      TextEditingController price = TextEditingController();
    
  
  final HomePageController controller = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          name.clear();
          price.clear();
          _image = null;
        final formKey = GlobalKey<FormState>();
          // Add a variable to store the selected image file

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: Text("Add Item"),
                  backgroundColor: Colors.white,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final pickedFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    setState(() {
                                     
                                    }); _image = File(pickedFile.path);
                                          //  var byte = await _image!.readAsBytes();
            //  image = base64Encode(byte);
            //  print("imagweee${image}");
            //  setState((){});
                                  }
                                },
                                child: Text(_image != null
                                    ? 'Change Image'
                                    : 'Pick Image'),
                              ),
                              if (_image != null) ...[
                                SizedBox(height: 10),
                                Image.file(
                                  _image!,
                                  height: 50,
                                ),
                              ],
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 40,
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.4),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: TextFormField(
                                          validator: (String? value) {
                                            if (value != null &&
                                                value.trim() == "") {
                                              return "Name can't be empty!";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.center,
                                          textInputAction: TextInputAction.done,
                                          controller: name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Price",
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 40,
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.4),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          controller: price,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  SQLService sql=await SQLService();
                               int id=HomePageController.to. items.length+1;
                              var model=    ShopItemModel(id:id,
                               fav: false, 
                               rating: 3.5,
                                price:double.tryParse(price.text.toString())??0.0 
                                , image:_image!.path,
                                 name: name.text);
  print("mode;;;;;;${model}");

                                 await sql.saveRecord(model);
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  textDirection: TextDirection.rtl,
                                  children: const [
                                    Text(
                                      "Add",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  textDirection: TextDirection.rtl,
                                  children: const [
                                    Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
   
        appBar: AppBar(
          
          title: Text("Home"),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: InkResponse(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartPage()));
                  },
                  child: Stack(
                    children: [
                      GetBuilder<HomePageController>(builder: (_) => Align(
                        child: Text(controller.cartItems.length > 0 ? controller.cartItems.length.toString() : ''),
                        alignment: Alignment.topLeft,
                      )),
                      Align(
                        child: Icon(Icons.shopping_cart),
                        alignment: Alignment.center,
                      ),
                    ],
                  )),
            )
          ],
        ),
        body: Container(
          child: GetBuilder<HomePageController>(
            init: controller,
            builder: (_) => controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ShopItemListing(
                    items: controller.items,
                  ),
          ),
        ));
  
  
  }
}

class ShopItemListing extends StatelessWidget {
  final List<ShopItemModel> items;

  ShopItemListing({required this.items});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.8),
        itemBuilder: (BuildContext context, int index) {
          return ItemView(
            item: items[index],
          );
        },
        itemCount: items.length,
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  final ShopItemModel item;

  ItemView({required this.item});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkResponse(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemDetailPage(itemId: item.id)));
          },
          child: Material(
            child: Container(
                height: 380.0,
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 8.0)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 120.0,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child:item.image.toString().substring(0,5)=="https"?
                               Container(
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.contain,
                                ),
                              ):
                               Container(
                                child:
                                
                                Image.file(File(item.image),
                                  fit: BoxFit.contain,)
                              ),
                            ),
                            Container(
                              child: item.fav
                                  ? Icon(
                                      Icons.favorite,
                                      size: 20.0,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      size: 20.0,
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "${item.name}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              "\$${item.price.toString()}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}
