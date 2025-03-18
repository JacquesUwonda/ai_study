part of 'lesson_bloc.dart';

abstract class LessonState extends Equatable {
  const LessonState();
  @override
  List<Object> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonLoaded extends LessonState {
  final List<Lesson> lessons;
  const LessonLoaded(this.lessons);
  @override
  List<Object> get props => [lessons];
}

class LessonError extends LessonState {
  final String error;
  const LessonError(this.error);
  @override
  List<Object> get props => [error];
}
