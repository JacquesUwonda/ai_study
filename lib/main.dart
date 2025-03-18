import 'package:ai_study/app/logic/lesson/lesson_bloc.dart';
import 'package:ai_study/app/logic/quiz/quiz_bloc.dart';
import 'package:ai_study/app/screens/home.dart';
import 'package:ai_study/app/screens/quiz_screen.dart';
import 'package:ai_study/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => LessonBloc()),
        BlocProvider(create: (context) => QuizBloc()),
      ],
      child: MaterialApp(
        title: 'Learn Programming',
        theme: AppTheme.lightTheme,
        initialRoute: '/home',
        routes: {
          // '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/quiz': (context) => QuizScreen(topic: 'Python Basics'),
        },
      ),
    );
  }
}
