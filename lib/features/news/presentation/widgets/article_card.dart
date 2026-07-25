import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/features/news/domain/entities/articale.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = article.imageUrl?.trim().isNotEmpty ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              CachedNetworkImage(
                imageUrl: article.imageUrl!,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, imageUrl) => const SizedBox(
                  height: 190,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, imageUrl, error) => const SizedBox(
                  height: 190,
                  child: Center(
                    child: Icon(Icons.broken_image_outlined, size: 50),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.sourceName,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM').format(
                          article.publishedAt.toLocal(),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (article.description?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      article.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
