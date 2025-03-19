import 'package:ai_study/app/domain/models/lesson.dart';
import 'package:ai_study/app/logic/lesson/lesson_state.dart';
import 'package:ai_study/app/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'lesson_event.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final GeminiService _geminiService = GeminiService();
  List<Lesson> lessons = [];
  int _currentLessonIndex = 0;

  LessonBloc() : super(LessonInitial()) {
    on<LoadLessonEvent>((event, emit) async {
      emit(LessonLoading());
      try {
        // Générer une nouvelle leçon ou charger une leçon existante
        if (event.lessonIndex < lessons.length) {
          // Charger une leçon existante
          emit(LessonLoaded(lessons, _currentLessonIndex));
        } else {
          // Générer une nouvelle leçon
          final lessonContent = await _geminiService.getLesson(
            event.topic,
            lessonIndex: event.lessonIndex,
          );

          final lesson = Lesson(
            title: 'Lesson ${event.lessonIndex + 1}: ${event.topic}',
            description: lessonContent,
          );

          lessons.add(lesson);
          _currentLessonIndex = event.lessonIndex; //update the current index

          emit(LessonLoaded(lessons, _currentLessonIndex));
        }
      } catch (e) {
        emit(LessonError(e.toString()));
      }
    });
    on<ResetLessonEvent>((event, emit) {
      emit(LessonInitial()); // Reset the state
    });
  }
}
