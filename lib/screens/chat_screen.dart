import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/appwrite_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late final AppwriteService _appwriteService;
  late final String userId;

  @override
  void initState() {
    super.initState();
    final client = Client()
      ..setEndpoint(dotenv.env['APPWRITE_ENDPOINT'] ?? '')
      ..setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '');

    _appwriteService = AppwriteService();
    _getUserId();
  }

  void _getUserId() async {
    userId = await _appwriteService.getUserId() ?? 'unknown';
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        await _appwriteService.createDocument(_controller.text, userId);
        _controller.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Erreur lors de l’envoi du message : $e")),
        );
      }
    }
  }

  Future<void> _uploadFile() async {
    try {
      final fileId = await _appwriteService.uploadFile('file.mp4');
      if (fileId != null) {
        print("✅ Fichier envoyé ! ID : $fileId");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur de téléchargement : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keepaar Messagerie"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _appwriteService.databases.listDocuments(
                databaseId: dotenv.env['DATABASE_ID'] ?? '',
                collectionId: dotenv.env['COLLECTION_ID'] ?? '',
              ),
              builder: (context, AsyncSnapshot response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (response.hasError) {
                  return const Center(child: Text("❌ Erreur de chargement"));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: response.data.documents.length,
                  itemBuilder: (context, index) {
                    var doc = response.data.documents[index];
                    return ListTile(
                      title: Text(doc.data['message']),
                      subtitle: Text(doc.data['timestamp']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: _controller, decoration: const InputDecoration(labelText: "💬 Écrire un message...")),
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