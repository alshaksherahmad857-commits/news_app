import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    super.key,
    required this.cachedAt,
  });

  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context) {
    final message = cachedAt == null
        ? 'Offline mode — showing saved news'
        : 'Saved news — last updated '
            '${DateFormat('dd/MM/yyyy HH:mm').format(cachedAt!.toLocal())}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(message, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
