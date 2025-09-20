import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_new/firebase_options.dart';
import 'injection.dart';
import 'presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/file_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initInjection();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the providers using GetIt factories
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<FileProvider>()),
      ],
      child: MaterialApp(
        title: 'Firebase Provider Clean Architecture',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: SplashScreen(),
      ),
    );
  }
}