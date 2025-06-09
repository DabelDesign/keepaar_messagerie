import 'package:flutter/material.dart';
import 'screens/svg_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ Supprime le bandeau "debug"
      title: 'Keepaar Messagerie - SVG Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SvgScreen(),
      routes: {
        '/svg': (context) => const SvgScreen(),
        // Ajoute ici d'autres routes si nécessaire
      },
      builder: (context, child) {
        return ScaffoldMessenger(
          child: child!,
        );
      },
    );
  }
}