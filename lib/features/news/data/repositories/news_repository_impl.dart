import 'package:dio/dio.dart';

import '../../../../core/constants/cache_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import 'package:news_app/features/news/domain/entities/articale.dart';
import '../../domain/entities/news_feed.dart';
import '../../domain/repositories/news_repository.dart';
import 'package:news_app/features/news/data/datasource/news_local_data_source.dart';
import 'package:news_app/features/news/data/datasource/news_remote_data_source.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  @override
  Future<NewsFeed> getTopHeadlines({
    required NewsCategory category,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cachedNews = localDataSource.getCachedHeadlines(category.name);

      if (cachedNews != null &&
          cachedNews.articles.isNotEmpty &&
          _isCacheFresh(cachedNews.cachedAt)) {
        return NewsFeed(
          articles: _toEntities(cachedNews.articles),
          isFromCache: true,
          cachedAt: cachedNews.cachedAt,
        );
      }
    }

    try {
      final remoteModels = await remoteDataSource.getTopHeadlines(
        category: category,
      );

      await _cacheHeadlinesSafely(
        category: category.name,
        articles: remoteModels,
      );

      return NewsFeed(
        articles: _toEntities(remoteModels),
        isFromCache: false,
        cachedAt: null,
      );
    } catch (error) {
      final cachedNews = localDataSource.getCachedHeadlines(category.name);

      if (cachedNews != null && cachedNews.articles.isNotEmpty) {
        return NewsFeed(
          articles: _toEntities(cachedNews.articles),
          isFromCache: true,
          cachedAt: cachedNews.cachedAt,
        );
      }

      throw _mapRemoteError(error);
    }
  }

  @override
  Future<NewsFeed> searchNews({required String query}) async {
    try {
      final remoteModels = await remoteDataSource.searchNews(query: query);

      await _cacheSearchSafely(
        query: query,
        articles: remoteModels,
      );

      return NewsFeed(
        articles: _toEntities(remoteModels),
        isFromCache: false,
        cachedAt: null,
      );
    } catch (error) {
      final cachedNews = localDataSource.getCachedSearchResults(query);

      if (cachedNews != null && cachedNews.articles.isNotEmpty) {
        return NewsFeed(
          articles: _toEntities(cachedNews.articles),
          isFromCache: true,
          cachedAt: cachedNews.cachedAt,
        );
      }

      throw _mapRemoteError(error);
    }
  }

  bool _isCacheFresh(DateTime cachedAt) {
    return DateTime.now().difference(cachedAt) <
        CacheConstants.cacheDuration;
  }

  List<Article> _toEntities(List<ArticleModel> models) {
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  Future<void> _cacheHeadlinesSafely({
    required String category,
    required List<ArticleModel> articles,
  }) async {
    try {
      await localDataSource.cacheHeadlines(
        category: category,
        articles: articles,
      );
    } catch (_) {
      // A cache-writing failure must not hide fresh network data.
    }
  }

  Future<void> _cacheSearchSafely({
    required String query,
    required List<ArticleModel> articles,
  }) async {
    try {
      await localDataSource.cacheSearchResults(
        query: query,
        articles: articles,
      );
    } catch (_) {
      // A cache-writing failure must not hide fresh network data.
    }
  }

  Failure _mapRemoteError(Object error) {
    if (error is Failure) {
      return error;
    }

    if (error is ServerException) {
      return ServerFailure(error.message);
    }

    if (error is CacheException) {
      return CacheFailure(error.message);
    }

    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 401) {
        return const ServerFailure('The API key is invalid or missing.');
      }

      if (statusCode == 426) {
        return const ServerFailure(
          'This API plan does not allow this type of request.',
        );
      }

      if (statusCode == 429) {
        return const ServerFailure(
          'Too many requests. Please try again later.',
        );
      }

      if (statusCode != null && statusCode >= 500) {
        return const ServerFailure('The news server is unavailable.');
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return const NetworkFailure();
        default:
          return NetworkFailure(
            error.message ?? 'Unable to connect to the server.',
          );
      }
    }

    return const ServerFailure('An unexpected error occurred.');
  }
}
