import 'package:ai_study/app/services/gemini_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  List<Map<String, String>> _messageHistory = [];

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Ajouter le message de l'utilisateur à l'historique
    _messageHistory.add({'text': text, 'role': 'user'});

    // Obtenir la réponse de Gemini
    final response = await _geminiService.sendMessage(text, _messageHistory);

    // Ajouter la réponse de Gemini à l'historique
    _messageHistory.add({'text': response, 'role': 'model'});

    // Mettre à jour l'UI
    setState(() {
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with Gemini')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messageHistory.length,
              itemBuilder: (context, index) {
                final message = _messageHistory[index];
                return ListTile(
                  title: Text(message['text']!),
                  subtitle: Text(message['role'] == 'user' ? 'You' : 'Gemini'),
                  tileColor:
                      message['role'] == 'user'
                          ? Colors.grey[200]
                          : Colors.white,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
