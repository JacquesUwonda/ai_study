import 'package:ai_study/app/domain/models/conversation.dart';
import 'package:ai_study/app/domain/models/lesson.dart';
import 'package:ai_study/app/domain/models/quiz.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
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
    final path = join(dbPath, 'topics.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE topics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE lessons(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topicId INTEGER,
        title TEXT,
        description TEXT,
        FOREIGN KEY(topicId) REFERENCES topics(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE quizzes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topicId INTEGER,
        question TEXT,
        options TEXT,
        correctAnswer TEXT,
        FOREIGN KEY(topicId) REFERENCES topics(id)
      )
    ''');
  }

  Future<int> insertTopic(String title) async {
    final db = await database;
    return await db.insert('topics', {
      'title': title,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertLesson(int topicId, Lesson lesson) async {
    final db = await database;
    await db.insert('lessons', {
      'topicId': topicId,
      'title': lesson.title,
      'description': lesson.description,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertQuiz(int topicId, Quiz quiz) async {
    final db = await database;
    await db.insert('quizzes', {
      'topicId': topicId,
      'question': quiz.question,
      'options': quiz.options.join(
        '|',
      ), // Stocker les options sous forme de chaîne séparée par "|"
      'correctAnswer': quiz.correctAnswer,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Topic>> getTopics() async {
    final db = await database;
    final List<Map<String, dynamic>> topicMaps = await db.query('topics');
    final List<Topic> topics = [];

    for (var topicMap in topicMaps) {
      final List<Map<String, dynamic>> lessonMaps = await db.query(
        'lessons',
        where: 'topicId = ?',
        whereArgs: [topicMap['id']],
      );
      final lessons =
          lessonMaps.map((map) {
            return Lesson(title: map['title'], description: map['description']);
          }).toList();

      final List<Map<String, dynamic>> quizMaps = await db.query(
        'quizzes',
        where: 'topicId = ?',
        whereArgs: [topicMap['id']],
      );
      final quizzes =
          quizMaps.map((map) {
            return Quiz(
              question: map['question'],
              options: (map['options'] as String).split(
                '|',
              ), // Convertir la chaîne en liste
              correctAnswer: map['correctAnswer'],
            );
          }).toList();

      topics.add(
        Topic(
          id: topicMap['id'],
          title: topicMap['title'],
          lessons: lessons,
          quizzes: quizzes,
        ),
      );
    }

    return topics;
  }
}
