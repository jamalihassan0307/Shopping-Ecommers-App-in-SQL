
class ShopItemModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final double rating;
  bool _isFavorite;
  String? description;
  int? shopId;

  bool get isFavorite => _isFavorite;
  set isFavorite(bool value) => _isFavorite = value;

  ShopItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    bool isFavorite = false,
    this.description,
    this.shopId,
  }) : _isFavorite = isFavorite;

  factory ShopItemModel.fromMap(Map<String, dynamic> map) {
    return ShopItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      price: map['price'] as double,
      rating: map['rating'] as double,
      isFavorite: map['isFavorite'] == 1 || map['fav'] == 1,
      description: map['description'] as String?,
      shopId: map['shop_id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'rating': rating,
      'isFavorite': _isFavorite ? 1 : 0,
      'fav': _isFavorite ? 1 : 0,
      'description': description,
      'shop_id': shopId,
    };
  }
}
