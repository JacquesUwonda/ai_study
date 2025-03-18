import 'package:ai_study/app/widgets/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_study/app/logic/lesson/lesson_bloc.dart';
import '../widgets/lesson_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Learn with AI')),
      body: Column(
        children: [
          // Lessons List
          Expanded(
            child: BlocBuilder<LessonBloc, LessonState>(
              builder: (context, state) {
                if (state is LessonLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is LessonLoaded) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = state.lessons[index];
                      return LessonCard(
                        title: lesson.title,
                        description: lesson.description,
                      );
                    },
                  );
                } else if (state is LessonError) {
                  return Center(child: Text(state.error));
                }
                return Welcome();
              },
            ),
          ),
          // Input Section
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                // Text Input
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Enter a topic (e.g., Python Basics)',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Send Button
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      final topic = textController.text.trim();
                      if (topic.isNotEmpty) {
                        context.read<LessonBloc>().add(LoadLessonEvent(topic));
                        textController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
