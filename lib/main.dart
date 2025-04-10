import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/article.dart';
import 'package:news_app/news_service.dart';

Future<void> main() async{
  await dotenv.load(fileName: ".env");
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'New App',
      home: NewsHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsHome extends StatefulWidget{
  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  final _newsService = NewsService();
  final _searchController = TextEditingController();
  List<Article> _articles = [];
  String _search = '';

  void _getArticles() async {
    try {
      final result = await _newsService.fetchArticles(
          keyword: _search, max: 10);
      setState(() {
        _articles = result;
      });
    }
    catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('G_News'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Something...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _search = _searchController.text;
                    });
                    _getArticles();
                  },
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _articles.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: article.image.isNotEmpty
                        ? Image.network(
                        article.image, width: 80, fit: BoxFit.cover)
                        : null,
                    title: Text(article.title),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            AlertDialog(
                              title: Text(article.title),
                              content: Text(article.description),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('close'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
