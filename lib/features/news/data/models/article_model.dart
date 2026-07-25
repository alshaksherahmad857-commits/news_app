import 'package:news_app/features/news/domain/entities/articale.dart';

class ArticleModel {
  const ArticleModel({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.sourceName,
    required this.author,
    required this.publishedAt,
  });

  final String title;
  final String? description;
  final String? content;
  final String url;
  final String? imageUrl;
  final String sourceName;
  final String? author;
  final DateTime publishedAt;

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final sourceValue = json['source'];
    final source = sourceValue is Map
        ? Map<String, dynamic>.from(sourceValue)
        : <String, dynamic>{};

    return ArticleModel(
      title: json['title'] as String? ?? 'Untitled article',
      description: json['description'] as String?,
      content: json['content'] as String?,
      url: json['url'] as String? ?? '',
      imageUrl: json['urlToImage'] as String?,
      sourceName: source['name'] as String? ?? 'Unknown source',
      author: json['author'] as String?,
      publishedAt: DateTime.tryParse(
            json['publishedAt'] as String? ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'urlToImage': imageUrl,
      'source': {'name': sourceName},
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  Article toEntity() {
    return Article(
      title: title,
      description: description,
      content: content,
      url: url,
      imageUrl: imageUrl,
      sourceName: sourceName,
      author: author,
      publishedAt: publishedAt,
    );
  }
}
