import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'core/constants/cache_constants.dart';
import 'core/dependency_injection/injection_container.dart';
import 'features/news/presentation/bloc/headlines/headlines_bloc.dart';
import 'features/news/presentation/bloc/search/search_bloc.dart';
import 'features/news/presentation/pages/news_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final newsBox = await Hive.openBox<String>(CacheConstants.newsBoxName);

  await configureDependencies(newsBox);

  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HeadlinesBloc>(
          create: (_) => sl<HeadlinesBloc>(),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => sl<SearchBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const NewsPage(),
      ),
    );
  }
}
