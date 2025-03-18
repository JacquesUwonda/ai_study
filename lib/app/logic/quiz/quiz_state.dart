part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final Quiz quiz;
  final String selectedOption;
  const QuizLoaded({required this.quiz, required this.selectedOption});
  @override
  List<Object> get props => [quiz, selectedOption];
}

class QuizResult extends QuizState {
  final bool isCorrect;
  const QuizResult({required this.isCorrect});
  @override
  List<Object> get props => [isCorrect];
}

class QuizError extends QuizState {
  final String error;
  const QuizError(this.error);
  @override
  List<Object> get props => [error];
}
