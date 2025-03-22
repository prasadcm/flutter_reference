import 'package:cmp_widgets/cmp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:referencee/features/home/screens/home_screen.dart';
import 'package:referencee/features/profile/widgets/profile_screen.dart';
import 'package:referencee/features/settings/widgets/settings_screen.dart';

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
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        bottomNavigationBar: CMPTabbarWidget(
          selectedTabIndex: currentPageIndex,
          onTabSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        body: [
          HomeScreen(),
          SettingsScreen(),
          ProfileScreen()
        ][currentPageIndex]);
  }
}
