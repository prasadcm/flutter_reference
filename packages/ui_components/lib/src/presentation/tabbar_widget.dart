import 'package:flutter/material.dart';

class TabbarWidget extends StatelessWidget {
  const TabbarWidget({
    required this.onTabSelected,
    required this.selectedTabIndex,
    super.key,
  });

  final ValueChanged<int> onTabSelected;
  final int selectedTabIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedTabIndex,
      indicatorColor: Colors.transparent,
      destinations: const [
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
      onDestinationSelected: onTabSelected,
    );
  }
}
