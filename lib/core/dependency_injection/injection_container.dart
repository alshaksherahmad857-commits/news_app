import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive_ce.dart';

import 'package:news_app/core/network/dio_client.dart';
import 'package:news_app/features/news/data/datasource/news_local_data_source.dart';
import 'package:news_app/features/news/data/datasource/news_remote_data_source.dart';
import 'package:news_app/features/news/data/repositories/news_repository_impl.dart';

import 'package:news_app/features/news/domain/repositories/news_repository.dart';
import 'package:news_app/features/news/domain/usecases/get_top_handlines.dart';
import 'package:news_app/features/news/domain/usecases/search_news.dart';

import 'package:news_app/features/news/presentation/bloc/headlines/headlines_bloc.dart';
import 'package:news_app/features/news/presentation/bloc/search/search_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies(Box<String> newsBox) async {
  // Hive Box
  sl.registerSingleton<Box<String>>(newsBox);

  // Network
  sl.registerLazySingleton<Dio>(
    () => DioClient().dio,
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(
      dio: sl<Dio>(),
    ),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(
      box: sl<Box<String>>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl<NewsRemoteDataSource>(),
      localDataSource: sl<NewsLocalDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetTopHeadlines>(
    () => GetTopHeadlines(
      sl<NewsRepository>(),
    ),
  );

  sl.registerLazySingleton<SearchNews>(
    () => SearchNews(
      sl<NewsRepository>(),
    ),
  );

  // Blocs
  sl.registerFactory<HeadlinesBloc>(
    () => HeadlinesBloc(
      getTopHeadlines: sl<GetTopHeadlines>(),
    ),
  );

  sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      searchNews: sl<SearchNews>(),
    ),
  );
}