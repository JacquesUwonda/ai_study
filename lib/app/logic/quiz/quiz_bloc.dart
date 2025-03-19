import 'package:ai_study/app/domain/models/quiz.dart';
import 'package:ai_study/app/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GeminiService _geminiService = GeminiService();
  List<Quiz> _questions = [];
  int currentQuestionIndex = 0;
  int score = 0;

  QuizBloc() : super(QuizInitial()) {
    on<LoadQuizEvent>((event, emit) async {
      emit(QuizLoading());
      try {
        final quizContent = await _geminiService.getQuiz(event.topic);
        _questions =
            quizContent.map((data) {
              return Quiz(
                question: data['question'] ?? 'No question generated',
                options: (data['options'] as List<dynamic>).cast<String>(),
                correctAnswer: data['correctAnswer'] ?? '',
              );
            }).toList();

        emit(
          QuizLoaded(
            questions: _questions,
            currentQuestionIndex: currentQuestionIndex,
            score: score,
          ),
        );
      } catch (e) {
        emit(QuizError(e.toString()));
      }
    });

    on<SelectOptionEvent>((event, emit) {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        emit(
          QuizLoaded(
            questions: currentState.questions,
            currentQuestionIndex: currentState.currentQuestionIndex,
            selectedOption: event.option,
            score: currentState.score,
          ),
        );
      }
    });

    on<SubmitQuizEvent>((event, emit) {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        final isCorrect =
            currentState.selectedOption ==
            currentState
                .questions[currentState.currentQuestionIndex]
                .correctAnswer;

        // Mettre à jour le score
        final newScore =
            isCorrect ? currentState.score + 1 : currentState.score;

        // Passer à la question suivante
        final nextQuestionIndex = currentState.currentQuestionIndex + 1;

        if (nextQuestionIndex < currentState.questions.length) {
          emit(
            QuizLoaded(
              questions: currentState.questions,
              currentQuestionIndex: nextQuestionIndex,
              score: newScore,
            ),
          );
        } else {
          // Fin du quiz
          emit(QuizCompleted(score: newScore));
        }
      }
    });
  }
}
