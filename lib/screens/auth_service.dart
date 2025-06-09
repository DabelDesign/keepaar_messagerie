import 'package:appwrite/appwrite.dart';

class AuthService {
  final Client _client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // Remplace par ton endpoint
    ..setProject('your_project_id'); // Remplace par ton ID de projet

  final Account _account;

  AuthService() : _account = Account(Client());

  Future<String?> loginWithPhone(String phoneNumber) async {
    try {
      final session = await _account.createPhoneSession(
        userId: ID.unique(),
        phone: phoneNumber,
      );
      return session.$id; // Retourne l’ID de session
    } catch (e) {
      print("Erreur d’authentification : $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSessions();
      print("Utilisateur déconnecté !");
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final session = await _account.getSession(sessionId: 'current');
      return session.$id.isNotEmpty; // Retourne `true` si session active
    } catch (e) {
      return false;
    }
  }
}
