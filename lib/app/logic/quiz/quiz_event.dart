part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();
  @override
  List<Object> get props => [];
}

class LoadQuizEvent extends QuizEvent {}

class SelectOptionEvent extends QuizEvent {
  final String option;
  const SelectOptionEvent(this.option);
  @override
  List<Object> get props => [option];
}

class SubmitQuizEvent extends QuizEvent {}
