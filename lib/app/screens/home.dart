import 'package:ai_study/app/domain/models/conversation.dart';
import 'package:ai_study/app/logic/lesson/lesson_state.dart';
import 'package:ai_study/app/screens/quiz_screen.dart';
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
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();
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
      textController.clear();
    });

    //reset to initial
    context.read<LessonBloc>().add(ResetLessonEvent());
  }

  Future<void> _loadTopic(Topic topic) async {
    setState(() {
      _currentTopic = topic;
    });
    context.read<LessonBloc>().add(LoadLessonEvent(topic.title));
  }

  Future<void> _sendMessage() async {
    final topicTitle = textController.text.trim();
    if (topicTitle.isEmpty) return;

    if (_currentTopic == null) {
      final topicId = await _dbHelper.insertTopic(topicTitle);
      final newTopic = Topic(
        id: topicId,
        title: topicTitle,
        lessons: [],
        quizzes: [],
      );
      setState(() {
        _currentTopic = newTopic;
        _topics.add(newTopic);
      });
    }

    // ignore: use_build_context_synchronously
    context.read<LessonBloc>().add(LoadLessonEvent(topicTitle));
    textController.clear();
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
              child: Column(
                spacing: 20,
                children: [
                  Text(
                    'Topics',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '© 2025 - Jacques Uwonda',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(162, 214, 214, 214),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('New Topic'),
              onTap: () {
                _startNewTopic();
                Navigator.pop(context);
              },
            ),
            Divider(),
            ..._topics.reversed.map((topic) {
              return ListTile(
                title: Text(topic.title),
                onTap: () {
                  _loadTopic(topic);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      body: Column(
        children: [
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
                        onContinue: () {
                          // Charger la leçon suivante
                          context.read<LessonBloc>().add(
                            LoadLessonEvent(
                              _currentTopic!.title,
                              lessonIndex: index + 1,
                            ),
                          );
                        },
                        onQuiz: () {
                          // Naviguer vers l'écran de quiz
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      QuizScreen(topic: _currentTopic!.title),
                            ),
                          );
                        },
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
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
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
