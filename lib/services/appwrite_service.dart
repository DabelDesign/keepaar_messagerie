import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Storage storage;

  AppwriteService() {
    client = Client()
      ..setEndpoint(dotenv.env['APPWRITE_ENDPOINT'] ?? '')
      ..setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '')
      ..setSelfSigned(status: true);

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
  }

  /// ✅ Vérifie la connexion à Appwrite (sans `Health`)
  Future<void> checkConnection() async {
    try {
      final user = await account.get();
      debugPrint("✅ Connexion réussie ! Utilisateur ID : ${user.$id}");
    } catch (e) {
      debugPrint("❌ Erreur de connexion à Appwrite : $e");
    }
  }

  /// 🔎 Récupère l'ID de l'utilisateur connecté
  Future<String?> getUserId() async {
    try {
      final user = await account.get();
      return user.$id;
    } catch (e) {
      debugPrint("❌ Erreur récupération utilisateur : $e");
      return null;
    }
  }

  /// ✍️ Ajoute un message à la base de données
  Future<void> createDocument(String message, String userId) async {
    try {
      await databases.createDocument(
        databaseId: dotenv.env['DATABASE_ID'] ?? '',
        collectionId: dotenv.env['COLLECTION_ID'] ?? '',
        documentId: ID.unique(),
        data: {
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
          'user_id': userId,
        },
      );
      debugPrint("✅ Message ajouté !");
    } catch (e) {
      debugPrint("❌ Erreur ajout message : $e");
    }
  }

  /// 📦 Upload un fichier (ex: vidéo, image)
  Future<String?> uploadFile(String filePath) async {
    try {
      final result = await storage.createFile(
        bucketId: dotenv.env['BUCKET_ID'] ?? '',
        fileId: ID.unique(),
        file: InputFile.fromPath(path: filePath),
      );
      debugPrint("✅ Fichier envoyé ! ID : ${result.$id}");
      return result.$id;
    } catch (e) {
      debugPrint("❌ Erreur upload fichier : $e");
      return null;
    }
  }
}