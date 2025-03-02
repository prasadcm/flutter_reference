import 'package:equatable/equatable.dart';

abstract class CMPTabbarState extends Equatable {
  final int selectedIndex;
  const CMPTabbarState(this.selectedIndex);

  @override
  List<Object> get props => [];
}

class CMPHomeButtonTapped extends CMPTabbarState {
  const CMPHomeButtonTapped(super.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

class CMProfileButtonTapped extends CMPTabbarState {
  const CMProfileButtonTapped(super.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

class CMPSettingsButtonTapped extends CMPTabbarState {
  const CMPSettingsButtonTapped(super.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
