import 'dart:convert';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'package:http/http.dart' as http;





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: WelcomeScreen(),
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiKey = '2c2cd46e16014cee9d9c08cc3355f462';
    const url = 'https://newsapi.org/v2/everything?q=brasil&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Data received: $data');
      setState(() {
        articles = data['articles'];
      });
    } else {
      print('Erro: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notícias'),
      ),
      body: articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(articles[index]['title']),
          );
        },
      ),
    );
  }
}
