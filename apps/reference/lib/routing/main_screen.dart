import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

import '../features/categories/screens/category_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/profile/widgets/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: TabbarWidget(
          selectedTabIndex: currentPageIndex,
          onTabSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        body: [
          HomeScreen(),
          CategoryScreen(),
          ProfileScreen()
        ][currentPageIndex]);
  }
}
