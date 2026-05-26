import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/explore_provider.dart';
import 'views/auth_wrapper.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
      ],
      child: const GameVaultApp(),
    ),
  );
}

class GameVaultApp extends StatelessWidget { 
  const GameVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Vault', 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent, 
          brightness: Brightness.light, 
        ),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}