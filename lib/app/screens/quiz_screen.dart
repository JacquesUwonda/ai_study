import 'package:ai_study/app/logic/quiz/quiz_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizScreen extends StatelessWidget {
  final String topic;

  const QuizScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz: $topic')),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is QuizLoaded) {
            final quiz = state.quiz;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    quiz.question,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ...quiz.options.map(
                    (option) => RadioListTile(
                      value: option,
                      groupValue: state.selectedOption,
                      onChanged:
                          (value) => context.read<QuizBloc>().add(
                            SelectOptionEvent(value!),
                          ),
                      title: Text(option),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        () => context.read<QuizBloc>().add(SubmitQuizEvent()),
                    child: Text('Submit'),
                  ),
                ],
              ),
            );
          } else if (state is QuizResult) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.isCorrect ? 'Correct!' : 'Incorrect!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Back to Lessons'),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('Press the button to start the quiz'));
        },
      ),
    );
  }
}
