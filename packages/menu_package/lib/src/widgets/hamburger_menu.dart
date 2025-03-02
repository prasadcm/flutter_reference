import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../constants/menu_identifier.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final MenuIdentifier id;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        BlocProvider.of<MenuBloc>(context).add(MenuItemSelected(id));
        Navigator.pop(context);
      },
    );
  }
}

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child:
              Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        MenuItem(icon: Icons.home, title: "Home", id: MenuIdentifier.home),
        MenuItem(
            icon: Icons.person, title: "Profile", id: MenuIdentifier.profile),
        MenuItem(
            icon: Icons.settings,
            title: "Settings",
            id: MenuIdentifier.settings),
      ]),
    );
  }
}
