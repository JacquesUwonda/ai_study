import 'package:ai_study/app/domain/models/quiz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial());

  Stream<QuizState> mapEventToState(QuizEvent event) async* {
    if (event is LoadQuizEvent) {
      yield QuizLoading();
      try {
        // Simuler un chargement de quiz (remplacez par un appel API ou une base de données)
        final quiz = Quiz(
          question: 'What is a variable in Python?',
          options: ['A container for data', 'A function', 'A loop', 'A class'],
          correctAnswer: 'A container for data',
        );
        yield QuizLoaded(quiz: quiz, selectedOption: '');
      } catch (e) {
        yield QuizError(e.toString());
      }
    } else if (event is SelectOptionEvent) {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        yield QuizLoaded(quiz: currentState.quiz, selectedOption: event.option);
      }
    } else if (event is SubmitQuizEvent) {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        final isCorrect =
            currentState.selectedOption == currentState.quiz.correctAnswer;
        yield QuizResult(isCorrect: isCorrect);
      }
    }
  }
}
