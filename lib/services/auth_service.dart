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