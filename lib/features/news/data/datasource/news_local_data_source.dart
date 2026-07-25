import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';

import '../../../../core/constants/cache_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/article_model.dart';

class CachedNewsModel {
  const CachedNewsModel({
    required this.articles,
    required this.cachedAt,
  });

  final List<ArticleModel> articles;
  final DateTime cachedAt;
}

abstract interface class NewsLocalDataSource {
  Future<void> cacheHeadlines({
    required String category,
    required List<ArticleModel> articles,
  });

  CachedNewsModel? getCachedHeadlines(String category);

  Future<void> cacheSearchResults({
    required String query,
    required List<ArticleModel> articles,
  });

  CachedNewsModel? getCachedSearchResults(String query);

  Future<void> clearCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  const NewsLocalDataSourceImpl({required this.box});

  final Box<String> box;

  @override
  Future<void> cacheHeadlines({
    required String category,
    required List<ArticleModel> articles,
  }) {
    return _writeCache(
      key: '${CacheConstants.headlinesPrefix}$category',
      articles: articles,
    );
  }

  @override
  CachedNewsModel? getCachedHeadlines(String category) {
    return _readCache('${CacheConstants.headlinesPrefix}$category');
  }

  @override
  Future<void> cacheSearchResults({
    required String query,
    required List<ArticleModel> articles,
  }) {
    return _writeCache(
      key: _searchKey(query),
      articles: articles,
    );
  }

  @override
  CachedNewsModel? getCachedSearchResults(String query) {
    return _readCache(_searchKey(query));
  }

  Future<void> _writeCache({
    required String key,
    required List<ArticleModel> articles,
  }) async {
    final value = <String, dynamic>{
      'cachedAt': DateTime.now().toIso8601String(),
      'articles': articles.map((article) => article.toJson()).toList(),
    };

    try {
      await box.put(key, jsonEncode(value));
    } catch (error) {
      throw CacheException('Unable to save cached news: $error');
    }
  }

  CachedNewsModel? _readCache(String key) {
    final value = box.get(key);
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      final decodedValue = jsonDecode(value);
      if (decodedValue is! Map) {
        return null;
      }

      final decoded = Map<String, dynamic>.from(decodedValue);
      final rawArticles = decoded['articles'];
      if (rawArticles is! List) {
        return null;
      }

      final cachedAt = DateTime.tryParse(
        decoded['cachedAt'] as String? ?? '',
      );
      if (cachedAt == null) {
        return null;
      }

      final articles = rawArticles
          .whereType<Map>()
          .map(
            (item) => ArticleModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false);

      return CachedNewsModel(
        articles: articles,
        cachedAt: cachedAt,
      );
    } catch (_) {
      return null;
    }
  }

  String _searchKey(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    final encodedQuery = base64Url
        .encode(utf8.encode(normalizedQuery))
        .replaceAll('=', '');

    return '${CacheConstants.searchPrefix}$encodedQuery';
  }

  @override
  Future<void> clearCache() => box.clear();
}
