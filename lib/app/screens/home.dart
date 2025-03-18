import 'package:ai_study/app/domain/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_study/app/logic/lesson/lesson_bloc.dart';
import 'package:ai_study/app/services/database_helper.dart';
import 'package:ai_study/app/widgets/welcome.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/lesson_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Topic> _topics = [];
  Topic? _currentTopic;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final topics = await _dbHelper.getTopics();
    setState(() {
      _topics = topics;
    });
  }

  Future<void> _startNewTopic() async {
    setState(() {
      _currentTopic = null;
    });
  }

  Future<void> _loadTopic(Topic topic) async {
    setState(() {
      _currentTopic = topic;
    });
  }

  Future<void> _sendMessage() async {
    final topicTitle = _textController.text.trim();
    if (topicTitle.isEmpty) return;

    // Créer un nouveau topic si nécessaire
    if (_currentTopic == null) {
      final topicId = await _dbHelper.insertTopic(topicTitle);
      _currentTopic = Topic(
        id: topicId,
        title: topicTitle,
        lessons: [],
        quizzes: [],
      );
      _topics.add(_currentTopic!);
    }

    // Charger les leçons et les quiz pour ce topic
    context.read<LessonBloc>().add(LoadLessonEvent(topicTitle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(_currentTopic?.title ?? 'Learn with AI')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Topics',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ..._topics.map((topic) {
              return ListTile(
                title: Text(topic.title),
                onTap: () {
                  _loadTopic(topic);
                  Navigator.pop(context);
                },
              );
            }).toList(),
            Divider(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('New Topic'),
              onTap: () {
                _startNewTopic();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
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
                    controller: _textController,
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
                    onPressed: _sendMessage,
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

// import 'package:ai_study/app/widgets/welcome.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ai_study/app/logic/lesson/lesson_bloc.dart';
// import '../widgets/lesson_card.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController textController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: Text('Learn with AI')),
//       body: Column(
//         children: [
//           // Lessons List
//           Expanded(
//             child: BlocBuilder<LessonBloc, LessonState>(
//               builder: (context, state) {
//                 if (state is LessonLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (state is LessonLoaded) {
//                   return ListView.builder(
//                     padding: EdgeInsets.symmetric(vertical: 8),
//                     itemCount: state.lessons.length,
//                     itemBuilder: (context, index) {
//                       final lesson = state.lessons[index];
//                       return LessonCard(
//                         title: lesson.title,
//                         description: lesson.description,
//                       );
//                     },
//                   );
//                 } else if (state is LessonError) {
//                   return Center(child: Text(state.error));
//                 }
//                 return Welcome();
//               },
//             ),
//           ),
//           // Input Section
//           Container(
//             padding: EdgeInsets.all(10),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 // Text Input
//                 Expanded(
//                   child: TextField(
//                     controller: textController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter a topic (e.g., Python Basics)',
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 // Send Button
//                 CircleAvatar(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   child: IconButton(
//                     icon: Icon(Icons.send, color: Colors.white),
//                     onPressed: () {
//                       final topic = textController.text.trim();
//                       if (topic.isNotEmpty) {
//                         context.read<LessonBloc>().add(LoadLessonEvent(topic));
//                         textController.clear();
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
