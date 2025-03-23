import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  //Methode pour generer les lecons
  Future<String> getLesson(String topic, {int lessonIndex = 0}) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final prompt = '''
Vous êtes un tuteur professionnel. Expliquez $topic en termes simples pour un débutant.
Ceci est la leçon ${lessonIndex + 1}. ${lessonIndex > 0 ? 'Construisez sur les leçons précédentes.' : 'Commencez par les bases.'}
Fournissez des exemples et des analogies. Gardez l'explication concise et facile à comprendre.
**Le contenu doit être en français.**
    ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'Pas de réponse de Gemini';
    } catch (e) {
      throw Exception('Échec du chargement de la leçon: $e');
    }
  }

  // Méthode pour générer un quiz
  Future<List<Map<String, dynamic>>> getQuiz(String topic) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final prompt = '''
Générez un quiz de dix questions sur $topic. Pour chaque question, fournissez :
- Une question.
- Quatre options (une correcte, trois incorrectes).
- La réponse correcte.
Retournez la réponse sous forme d'un tableau JSON avec des objets contenant les clés : question, options, correctAnswer.
**Le contenu doit être en français.**
Ne pas inclure de blocs de code markdown, retournez uniquement le JSON.
Exemple :
[
  {
    "question": "Qu'est-ce qu'une variable en Python ?",
    "options": ["Un conteneur pour les données", "Une fonction", "Une boucle", "Une classe"],
    "correctAnswer": "Un conteneur pour les données"
  },
  {
    "question": "Quelle est la sortie de `print(type(5))` ?",
    "options": ["<class 'str'>", "<class 'int'>", "<class 'float'>", "<class 'bool'>"],
    "correctAnswer": "<class 'int'>"
  }
]
    ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception('Gemini a retourné une réponse vide');
      }

      String jsonString = response.text!;

      // Supprimer les marqueurs de bloc de code
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7); // Supprimer '```json'
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(
          0,
          jsonString.length - 3,
        ); // Supprimer '```'
      }

      try {
        final dynamic decodedResponse = jsonDecode(jsonString);

        if (decodedResponse is List) {
          return decodedResponse.cast<Map<String, dynamic>>();
        } else {
          throw Exception(
            'La réponse de Gemini n\'est pas un tableau JSON valide',
          );
        }
      } catch (e) {
        throw Exception(
          'Échec du décodage JSON: $e. Réponse brute: $jsonString',
        );
      }
    } catch (e) {
      throw Exception('Échec de la génération du quiz: $e');
    }
  }
}
