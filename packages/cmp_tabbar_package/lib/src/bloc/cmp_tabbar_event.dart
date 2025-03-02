import 'package:equatable/equatable.dart';

abstract class CMPTabbarEvent extends Equatable {
  const CMPTabbarEvent();
}

class CMPTabbarItemSelected extends CMPTabbarEvent {
  final int tabId;
  const CMPTabbarItemSelected(this.tabId);

  @override
  List<Object> get props => [tabId];
}
