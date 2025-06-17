import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ✅ Support des SVG
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        centerTitle: true, // ✅ Centrage du titre
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ Logo adaptable (SVG ou Texte si l’image n’existe pas)
          SizedBox(
            width: 150,
            height: 150,
            child: SvgPicture.asset(
              'assets/images/logo.svg', // 📌 Remplace par ton vrai logo SVG
              placeholderBuilder: (context) => const Icon(
                Icons.chat_bubble, // ✅ Icône par défaut si logo absent
                size: 100,
                color: Colors.deepPurple,
              ),
            ),
          ),

          const SizedBox(height: 20), // ✅ Espacement
          const Text(
            "Bienvenue sur Keepaar Messagerie !",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20), // ✅ Espacement
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            child: const Text("Accéder au chat", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
// 📌 Écran d'accueil de l'application
// 📍 Chemin : C:\Users\ibras\FlutterProjects\keepaar_messagerie\lib\screens\home_screen.dart
//
// Ce fichier gère :
// ✅ L'affichage du logo et du message de bienvenue
// ✅ La navigation vers l'écran de chat
// ✅ L'utilisation de SVG pour un logo adaptable
// ✅ La mise en page avec `Column` et `SizedBox` pour un design structuré