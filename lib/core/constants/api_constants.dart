class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://newsapi.org/v2';
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  static const String country = 'us';
  static const int pageSize = 20;

  static const String apiKey = String.fromEnvironment('NEWS_API_KEY');
}
