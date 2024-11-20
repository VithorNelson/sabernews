import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'article_webview.dart';
import 'creditos.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  List articles = [];
  bool isLoading = true;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    fetchNews();

    // Atualização automática a cada 5 minutos
    timer = Timer.periodic(const Duration(minutes: 5), (Timer t) {
      fetchNews();
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancela o Timer ao sair
    super.dispose();
  }

  Future<void> fetchNews() async {
    const apiKey = '2c2cd46e16014cee9d9c08cc3355f462';
    const url =
        'https://newsapi.org/v2/everything?q=brasil&apiKey=$apiKey&language=pt';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          articles = (data['articles'] ?? []).where((article) {
            return article['title'] != null && article['url'] != null;
          }).toList();

          // Ordena as notícias por data de publicação (mais recente primeiro)
          articles.sort((a, b) {
            final dateA = DateTime.tryParse(a['publishedAt'] ?? '') ?? DateTime(0);
            final dateB = DateTime.tryParse(b['publishedAt'] ?? '') ?? DateTime(0);
            return dateB.compareTo(dateA); // Ordenando de forma decrescente
          });

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void openArticle(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleWebView(url: url),
      ),
    );
  }

  void openCreditsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreditsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notícias',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: () => openCreditsPage(context),
            tooltip: 'Créditos',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.orange))
            : RefreshIndicator(
          onRefresh: fetchNews,
          child: Column(
            children: [
              const SizedBox(height: 80), // Espaço para o título e AppBar
              articles.isEmpty
                  ? const Center(
                child: Text(
                  'Nenhuma notícia encontrada.',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
                  : Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      color: Colors.white.withOpacity(0.1), // Cor com transparência
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 5, // Sombra para efeito de profundidade
                      shadowColor: Colors.black.withOpacity(0.4), // Sombra mais suave
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article['urlToImage'] != null)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.network(
                                article['urlToImage'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['title'] ?? 'Sem título',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white, // Texto branco
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article['description'] ?? 'Descrição não disponível',
                                  style: const TextStyle(
                                    color: Colors.white70, // Cor do texto mais suave
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () => openArticle(
                                        article['url'] ?? ''),
                                    icon: const Icon(Icons.open_in_browser),
                                    label: const Text('Abrir Artigo'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
