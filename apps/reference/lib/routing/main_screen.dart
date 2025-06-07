import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_components/ui_components.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({required this.child, super.key});

  final Widget child;

  static final List<String> _tabs = ['/home', '/category', '/profile'];

  int _locationToTabIndex(String location) {
    return _tabs.indexWhere((path) => location.startsWith(path));
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToTabIndex(currentLocation);

    return Scaffold(
      bottomNavigationBar: TabbarWidget(
        selectedTabIndex: currentIndex,
        onTabSelected: (index) {
          if (index != currentIndex) {
            context.go(_tabs[index]);
          }
        },
      ),
      body: SafeArea(child: child),
    );
  }
}
