import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = 'AIzaSyD_6qxDoNDdkzRUoIDThDTQ2n0gZfwDH8c';

  Future<String> getLesson(String topic, {int lessonIndex = 0}) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final prompt = '''
You are a professional tutor. Explain $topic in simple terms for a beginner.
This is lesson ${lessonIndex + 1}. ${lessonIndex > 0 ? 'Build on the previous lessons.' : 'Start with the basics.'}
Provide examples and analogies. Keep the explanation concise and easy to understand.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'No response from Gemini';
    } catch (e) {
      throw Exception('Failed to load lesson: $e');
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
Generate a quiz with ten question about $topic. Provide:
- A question.
- Four options (one correct, three incorrect).
- The correct answer.
Return the response as a JSON array with objects containing keys: question, options, correctAnswer.
Do not include any markdown code blocks, just return the json.
Example:
[
  {
    "question": "What is a variable in Python?",
    "options": ["A container for data", "A function", "A loop", "A class"],
    "correctAnswer": "A container for data"
  },
  {
    "question": "What is the output of `print(type(5))`?",
    "options": ["<class 'str'>", "<class 'int'>", "<class 'float'>", "<class 'bool'>"],
    "correctAnswer": "<class 'int'>"
  }
]
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception('Gemini returned an empty response');
      }

      String jsonString = response.text!;

      // Remove code block markers
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7); // Remove '```json'
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(
          0,
          jsonString.length - 3,
        ); // Remove '```'
      }

      try {
        final dynamic decodedResponse = jsonDecode(jsonString);

        if (decodedResponse is List) {
          return decodedResponse.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Gemini response is not a valid JSON array');
        }
      } catch (e) {
        throw Exception('Failed to decode JSON: $e. Raw response: $jsonString');
      }
    } catch (e) {
      throw Exception('Failed to generate quiz: $e');
    }
  }
}
