import 'package:equatable/equatable.dart';

class Article extends Equatable {
  const Article({
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

  @override
  List<Object?> get props => [
        title,
        description,
        content,
        url,
        imageUrl,
        sourceName,
        author,
        publishedAt,
      ];
}
