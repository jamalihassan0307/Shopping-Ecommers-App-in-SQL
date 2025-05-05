import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shopease.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        profile_image TEXT
      )
    ''');

    // Items table
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        rating REAL NOT NULL,
        description TEXT,
        is_favorite INTEGER DEFAULT 0
      )
    ''');

    // Cart table
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        item_id INTEGER NOT NULL,
        quantity INTEGER DEFAULT 1,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (item_id) REFERENCES items (id)
      )
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        item_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (item_id) REFERENCES items (id)
      )
    ''');

    // Insert initial shoe data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final List<Map<String, dynamic>> initialData = [
      {
        "name": "Nike",
        "price": 25.0,
        "fav": false,
        "rating": 4.5,
        "image": "https://rukminim1.flixcart.com/image/832/832/jao8uq80/shoe/3/r/q/sm323-9-sparx-white-original-imaezvxwmp6qz6tg.jpeg?q=70"
      },
      {
        "name": "Puma Descendant Ind",
        "price": 299.0,
        "fav": false,
        "rating": 4.5,
        "image": "https://n4.sdlcdn.com/imgs/d/h/i/Asian-Gray-Running-Shoes-SDL691594953-1-2127d.jpg"
      },
      {
        "name": "Running Shoe Brooks Highly",
        "price": 3001.0,
        "fav": false,
        "rating": 3.5,
        "image": "https://cdn.pixabay.com/photo/2014/06/18/18/42/running-shoe-371625_960_720.jpg"
      },
      {
        "name": "Ugly Shoe Trends 2018",
        "price": 25.0,
        "fav": false,
        "rating": 4.5,
        "image": "https://pixel.nymag.com/imgs/fashion/daily/2018/04/18/uglee-shoes/70-fila-disruptor.w710.h473.2x.jpg"
      },
      {
        "name": "ShoeGuru",
        "price": 205.0,
        "fav": false,
        "rating": 4.0,
        "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRc_R7jxbs8Mk2wjW9bG6H9JDbyEU_hRHmjhr3EYn-DYA99YU6zIw"
      },
      {
        "name": "Shoefly black",
        "price": 200.0,
        "fav": false,
        "rating": 4.9,
        "image": "https://rukminim1.flixcart.com/image/612/612/j95y4cw0/shoe/d/p/8/sho-black-303-9-shoefly-black-original-imaechtbjzqbhygf.jpeg?q=70"
      }
    ];

    for (var item in initialData) {
      await db.insert('items', {
        'name': item['name'],
        'price': item['price'],
        'image': item['image'],
        'rating': item['rating'],
        'is_favorite': item['fav'] ? 1 : 0,
      });
    }
  }

  // User operations
  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty ? maps.first : null;
  }
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  // Item operations
  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await database;
    return await db.query('items');
  }

  Future<Map<String, dynamic>?> getItemById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  // Cart operations
  Future<int> addToCart(int userId, int itemId, {int quantity = 1}) async {
    final db = await database;
    return await db.insert('cart', {
      'user_id': userId,
      'item_id': itemId,
      'quantity': quantity,
    });
  }

  Future<int> removeFromCart(int userId, int itemId) async {
    final db = await database;
    return await db.delete(
      'cart',
      where: 'user_id = ? AND item_id = ?',
      whereArgs: [userId, itemId],
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT i.*, c.quantity 
      FROM items i
      INNER JOIN cart c ON i.id = c.item_id
      WHERE c.user_id = ?
    ''', [userId]);
  }

  // Favorites operations
  Future<int> addToFavorites(int userId, int itemId) async {
    final db = await database;
    return await db.insert('favorites', {
      'user_id': userId,
      'item_id': itemId,
    });
  }

  Future<int> removeFromFavorites(int userId, int itemId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'user_id = ? AND item_id = ?',
      whereArgs: [userId, itemId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteItems(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT i.* 
      FROM items i
      INNER JOIN favorites f ON i.id = f.item_id
      WHERE f.user_id = ?
    ''', [userId]);
  }

  Future<bool> isItemInFavorites(int userId, int itemId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'user_id = ? AND item_id = ?',
      whereArgs: [userId, itemId],
    );
    return result.isNotEmpty;
  }
} 