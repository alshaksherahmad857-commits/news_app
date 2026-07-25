import 'package:equatable/equatable.dart';
import 'package:news_app/features/news/domain/entities/articale.dart';
import '../../../domain/entities/news_feed.dart';

sealed class HeadlinesState extends Equatable {
  const HeadlinesState();

  @override
  List<Object?> get props => [];
}

final class HeadlinesInitial extends HeadlinesState {
  const HeadlinesInitial();
}

final class HeadlinesLoading extends HeadlinesState {
  const HeadlinesLoading({required this.category});

  final NewsCategory category;

  @override
  List<Object?> get props => [category];
}

final class HeadlinesLoaded extends HeadlinesState {
  const HeadlinesLoaded({
    required this.articles,
    required this.category,
    required this.isFromCache,
    required this.cachedAt,
  });

  final List<Article> articles;
  final NewsCategory category;
  final bool isFromCache;
  final DateTime? cachedAt;

  @override
  List<Object?> get props => [articles, category, isFromCache, cachedAt];
}

final class HeadlinesEmpty extends HeadlinesState {
  const HeadlinesEmpty({required this.category});

  final NewsCategory category;

  @override
  List<Object?> get props => [category];
}

final class HeadlinesFailure extends HeadlinesState {
  const HeadlinesFailure({
    required this.message,
    required this.category,
  });

  final String message;
  final NewsCategory category;

  @override
  List<Object?> get props => [message, category];
}
