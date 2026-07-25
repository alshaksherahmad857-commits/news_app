import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/news_feed.dart';
import '../bloc/headlines/headlines_bloc.dart';
import '../bloc/headlines/headlines_event.dart';
import '../bloc/headlines/headlines_state.dart';
import '../widgets/article_card.dart';
import '../widgets/category_selector.dart';
import '../widgets/news_loading.dart';
import '../widgets/offline_banner.dart';
import 'article_detailes_page.dart';
import 'search_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  NewsCategory _selectedCategory = NewsCategory.general;

  @override
  void initState() {
    super.initState();
    context.read<HeadlinesBloc>().add(
          HeadlinesRequested(_selectedCategory),
        );
  }

  void _selectCategory(NewsCategory category) {
    if (category == _selectedCategory) {
      return;
    }

    setState(() => _selectedCategory = category);
    context.read<HeadlinesBloc>().add(HeadlinesRequested(category));
  }

  Future<void> _refresh() async {
    final bloc = context.read<HeadlinesBloc>();
    final completed = bloc.stream.firstWhere(
      (state) =>
          state is HeadlinesLoaded ||
          state is HeadlinesEmpty ||
          state is HeadlinesFailure,
    );

    bloc.add(HeadlinesRefreshed(_selectedCategory));
    await completed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily News'),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          CategorySelector(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          Expanded(
            child: BlocBuilder<HeadlinesBloc, HeadlinesState>(
              builder: (context, state) {
                if (state is HeadlinesInitial || state is HeadlinesLoading) {
                  return const NewsLoading();
                }

                if (state is HeadlinesLoaded) {
                  return Column(
                    children: [
                      if (state.isFromCache)
                        OfflineBanner(cachedAt: state.cachedAt),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.articles.length,
                            itemBuilder: (context, index) {
                              final article = state.articles[index];

                              return ArticleCard(
                                article: article,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ArticleDetailsPage(
                                        article: article,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is HeadlinesEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 180),
                        Icon(Icons.article_outlined, size: 60),
                        SizedBox(height: 12),
                        Center(child: Text('No articles found.')),
                      ],
                    ),
                  );
                }

                if (state is HeadlinesFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_outlined, size: 60),
                          const SizedBox(height: 12),
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<HeadlinesBloc>().add(
                                    HeadlinesRefreshed(_selectedCategory),
                                  );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
