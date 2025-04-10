class Article{
  final String title;
  final String description;
  final String content;
  final String url;
  final String image;
  final String publishedAt;
  final String sourceName;
  final String author;


  //Create Constructor for Article
  Article({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.sourceName,
    required this.author,
});

  //Create Article by json
  factory Article.fromJson(Map<String, dynamic> json){
    return Article(
      title:  json['title'] ?? '',
      description: json['description'] ?? '',
      content:  json['content'] ?? '',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      publishedAt:  json['publishedAt'] ?? '',
      sourceName: json['source']['name'] ?? '',
      author: json['author'] ?? '',
    );
  }
}