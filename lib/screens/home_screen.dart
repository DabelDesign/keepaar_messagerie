import 'package:flutter/material.dart';
import 'chat_screen.dart'; // ✅ Ajout de l’import de l’écran de chat
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
          // ✅ Ajout d'un logo (remplace 'assets/images/logo.png' par ton vrai logo)
          Image.asset(
            'assets/images/logo.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20), // ✅ Espacement
          const Text(
            "Bienvenue sur Keepaar Messagerie !",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), // ✅ Espacement
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            child: const Text("Accéder au chat"),
          ),
        ],
      ),
    );
  }
}