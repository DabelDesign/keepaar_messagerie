import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import '../services/appwrite_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late final AppwriteService _appwriteService;
  String userId = 'unknown';
  List<Document> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _initChat();
  }

  Future<void> _initChat() async {
    await _getUserId();
    await _loadMessages();
  }

  Future<void> _getUserId() async {
    try {
      final id = await _appwriteService.getUserId() ?? 'unknown';
      if (mounted) {
        setState(() {
          userId = id;
        });
      }
    } catch (e) {
      debugPrint("❌ Erreur récupération userId : $e");
    }
  }

  Future<void> _loadMessages() async {
    try {
      final response = await _appwriteService.databases.listDocuments(
        databaseId: dotenv.env['DATABASE_ID'] ?? '',
        collectionId: dotenv.env['COLLECTION_ID'] ?? '',
      );
      if (mounted) {
        setState(() {
          _messages = response.documents;
          _isLoading = false;
        });
      }
    } on AppwriteException catch (e) {
      debugPrint("❌ Erreur chargement messages : ${e.message}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors du chargement des messages : ${e.message}")),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        await _appwriteService.createDocument(_controller.text, userId);
        _controller.clear();
        _loadMessages(); // Rechargement après envoi
      } on AppwriteException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Erreur envoi message : ${e.message}")),
        );
      }
    }
  }

  Future<void> _uploadFile() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final fileId = await _appwriteService.uploadFile('file.mp4');
        if (fileId != null) {
          debugPrint("✅ Fichier envoyé ! ID : $fileId");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Upload non pris en charge sur cette plateforme")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur envoi fichier : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keepaar Messagerie")),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? const Center(child: Text("Aucun message pour l’instant"))
                : ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final doc = _messages[index];
                final message = doc.data['message'] ?? '(message vide)';
                final timestamp = doc.data['timestamp'] ?? '';
                return ListTile(
                  title: Text(message),
                  subtitle: Text(timestamp),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: "💬 Écrire un message..."),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
                IconButton(icon: const Icon(Icons.attach_file), onPressed: _uploadFile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// 📌 Écran de messagerie instantanée
// 📍 Chemin : C:\Users\ibras\FlutterProjects\keepaar_messagerie\lib\screens\chat_screen.dart
//
// Ce fichier gère :
// ✅ L'affichage des messages récupérés depuis Appwrite (base de données en temps réel)
// ✅ L'envoi de nouveaux messages via Appwrite
// ✅ La gestion des fichiers joints avec Appwrite Storage
// ✅ L'initialisation de l'utilisateur et des permissions via Appwrite Auth
// ✅ L'utilisation d'un `StatefulWidget` pour gérer les mises à jour dynamiques