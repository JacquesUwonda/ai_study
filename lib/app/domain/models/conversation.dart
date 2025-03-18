import 'package:ai_study/app/domain/models/lesson.dart';
import 'package:ai_study/app/domain/models/quiz.dart';

class Topic {
  final int? id;
  final String title;
  final List<Lesson> lessons;
  final List<Quiz> quizzes;

  Topic({
    this.id,
    required this.title,
    required this.lessons,
    required this.quizzes,
  });
}
