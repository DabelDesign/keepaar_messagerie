import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/svg_screen.dart';
import 'screens/home_screen.dart';
import 'services/appwrite_service.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Assure l'initialisation avant exécution

  // 🔥 Charger les variables d'environnement avec gestion d'erreur
  try {
    await dotenv.load(fileName: ".env"); // Assurer le bon chargement du fichier
    if (kDebugMode) {
      print("✅ Fichier .env chargé avec succès !");
    }
  } catch (e) {
    print("❌ Erreur de chargement du fichier .env : $e");
  }

  // 🚀 Tester la connexion à Appwrite avec gestion d'erreur
  try {
    final appwrite = AppwriteService();
    await appwrite.checkConnection();
  } catch (e) {
    if (kDebugMode) {
      print("❌ Erreur de connexion à Appwrite : $e");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ Supprime le bandeau "debug"
      title: 'Keepaar Messagerie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // ✅ Ajout d'un écran d'accueil
      routes: {
        '/home': (context) => const HomeScreen(),
        '/svg': (context) => const SvgScreen(),
      },
      builder: (context, child) {
        return ScaffoldMessenger(
          child: child ?? const SizedBox(), // ✅ Évite les erreurs de `null`
        );
      },
    );
  }
}