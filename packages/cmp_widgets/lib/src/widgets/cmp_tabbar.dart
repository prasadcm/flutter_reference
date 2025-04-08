import 'package:flutter/material.dart';

class CMPTabbarWidget extends StatelessWidget {
  const CMPTabbarWidget(
      {super.key, required this.onTabSelected, required this.selectedTabIndex});

  final ValueChanged<int> onTabSelected;
  final int selectedTabIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        selectedIndex: selectedTabIndex,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (index) {
          onTabSelected(index);
        });
  }
}
