import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tradicine_app/models/cart/cart.dart';
import 'package:tradicine_app/models/chat/chat.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tradicine.db');

    return await openDatabase(
      path,
      version: 2, // Versi database dinaikkan agar bisa migrasi jika ada perubahan
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart (
            id TEXT PRIMARY KEY, 
            name TEXT, 
            imageUrl TEXT, 
            price INTEGER, 
            quantity INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            sender TEXT, 
            message TEXT, 
            timestamp TEXT
          )
        ''');
      },
    );
  }

  // ===================== CART FUNCTIONS =====================

  Future<void> addToCart(CartItem item) async {
    final db = await database;
    final existingItem = await db.query(
      'cart',
      where: 'id = ?',
      whereArgs: [item.id],
    );

    if (existingItem.isNotEmpty) {
      int newQuantity = (existingItem.first['quantity'] as int) + 1;
      await db.update(
        'cart',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [item.id],
      );
    } else {
      await db.insert('cart', item.toMap());
    }
  }

  Future<void> decrementQuantity(CartItem item) async {
    final db = await database;
    final existingItem = await db.query(
      'cart',
      where: 'id = ?',
      whereArgs: [item.id],
    );

    if (existingItem.isNotEmpty) {
      int newQuantity = (existingItem.first['quantity'] as int) - 1;
      if (newQuantity > 0) {
        await db.update(
          'cart',
          {'quantity': newQuantity},
          where: 'id = ?',
          whereArgs: [item.id],
        );
      } else {
        await removeFromCart(item.id);
      }
    }
  }

  Future<void> removeFromCart(String id) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(maps.length, (i) => CartItem.fromMap(maps[i]));
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }

  // ===================== MESSAGE FUNCTIONS =====================

  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert('messages', message.toMap());
  }
  
  Future<void> deleteMessage(int id) async {
    final db = await database;
    await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Message>> getMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => Message.fromMap(maps[i]));
  }

  Future<List<Message>> getLastMessagesPerChat() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT * FROM messages 
      WHERE id IN (SELECT MAX(id) FROM messages GROUP BY sender) 
      ORDER BY timestamp DESC
    ''');
    return result.map((map) => Message.fromMap(map)).toList();
  }
}
