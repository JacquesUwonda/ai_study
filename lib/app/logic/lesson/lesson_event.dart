part of 'lesson_bloc.dart';

abstract class LessonEvent extends Equatable {
  const LessonEvent();
  @override
  List<Object> get props => [];
}

class LoadLessonEvent extends LessonEvent {
  final String topic;
  final int lessonIndex;

  const LoadLessonEvent(
    this.topic, {
    this.lessonIndex = 0,
  }); // Initialiser à 0 par défaut

  @override
  List<Object> get props => [topic, lessonIndex]; // Ajouter lessonIndex aux props
}

class ResetLessonEvent extends LessonEvent {}
