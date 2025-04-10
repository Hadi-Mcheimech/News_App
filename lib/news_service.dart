import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/article.dart';

class NewsService {
  final String url = 'https://gnews.io/api/v4';
  final String apiKey = dotenv.env['GNEWS_API_KEY'] ?? ''; // Fetch the API key from the .env file

  Future<List<Article>> fetchArticles({String keyword = '', int max = 10}) async {
    // Ensure the API key is valid
    if (apiKey.isEmpty) {
      throw Exception('API Key is missing!');
    }

    final link = '$url/search?q=$keyword&max=$max&token=$apiKey';
    print('Request URL: $link');  // For debugging

    final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final artiList = jsonData['articles'] as List;
      return artiList.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Error Loading Articles: ${response.statusCode}');
    }
  }
}
