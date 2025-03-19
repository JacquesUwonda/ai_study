import 'package:ai_study/app/domain/models/lesson.dart';
import 'package:equatable/equatable.dart';

abstract class LessonState extends Equatable {
  const LessonState();
  @override
  List<Object> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonLoaded extends LessonState {
  final List<Lesson> lessons;
  final int currentLessonIndex;

  const LessonLoaded(this.lessons, this.currentLessonIndex);

  @override
  List<Object> get props => [lessons, currentLessonIndex];
}

class LessonError extends LessonState {
  final String error;
  const LessonError(this.error);
  @override
  List<Object> get props => [error];
}
