import '../../../../core/error/failures.dart';
import '../entities/news_feed.dart';
import '../repositories/news_repository.dart';

class SearchNews {
  const SearchNews(this.repository);

  final NewsRepository repository;

  Future<NewsFeed> call(String query) {
    final cleanedQuery = query.trim();

    if (cleanedQuery.length < 2) {
      throw const ValidationFailure('Enter at least two characters.');
    }

    return repository.searchNews(query: cleanedQuery);
  }
}
