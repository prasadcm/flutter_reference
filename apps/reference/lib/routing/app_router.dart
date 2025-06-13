import 'package:categories/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:previously_searched/previously_searched.dart';
import 'package:reference/features/categories/screens/category_screen.dart';
import 'package:reference/features/home/home_screen.dart';
import 'package:reference/features/profile/widgets/profile_screen.dart';
import 'package:reference/features/search/screens/search_screen.dart';
import 'package:reference/routing/main_screen.dart';
import 'package:search_recommendation/search_recommendation.dart';
import 'package:search_suggestion/search_suggestion.dart';

class AppRouter {
  static late final GoRouter router;

  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser =>
      router.routeInformationParser;

  static final routes = [
    ShellRoute(
      pageBuilder: (context, state, child) =>
          _fadePage(state, MainScreen(child: child)),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _fadePage(
            state,
            MultiBlocProvider(
              providers: [
                BlocProvider<SearchRecommendationBloc>(
                  create: (context) =>
                      recommendationLocator<SearchRecommendationBloc>(),
                ),
              ],
              child: const HomeScreen(),
            ),
          ),
        ),
        GoRoute(
          path: '/category',
          pageBuilder: (context, state) => _fadePage(
            state,
            BlocProvider<CategoriesBloc>(
              create: (context) => categoryLocator<CategoriesBloc>(),
              child: const CategoryScreen(),
            ),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              _fadePage(state, const ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<SearchSuggestionBloc>(
              create: (context) =>
                  searchSuggestionLocator<SearchSuggestionBloc>(),
            ),
            BlocProvider<PreviouslySearchedBloc>(
              create: (context) =>
                  previouslySearchedLocator<PreviouslySearchedBloc>(),
            ),
          ],
          child: const SearchScreen(),
        );
      },
    ),
  ];

  static void setup() {
    router = GoRouter(
      initialLocation: '/home',
      routes: routes,
    );
  }

  static CustomTransitionPage<dynamic> _fadePage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
