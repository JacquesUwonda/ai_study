part of 'lesson_bloc.dart';

abstract class LessonEvent extends Equatable {
  const LessonEvent();
  @override
  List<Object> get props => [];
}

class LoadLessonEvent extends LessonEvent {
  final String topic;
  const LoadLessonEvent(this.topic);
  @override
  List<Object> get props => [topic];
}
