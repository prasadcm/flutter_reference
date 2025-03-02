import 'package:equatable/equatable.dart';
import 'package:menu_package/src/constants/menu_identifier.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
}

class MenuItemSelected extends MenuEvent {
  final MenuIdentifier menuId;
  const MenuItemSelected(this.menuId);

  @override
  List<Object> get props => [menuId];
}
