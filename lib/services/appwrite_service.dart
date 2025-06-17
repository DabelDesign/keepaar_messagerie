import 'dart:io';
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

  /// 🔐 Vérifie la connexion Appwrite
  Future<void> checkConnection() async {
    try {
      final user = await account.get();
      debugPrint("✅ Connexion réussie ! Utilisateur ID : ${user.$id}");
    } on AppwriteException catch (e) {
      debugPrint("❌ Erreur de connexion : ${e.message}");
    }
  }

  /// 🧠 Récupère l’ID de l'utilisateur
  Future<String?> getUserId() async {
    try {
      final user = await account.get();
      return user.$id;
    } on AppwriteException catch (e) {
      debugPrint("❌ Erreur récupération utilisateur : ${e.message}");
      return null;
    }
  }

  /// 🔎 Retourne le rôle utilisateur
  Future<String> checkUserRole() async {
    try {
      final user = await account.get();
      return user.prefs.data['role'] ?? "guest";
    } on AppwriteException catch (e) {
      debugPrint("❌ Erreur rôle utilisateur : ${e.message}");
      return "guest";
    }
  }

  /// 📥 Crée un document (message)
  Future<void> createDocument(String message, String userId) async {
    final dbId = dotenv.env['DATABASE_ID'] ?? '';
    final colId = dotenv.env['COLLECTION_ID'] ?? '';
    if (dbId.isEmpty || colId.isEmpty) {
      debugPrint("❌ DATABASE_ID ou COLLECTION_ID manquant !");
      return;
    }

    try {
      await databases.createDocument(
        databaseId: dbId,
        collectionId: colId,
        documentId: ID.unique(),
        data: {
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
          'user_id': userId,
          'id': ID.unique(),
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'permissions': ["role:member"],
        },
      );
      debugPrint("✅ Message enregistré !");
    } on AppwriteException catch (e) {
      debugPrint("❌ Erreur ajout message : ${e.message}");
    }
  }

  /// 🗂️ Upload un fichier
  Future<String?> uploadFile(String filePath) async {
    final bucketId = dotenv.env['BUCKET_ID'] ?? '';
    if (bucketId.isEmpty) {
      debugPrint("❌ BUCKET_ID manquant !");
      return null;
    }

    if (!File(filePath).existsSync()) {
      debugPrint("❌ Fichier introuvable : $filePath");
      return null;
    }

    try {
      final result = await storage.createFile(
          bucketId: bucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: filePath),
          permissions: ["role:member"]
      );
      debugPrint("✅ Fichier uploadé !");
      return result.$id;
    } on AppwriteException catch (e) {
      debugPrint("❌ Erreur upload fichier : ${e.message}");
      return null;
    }
  }

  /// 🔗 Récupère l'URL d'un fichier
  Future<String?> getFileUrl(String fileId) async {
    final bucketId = dotenv.env['BUCKET_ID'] ?? '';
    if (bucketId.isEmpty) {
      debugPrint("❌ BUCKET_ID manquant !");
      return null;
    }

    try {
      final result = await storage.getFileDownload(
        bucketId: bucketId,
        fileId: fileId,
      );
      return result.toString();
    } on AppwriteException catch (e) {
      debugPrint("❌ Erreur récupération fichier : ${e.message}");
      return null;
    }
  }
}
// 📌 Service Appwrite pour la gestion des utilisateurs, des bases de données et du stockage
// 📍 Chemin : C:\Users\ibras\FlutterProjects\keepaar_messagerie\lib\services\appwrite_service.dart
//
// Ce fichier gère :
// ✅ La connexion à Appwrite via le client API
// ✅ L'authentification des utilisateurs
// ✅ La gestion des bases de données (création et récupération de documents)
// ✅ Le stockage et la récupération de fichiers
// ✅ La gestion des rôles et permissions utilisateur