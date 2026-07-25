import 'package:equatable/equatable.dart';

import 'articale.dart';
enum NewsCategory {
  general,
  business,
  entertainment,
  health,
  science,
  sports,
  technology,
}

extension NewsCategoryExtension on NewsCategory {
  String get displayName {
    switch (this) {
      case NewsCategory.general:
        return 'General';
      case NewsCategory.business:
        return 'Business';
      case NewsCategory.entertainment:
        return 'Entertainment';
      case NewsCategory.health:
        return 'Health';
      case NewsCategory.science:
        return 'Science';
      case NewsCategory.sports:
        return 'Sports';
      case NewsCategory.technology:
        return 'Technology';
    }
  }
}

class NewsFeed extends Equatable {
  const NewsFeed({
    required this.articles,
    required this.isFromCache,
    required this.cachedAt,
  });

  final List<Article> articles;
  final bool isFromCache;
  final DateTime? cachedAt;

  @override
  List<Object?> get props => [articles, isFromCache, cachedAt];
}
