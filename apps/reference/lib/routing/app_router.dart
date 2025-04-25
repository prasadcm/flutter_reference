import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reference/features/search/screens/search_screen.dart';

import 'main_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainScreen()),
    GoRoute(path: '/xxx', builder: (context, state) => Center()),
    GoRoute(path: '/search', builder: (context, state) => SearchScreen()),
  ],
);
