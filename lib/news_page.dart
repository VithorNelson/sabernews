import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  List articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiKey = '2c2cd46e16014cee9d9c08cc3355f462';
    const url = 'https://newsapi.org/v2/everything?q=brasil&apiKey=$apiKey&language=pt';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['articles'] != null && data['articles'].isNotEmpty) {
          setState(() {
            articles = data['articles'];


            articles.sort((a, b) {
              final dateA = DateTime.tryParse(a['publishedAt'] ?? '') ?? DateTime(0);
              final dateB = DateTime.tryParse(b['publishedAt'] ?? '') ?? DateTime(0);
              return dateB.compareTo(dateA);
            });

            isLoading = false;
          });
        } else {
          print('Nenhuma notícia encontrada!');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Erro na API: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openArticle(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Não foi possível abrir o link: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notícias'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : articles.isEmpty
          ? const Center(child: Text('Nenhuma notícia encontrada'))
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article['urlToImage'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      article['urlToImage'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'] ?? 'Sem título',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        article['description'] ?? 'Descrição não disponível',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        article['publishedAt'] ?? 'Data não disponível',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final url = article['url'] ?? '';
                            if (url.isNotEmpty) {
                              openArticle(url);
                            } else {
                              print('URL não disponível');
                            }
                          },
                          icon: const Icon(Icons.open_in_browser),
                          label: const Text('Abrir Artigo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
    );
  }
}
