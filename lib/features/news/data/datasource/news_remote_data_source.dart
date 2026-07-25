import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/news_feed.dart';
import '../models/article_model.dart';

abstract interface class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    required NewsCategory category,
  });

  Future<List<ArticleModel>> searchNews({
    required String query,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  const NewsRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<ArticleModel>> getTopHeadlines({
    required NewsCategory category,
  }) {
    return _requestArticles(
      endpoint: ApiConstants.topHeadlines,
      queryParameters: {
        'country': ApiConstants.country,
        'category': category.name,
        'pageSize': ApiConstants.pageSize,
        'page': 1,
      },
    );
  }

  @override
  Future<List<ArticleModel>> searchNews({
    required String query,
  }) {
    return _requestArticles(
      endpoint: ApiConstants.everything,
      queryParameters: {
        'q': query,
        'language': 'en',
        'sortBy': 'publishedAt',
        'pageSize': ApiConstants.pageSize,
        'page': 1,
      },
    );
  }

  Future<List<ArticleModel>> _requestArticles({
    required String endpoint,
    required Map<String, dynamic> queryParameters,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: queryParameters,
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException(
        message: 'The server returned empty data.',
      );
    }

    final status = data['status'] as String? ?? '';
    if (status != 'ok') {
      throw ServerException(
        message: data['message'] as String? ?? 'Unable to load news.',
        statusCode: response.statusCode,
      );
    }

    final rawArticles = data['articles'];
    if (rawArticles is! List) {
      throw const ServerException(
        message: 'The articles format is invalid.',
      );
    }

    return rawArticles
        .whereType<Map>()
        .map(
          (item) => ArticleModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where(
          (article) =>
              article.url.isNotEmpty &&
              article.title.isNotEmpty &&
              article.title != '[Removed]',
        )
        .toList(growable: false);
  }
}
