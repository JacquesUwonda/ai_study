import 'package:ai_study/app/domain/models/lesson.dart';
import 'package:ai_study/app/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final GeminiService _geminiService = GeminiService();

  LessonBloc() : super(LessonInitial()) {
    on<LoadLessonEvent>((event, emit) async {
      emit(LessonLoading());
      try {
        // Generate lesson content using Gemini
        final lessonContent = await _geminiService.getLesson(event.topic);

        // Create a list of lessons (you can customize this)
        final lessons = [
          Lesson(
            title: 'Introduction to ${event.topic}',
            description: lessonContent,
          ),
          Lesson(
            title: 'Advanced ${event.topic}',
            description: 'More details about ${event.topic}',
          ),
        ];

        emit(LessonLoaded(lessons));
      } catch (e) {
        emit(LessonError(e.toString()));
      }
    });
  }
}
