import 'package:flutter/material.dart';

class NewsLoading extends StatelessWidget {
  const NewsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const SizedBox(
            height: 190,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
