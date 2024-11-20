import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const Text(
                    'Créditos',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),


                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    indent: 50,
                    endIndent: 50,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Saber News',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    indent: 50,
                    endIndent: 50,
                  ),


                  const SizedBox(height: 20),
                  const Text(
                    'Desenvolvido por:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),


                  const Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.orange),
                        title: Text(
                          'Vithor Nelson',
                          style: TextStyle(color: Colors.white60, fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.orange),
                        title: Text(
                          'Pedro Henrique Araujo',
                          style: TextStyle(color: Colors.white60, fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.orange),
                        title: Text(
                          'Felipe Sequeira',
                          style: TextStyle(color: Colors.white60, fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.orange),
                        title: Text(
                          'Gabriel Toschi',
                          style: TextStyle(color: Colors.white60, fontSize: 18),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.orangeAccent,
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Voltar',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
