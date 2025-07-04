import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/notes_provider.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/add_edit_note_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/notes': (_) => const NotesScreen(),
        '/add_edit_note': (_) => const AddEditNoteScreen(),
      },
    );
  }
}
