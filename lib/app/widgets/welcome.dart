import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_study/app/logic/lesson/lesson_bloc.dart';
import 'package:ai_study/app/widgets/topic_card.dart';

class Welcome extends StatelessWidget {
  final List<Map<String, dynamic>> topics = [
    {'title': 'Python Basics', 'icon': Icons.code},
    {'title': 'JavaScript', 'icon': Icons.web},
    {'title': 'Data Structures', 'icon': Icons.architecture},
    {'title': 'Machine Learning', 'icon': Icons.analytics},
    {'title': 'Flutter', 'icon': Icons.phone_android},
    {'title': 'Algorithms', 'icon': Icons.timeline},
  ];

  Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            // Welcome Message
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    'Welcome to Learn Programming!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'Explore programming topics and learn interactively. Tap on a topic to get started!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Popular Topics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Popular Programming Topics',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TopicCard(
                      title: topic['title'],
                      icon: topic['icon'],
                      onTap:
                          () => context.read<LessonBloc>().add(
                            LoadLessonEvent(topic['title']),
                          ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'What do you want to learn?',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
