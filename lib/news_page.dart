import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'creditos.dart'; // Importe a página de créditos

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

        if (data['articles'] != null && data['articles'].isNotEmpty) {
          setState(() {
            articles = data['articles'];

            // Ordenar as notícias por data (mais recente primeiro)
            articles.sort((a, b) {
              final dateA =
                  DateTime.tryParse(a['publishedAt'] ?? '') ?? DateTime(0);
              final dateB =
                  DateTime.tryParse(b['publishedAt'] ?? '') ?? DateTime(0);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao abrir o artigo.')),
      );
    }
  }


  String getArticleSummary(Map article) {
    // Verifica se existe uma descrição disponível
    if (article['description'] != null && article['description'].isNotEmpty) {
      return article['description'];
    }

    // Caso não haja descrição, usa os primeiros 100 caracteres do título como resumo
    final title = article['title'] ?? 'Sem título';
    return title.length > 100 ? '${title.substring(0, 100)}...' : title;
  }

  // Função para navegar até a página de créditos
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
      appBar: AppBar(
        title: const Text('Notícias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => openCreditsPage(context), // Navegar para a página de créditos
            tooltip: 'Créditos',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchNews, // Atualização manual ao puxar para baixo
        child: articles.isEmpty
            ? const Center(child: Text('Nenhuma notícia encontrada'))
            : ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            final summary = getArticleSummary(article);
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
                          summary,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          article['publishedAt'] ??
                              'Data não disponível',
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
      ),
    );
  }
}
