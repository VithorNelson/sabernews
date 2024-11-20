import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey.shade900], // Fundo em gradiente
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                const Text(
                  'Créditos',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange, // Destaque semelhante à tela inicial
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Nome do app
                const Text(
                  'Aplicativo de Notícias',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Texto introdutório
                const Text(
                  'Desenvolvido por:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                // Lista de desenvolvedores
                const Text(
                  '- Vithor Nelson\n- Pedro Henrique Araujo\n- Felipe Sequeira\n- Gabriel Toschi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Botão estilizado
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    backgroundColor: Colors.orange, // Cor laranja para combinar com o tema
                    foregroundColor: Colors.black, // Contraste do texto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Retorna à página anterior
                  },
                  child: const Text(
                    'Voltar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
