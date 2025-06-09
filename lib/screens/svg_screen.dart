import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            child: _buildSvgImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildSvgImage() {
    try {
      return SvgPicture.asset(
        "assets/images/logo.svg",
        width: 150,  // ✅ Virgule ajoutée
        height: 100, // ✅ Virgule ajoutée
        placeholderBuilder: (context) => const CircularProgressIndicator(),
      );
    } catch (error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 100, color: Colors.red),
          const SizedBox(height: 10),
          Text(
            "Erreur de chargement du SVG",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      );
    }
  }
}