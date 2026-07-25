import 'package:equatable/equatable.dart';

import '../../../domain/entities/news_feed.dart';

sealed class HeadlinesEvent extends Equatable {
  const HeadlinesEvent();

  @override
  List<Object?> get props => [];
}

final class HeadlinesRequested extends HeadlinesEvent {
  const HeadlinesRequested(this.category);

  final NewsCategory category;

  @override
  List<Object?> get props => [category];
}

final class HeadlinesRefreshed extends HeadlinesEvent {
  const HeadlinesRefreshed(this.category);

  final NewsCategory category;

  @override
  List<Object?> get props => [category];
}
