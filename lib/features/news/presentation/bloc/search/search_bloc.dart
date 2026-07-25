import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/search_news.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.searchNews}) : super(const SearchInitial()) {
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchCleared>(_onSearchCleared);
  }

  final SearchNews searchNews;

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    emit(SearchLoading(query: query));

    try {
      final feed = await searchNews(query);

      if (feed.articles.isEmpty) {
        emit(SearchEmpty(query: query));
        return;
      }

      emit(
        SearchLoaded(
          articles: feed.articles,
          query: query,
          isFromCache: feed.isFromCache,
          cachedAt: feed.cachedAt,
        ),
      );
    } on Failure catch (failure) {
      emit(SearchFailure(message: failure.message));
    } catch (_) {
      emit(
        const SearchFailure(
          message: 'An unexpected error occurred.',
        ),
      );
    }
  }

  void _onSearchCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchInitial());
  }
}
