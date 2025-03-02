import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuCollapsed extends MenuState {}

class HomeItemClicked extends MenuState {}

class ProfileItemClicked extends MenuState {}

class SettingsItemClicked extends MenuState {}
