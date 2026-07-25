import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import'package:news_app/features/news/domain/entities/articale.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

final class SearchInitial extends SearchState {
  const SearchInitial();
}

final class SearchLoading extends SearchState {
  const SearchLoading({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

final class SearchLoaded extends SearchState {
  const SearchLoaded({
    required this.articles,
    required this.query,
    required this.isFromCache,
    required this.cachedAt,
  });

  final List<Article> articles;
  final String query;
  final bool isFromCache;
  final DateTime? cachedAt;

  @override
  List<Object?> get props => [articles, query, isFromCache, cachedAt];
}

final class SearchEmpty extends SearchState {
  const SearchEmpty({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

final class SearchFailure extends SearchState {
  const SearchFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
