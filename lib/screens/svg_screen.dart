import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io'; // ✅ Ajout pour vérifier si le fichier existe

class SvgScreen extends StatelessWidget {
  const SvgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Affichage SVG"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: _buildSvgImage(), // ✅ Affichage du SVG avec gestion d'erreur
          ),
        ),
      ),
    );
  }

  Widget _buildSvgImage() {
    const String svgPath = "assets/images/logo.svg";

    // Vérifier si le fichier SVG existe
    if (!File(svgPath).existsSync()) {
      return _errorWidget("Le fichier SVG est introuvable !");
    }

    return FutureBuilder<void>(
      future: Future.delayed(const Duration(seconds: 1)), // Simuler un chargement
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // ✅ Affichage du loader
        } else {
          try {
            return SvgPicture.asset(
              svgPath,
              width: 150,
              height: 100,
            );
          } catch (error) {
            return _errorWidget("Erreur de chargement du SVG !");
          }
        }
      },
    );
  }

  Widget _errorWidget(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 100, color: Colors.red),
        const SizedBox(height: 10),
        Text(
          message,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }
}