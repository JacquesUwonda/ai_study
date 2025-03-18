import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey =
      'AIzaSyD_6qxDoNDdkzRUoIDThDTQ2n0gZfwDH8c'; // Remplacez par votre clé API

  // Méthode existante pour obtenir une leçon
  Future<String> getLesson(String topic) async {
    try {
      // Initialiser le modèle
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest', // Utiliser le dernier modèle Gemini
        apiKey: apiKey,
      );

      // Définir le prompt
      final prompt = '''
Explain $topic in simple terms for a beginner. Provide examples and analogies.
Keep the explanation concise and easy to understand. Introduce it in a style like: Let's break your lesson down. Before we go far, let's start with the basics. Here is what you have to know. Then at the end, ask if the user wants to know more about the topic.
      ''';

      // Générer le contenu
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      // Retourner le texte généré
      return response.text ?? 'No response from Gemini';
    } catch (e) {
      throw Exception('Failed to load lesson: $e');
    }
  }

  // Nouvelle méthode pour envoyer un message avec l'historique
  Future<String> sendMessage(
    String message,
    List<Map<String, String>> history,
  ) async {
    try {
      // Initialiser le modèle
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest', // Utiliser le dernier modèle Gemini
        apiKey: apiKey,
      );

      // Convertir l'historique en format de conversation
      final content =
          history.map((msg) {
            return Content.text(msg['text']!);
          }).toList();

      // Ajouter le nouveau message de l'utilisateur
      content.add(Content.text(message));

      // Générer la réponse
      final response = await model.generateContent(content);

      // Retourner le texte généré
      return response.text ?? 'No response from Gemini';
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}

// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   final String apiKey =
//       'AIzaSyD_6qxDoNDdkzRUoIDThDTQ2n0gZfwDH8c'; // Replace with your actual API key

//   Future<String> getLesson(String topic) async {
//     try {
//       // Initialize the model
//       final model = GenerativeModel(
//         model: 'gemini-1.5-flash-latest', // Use the latest Gemini model
//         apiKey: apiKey,
//       );

//       // Define the prompt
//       final prompt = '''
// Explain $topic in simple terms for a beginner. Provide examples and analogies.
// Keep the explanation concise and easy to understand. introduce it in a style like : Let's brake your lesson down, before we go far, let's start with the basics. here is what you have to know. Then at the end you ask him if he want to know more about the topic.
//       ''';

//       // Generate content
//       final content = [Content.text(prompt)];
//       final response = await model.generateContent(content);

//       // Return the generated text
//       return response.text ?? 'No response from Gemini';
//     } catch (e) {
//       throw Exception('Failed to load lesson: $e');
//     }
//   }
// }
