import 'package:flutter/material.dart';
import 'package:reference/features/categories/screens/category_screen.dart';
import 'package:reference/features/home/screens/home_screen.dart';
import 'package:reference/features/profile/widgets/profile_screen.dart';
import 'package:ui_components/ui_components.dart';

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
        const HomeScreen(),
        const CategoryScreen(),
        const ProfileScreen(),
      ][currentPageIndex],
    );
  }
}
