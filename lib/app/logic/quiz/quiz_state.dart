part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<Quiz> questions;
  final int currentQuestionIndex;
  final String? selectedOption;
  final int score;

  const QuizLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    this.selectedOption,
    required this.score,
  });

  @override
  List<Object> get props => [
    questions,
    currentQuestionIndex,
    selectedOption ?? '',
    score,
  ];
}

class QuizCompleted extends QuizState {
  final int score;

  const QuizCompleted({required this.score});

  @override
  List<Object> get props => [score];
}

class QuizError extends QuizState {
  final String error;
  const QuizError(this.error);
  @override
  List<Object> get props => [error];
}
