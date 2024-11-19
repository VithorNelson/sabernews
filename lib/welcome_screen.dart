import 'package:flutter/material.dart';
import 'news_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade900], // Ambas as cores do gradiente são a mesma
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centraliza o conteúdo verticalmente
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagem centralizada
            SizedBox(
              height: 250, // Altura fixa para a imagem
              width: double.infinity, // Largura total
              child: Image.asset(
                'assets/images/welcome_image.jpeg', // Certifique-se de ter a imagem no diretório "assets"
                fit: BoxFit.cover, // Faz a imagem preencher o espaço
              ),
            ),
            const SizedBox(height: 20),
            // Texto estilizado
            const Text(
              'Bem-vindo!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Destaque com laranja da imagem
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Explore as últimas notícias com apenas um toque.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            // Botão estilizado
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.orange, // Cor laranja do botão
                foregroundColor: Colors.black, // Contraste com o fundo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 5,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPage()),
                );
              },
              child: const Text(
                'Ir para a página de notícias',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
