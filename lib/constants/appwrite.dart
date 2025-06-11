import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static String endpoint = dotenv.env['APPWRITE_ENDPOINT'] ?? "";
  static String projectId = dotenv.env['APPWRITE_PROJECT_ID'] ?? "";
  static String apiKey = dotenv.env['APPWRITE_API_KEY'] ?? "";
}