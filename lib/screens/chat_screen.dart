import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final Client _client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // Remplace par ton endpoint
    ..setProject('your_project_id'); // Remplace par l'ID de ton projet

  late final Databases _database;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _database = Databases(_client);
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        await _database.createDocument(
          databaseId: 'your_database_id',
          collectionId: 'messages',
          documentId: ID.unique(),
          data: {
            'text': _controller.text,
            'timestamp': DateTime.now().toString(),
            'senderId': 'user123',
          },
        );
        _controller.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l’envoi du message : $e")),
        );
      }
    }
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keepaar Messagerie"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _database.listDocuments(
                databaseId: 'your_database_id',
                collectionId: 'messages',
              ),
              builder: (context, AsyncSnapshot response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (response.hasError) {
                  return const Center(child: Text("Erreur de chargement"));
                }
                if (!response.hasData || response.data.documents.isEmpty) {
                  return const Center(
                    child: Text("Aucun message pour l’instant"),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: response.data.documents.length,
                  itemBuilder: (context, index) {
                    var doc = response.data.documents[index];
                    return ListTile(
                      title: Text(doc.data['text']),
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
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Écrire un message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
