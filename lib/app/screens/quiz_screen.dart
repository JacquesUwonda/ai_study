import 'package:ai_study/app/domain/models/badge_model.dart';
import 'package:ai_study/app/logic/quiz/quiz_bloc.dart';
import 'package:ai_study/app/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizScreen extends StatelessWidget {
  final String topic;

  const QuizScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    // Déclencher l'événement LoadQuizEvent dès que l'écran est chargé
    context.read<QuizBloc>().add(LoadQuizEvent(topic));

    return Scaffold(
      appBar: AppBar(title: Text('Quiz: $topic')),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is QuizLoaded) {
            final quiz = state.questions[state.currentQuestionIndex];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Afficher la progression (question X/10)
                    Text(
                      'Question ${state.currentQuestionIndex + 1}/${state.questions.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Afficher la question
                    Text(
                      quiz.question,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Afficher les options
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

                    // Bouton pour soumettre la réponse
                    ElevatedButton(
                      onPressed:
                          () => context.read<QuizBloc>().add(SubmitQuizEvent()),
                      child: Text('Submit'),
                    ),

                    // Afficher le score actuel
                    SizedBox(height: 20),
                    Text(
                      'Score: ${state.score}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is QuizCompleted) {
            // Afficher les résultats finaux
            return Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 48,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Quiz Completed!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Your Score: ${state.score}/10',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),

                      // Afficher des badges en fonction du score
                      if (state.score >= 8)
                        BadgeWidget(
                          badge: BadgeModel(
                            name: 'Master! Study more and become more genious.',
                            icon: Icons.star,
                          ),
                        ),
                      if (state.score >= 5 && state.score < 8)
                        BadgeWidget(
                          badge: BadgeModel(
                            name:
                                'Intermediate! You need to study more and become smart',
                            icon: Icons.emoji_events,
                          ),
                        ),
                      if (state.score < 5)
                        BadgeWidget(
                          badge: BadgeModel(
                            name:
                                'You are a Beginner yet! You need to restart your lesson.',
                            icon: Icons.school,
                          ),
                        ),

                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Back to Lessons'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is QuizError) {
            if (state.error.toLowerCase().contains("failed to load quiz")) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Connexion a echoue! Impossible de charger votre quiz",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Verifiez que vous etes connecte a un reseau ou au Wi-Fi",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Une erreur est survenue",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          }
          return Center(
            child: Text('No quiz generated, go back and retry again'),
          );
        },
      ),
    );
  }
}
