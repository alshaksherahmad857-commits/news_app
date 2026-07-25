import '../entities/news_feed.dart';

abstract interface class NewsRepository {
  Future<NewsFeed> getTopHeadlines({
    required NewsCategory category,
    bool forceRefresh = false,
  });

  Future<NewsFeed> searchNews({
    required String query,
  });
}
