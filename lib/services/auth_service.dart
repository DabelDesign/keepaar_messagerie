import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final Account _account;

  AuthService(Client client) : _account = Account(client);

  Future<void> loginWithPhone(String phoneNumber, String password) async {
    try {
      final session = await _account.createSession(
        userId: phoneNumber,
        secret: password,
      );
      debugPrint("✅ Session créée : ${session.$id}");
    } catch (e) {
      debugPrint("❌ Erreur login téléphone : $e");
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSessions();
      debugPrint("✅ Déconnexion réussie !");
    } catch (e) {
      debugPrint("❌ Erreur de déconnexion : $e");
    }
  }
}
// 📌 Service d'authentification avec Appwrite
// 📍 Chemin : C:\Users\ibras\FlutterProjects\keepaar_messagerie\lib\services\auth_service.dart
//
// Ce fichier gère :
// ✅ La connexion des utilisateurs via Appwrite
// ✅ La création de session avec un numéro de téléphone et un mot de passe
// ✅ La gestion de la déconnexion et suppression des sessions
// ✅ L'affichage des erreurs et des logs pour le debug