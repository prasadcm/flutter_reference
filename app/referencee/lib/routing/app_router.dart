import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainScreen()),
    GoRoute(path: '/xxx', builder: (context, state) => Center()),
    GoRoute(path: '/yyy', builder: (context, state) => Center()),
  ],
);
