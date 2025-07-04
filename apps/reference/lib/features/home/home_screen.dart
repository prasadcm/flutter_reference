import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:search_recommendation/search_recommendation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SearchRecommendationView(
        onTap: () => context.push('/search'),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Center(
        child: Text(
          'Home',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Adjust size if needed
          ),
        ),
      ),
    );
  }
}
