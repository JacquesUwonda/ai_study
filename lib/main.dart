import 'package:ai_study/app/auth/data/repository/auth_repo_implement.dart';
import 'package:ai_study/app/auth/presentation/logic/auth_bloc.dart';
import 'package:ai_study/app/auth/presentation/screens/login_screen.dart';
import 'package:ai_study/app/logic/lesson/lesson_bloc.dart';
import 'package:ai_study/app/logic/quiz/quiz_bloc.dart';
import 'package:ai_study/app/screens/home.dart';
import 'package:ai_study/app/screens/quiz_screen.dart';
import 'package:ai_study/app/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepositoryImplement())),
        BlocProvider(create: (context) => LessonBloc()),
        BlocProvider(create: (context) => QuizBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learn Programming',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/quiz': (context) => QuizScreen(topic: 'Python Basics'),
        },
      ),
    );
  }
}
