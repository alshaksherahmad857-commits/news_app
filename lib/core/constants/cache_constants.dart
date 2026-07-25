class CacheConstants {
  const CacheConstants._();

  static const String newsBoxName = 'news_cache';
  static const String headlinesPrefix = 'headlines_';
  static const String searchPrefix = 'search_';
  static const Duration cacheDuration = Duration(minutes: 15);
}