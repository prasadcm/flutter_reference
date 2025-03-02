import 'package:bloc/bloc.dart';
import 'package:menu_package/src/bloc/menu_event.dart';
import 'package:menu_package/src/bloc/menu_state.dart';

import '../constants/menu_identifier.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuCollapsed()) {
    on<MenuItemSelected>(_menuItemSelected);
  }

  void _menuItemSelected(MenuEvent event, Emitter<MenuState> emit) {
    switch ((event as MenuItemSelected).menuId) {
      case MenuIdentifier.home:
        emit(HomeItemClicked());
        break;
      case MenuIdentifier.profile:
        emit(ProfileItemClicked());
        break;
      case MenuIdentifier.settings:
        emit(SettingsItemClicked());
        break;
    }
  }
}
