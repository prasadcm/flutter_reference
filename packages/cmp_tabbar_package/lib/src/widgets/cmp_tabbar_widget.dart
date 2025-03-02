import 'package:cmp_tabbar_package/cmp_tabbar_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CMPTabbarWidget extends StatelessWidget {
  const CMPTabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CMPTabbarBloc, CMPTabbarState>(
      builder: (context, state) {
        return NavigationBar(
            selectedIndex: state.selectedIndex,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onDestinationSelected: (index) {
              BlocProvider.of<CMPTabbarBloc>(context)
                  .add(CMPTabbarItemSelected(index));
            });
      },
    );
  }
}
