import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/features/news/domain/entities/articale.dart';

class ArticleDetailsPage extends StatelessWidget {
  const ArticleDetailsPage({
    super.key,
    required this.article,
  });

  final Article article;

  Future<void> _openFullArticle(BuildContext context) async {
    final uri = Uri.tryParse(article.url);

    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The article link is invalid.')),
      );
      return;
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the article.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = article.imageUrl?.trim().isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Article Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              CachedNetworkImage(
                imageUrl: article.imageUrl!,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                placeholder: (context, imageUrl) => const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, imageUrl, error) => const SizedBox(
                  height: 240,
                  child: Center(child: Icon(Icons.broken_image, size: 60)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.sourceName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormat('dd MMMM yyyy - HH:mm').format(
                      article.publishedAt.toLocal(),
                    ),
                  ),
                  if (article.author?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 6),
                    Text('Author: ${article.author}'),
                  ],
                  if (article.description?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 20),
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  if (article.content?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 16),
                    Text(
                      article.content!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openFullArticle(context),
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Read Full Article'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
