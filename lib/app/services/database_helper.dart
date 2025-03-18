import 'package:ai_study/app/domain/models/conversation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_history.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE conversations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conversationId INTEGER,
        text TEXT,
        isUser INTEGER,
        FOREIGN KEY(conversationId) REFERENCES conversations(id)
      )
    ''');
  }

  Future<int> insertConversation(String topic) async {
    final db = await database;
    return await db.insert('conversations', {
      'topic': topic,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertMessage(int conversationId, Message message) async {
    final db = await database;
    await db.insert('messages', {
      'conversationId': conversationId,
      'text': message.text,
      'isUser': message.isUser ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Conversation>> getConversations() async {
    final db = await database;
    final List<Map<String, dynamic>> conversationMaps = await db.query(
      'conversations',
    );
    final List<Conversation> conversations = [];

    for (var conversationMap in conversationMaps) {
      final List<Map<String, dynamic>> messageMaps = await db.query(
        'messages',
        where: 'conversationId = ?',
        whereArgs: [conversationMap['id']],
      );
      final messages =
          messageMaps.map((map) {
            return Message(text: map['text'], isUser: map['isUser'] == 1);
          }).toList();

      conversations.add(
        Conversation(
          id: conversationMap['id'],
          topic: conversationMap['topic'],
          messages: messages,
        ),
      );
    }

    return conversations;
  }
}
