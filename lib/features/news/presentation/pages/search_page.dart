import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../widgets/article_card.dart';
import '../widgets/news_loading.dart';
import '../widgets/offline_banner.dart';
import 'article_detailes_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    context.read<SearchBloc>().add(
          SearchSubmitted(_searchController.text),
        );
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(const SearchCleared());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _submitSearch(),
          decoration: const InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear',
            onPressed: _clearSearch,
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            tooltip: 'Search',
            onPressed: _submitSearch,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(child: Text('Enter a topic to search.'));
          }

          if (state is SearchLoading) {
            return const NewsLoading();
          }

          if (state is SearchLoaded) {
            return Column(
              children: [
                if (state.isFromCache)
                  OfflineBanner(cachedAt: state.cachedAt),
                Expanded(
                  child: ListView.builder(
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
              ],
            );
          }

          if (state is SearchEmpty) {
            return Center(
              child: Text('No results found for "${state.query}".'),
            );
          }

          if (state is SearchFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 55),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitSearch,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
