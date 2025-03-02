import 'package:example/home_screen.dart';
import 'package:example/profile_screen.dart';
import 'package:example/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_package/menu_package.dart';

class AppRouter extends StatelessWidget {
  final Widget screen;

  const AppRouter({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuBloc, MenuState>(
      listener: (context, state) {
        if (state is HomeItemClicked) {
          context.go('/');
        } else if (state is ProfileItemClicked) {
          context.go('/profile');
        } else if (state is SettingsItemClicked) {
          context.go('/settings');
        }
      },
      builder: (context, state) {
        return screen;
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  final Widget child;
  final String screenTitle;

  const MainScreen({super.key, required this.child, this.screenTitle = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(screenTitle),
        ),
        drawer: HamburgerMenu(),
        body: child);
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => AppRouter(
            screen: MainScreen(screenTitle: 'Home', child: HomeScreen()))),
    GoRoute(
        path: '/settings',
        builder: (context, state) => AppRouter(
            screen:
                MainScreen(screenTitle: 'Settings', child: SettingsScreen()))),
    GoRoute(
        path: '/profile',
        builder: (context, state) => AppRouter(
            screen:
                MainScreen(screenTitle: 'Profile', child: ProfileScreen()))),
  ],
);

// Example Usage
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

void main() => runApp(
      BlocProvider(create: (context) => MenuBloc(), child: ExampleApp()),
    );
