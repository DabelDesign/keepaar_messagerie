import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'screens/svg_screen.dart';
import 'screens/home_screen.dart';
import 'services/appwrite_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌱 Chargement du fichier .env
  try {
    await dotenv.load(fileName: ".env");
    final endpoint = dotenv.env['APPWRITE_ENDPOINT'];
    final projectId = dotenv.env['APPWRITE_PROJECT_ID'];
    if (endpoint == null || projectId == null) {
      throw Exception("Variables .env manquantes : APPWRITE_ENDPOINT ou APPWRITE_PROJECT_ID");
    }
    debugPrint("✅ .env chargé avec succès !");
  } catch (e) {
    debugPrint("❌ Erreur chargement .env : $e");
  }

  // 🔥 Initialisation Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("✅ Firebase initialisé !");
  } catch (e) {
    debugPrint("❌ Erreur initialisation Firebase : $e");
  }

  // 🔔 Notifications push (mobile uniquement)
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission();
      debugPrint("🔔 Autorisation notifications : ${settings.authorizationStatus}");

      messaging.getToken().then((token) {
        if (token != null) {
          debugPrint("✅ Token Firebase Messaging : $token");
        } else {
          debugPrint("⚠️ Aucun token généré !");
        }
      }).catchError((e) {
        debugPrint("❌ Erreur récupération token : $e");
      });
    } else {
      debugPrint("⚠️ Notifications Firebase désactivées sur ${Platform.operatingSystem}");
    }
  } catch (e) {
    debugPrint("❌ Erreur configuration notifications : $e");
  }

  // 🔗 Connexion Appwrite + rôle utilisateur
  try {
    final appwrite = AppwriteService();
    await appwrite.checkConnection();
    debugPrint("✅ Connexion Appwrite réussie !");

    final role = await appwrite.checkUserRole();
    debugPrint("🔎 Rôle de l'utilisateur : $role");
  } catch (e) {
    debugPrint("❌ Erreur Appwrite : $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keepaar Messagerie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/svg': (context) => const SvgScreen(),
      },
      builder: (context, child) => ScaffoldMessenger(child: child ?? const SizedBox()),
    );
  }
}
// 📌 Point d'entrée de l'application Flutter
// 📍 Chemin : C:\Users\ibras\FlutterProjects\keepaar_messagerie\lib\main.dart
//
// Ce fichier initialise les services essentiels et lance l'application.
// Il gère :
// ✅ Le chargement des variables d'environnement (.env)
// ✅ L'initialisation de Firebase et Appwrite
// ✅ La gestion des notifications push
// ✅ La définition des routes et du thème global