import '../entities/news_feed.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines {
  const GetTopHeadlines(this.repository);

  final NewsRepository repository;

  Future<NewsFeed> call({
    required NewsCategory category,
    bool forceRefresh = false,
  }) {
    return repository.getTopHeadlines(
      category: category,
      forceRefresh: forceRefresh,
    );
  }
}
