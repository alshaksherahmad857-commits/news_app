import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/news_feed.dart';
import 'package:news_app/features/news/domain/usecases/get_top_handlines.dart';
import 'headlines_event.dart';
import 'headlines_state.dart';

class HeadlinesBloc extends Bloc<HeadlinesEvent, HeadlinesState> {
  HeadlinesBloc({required this.getTopHeadlines})
      : super(const HeadlinesInitial()) {
    on<HeadlinesRequested>(_onHeadlinesRequested);
    on<HeadlinesRefreshed>(_onHeadlinesRefreshed);
  }

  final GetTopHeadlines getTopHeadlines;

  Future<void> _onHeadlinesRequested(
    HeadlinesRequested event,
    Emitter<HeadlinesState> emit,
  ) {
    return _loadHeadlines(
      category: event.category,
      forceRefresh: false,
      emit: emit,
    );
  }

  Future<void> _onHeadlinesRefreshed(
    HeadlinesRefreshed event,
    Emitter<HeadlinesState> emit,
  ) {
    return _loadHeadlines(
      category: event.category,
      forceRefresh: true,
      emit: emit,
    );
  }

  Future<void> _loadHeadlines({
    required NewsCategory category,
    required bool forceRefresh,
    required Emitter<HeadlinesState> emit,
  }) async {
    emit(HeadlinesLoading(category: category));

    try {
      final feed = await getTopHeadlines(
        category: category,
        forceRefresh: forceRefresh,
      );

      if (feed.articles.isEmpty) {
        emit(HeadlinesEmpty(category: category));
        return;
      }

      emit(
        HeadlinesLoaded(
          articles: feed.articles,
          category: category,
          isFromCache: feed.isFromCache,
          cachedAt: feed.cachedAt,
        ),
      );
    } on Failure catch (failure) {
      emit(
        HeadlinesFailure(
          message: failure.message,
          category: category,
        ),
      );
    } catch (_) {
      emit(
        HeadlinesFailure(
          message: 'An unexpected error occurred.',
          category: category,
        ),
      );
    }
  }
}
