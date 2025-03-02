import 'package:bloc/bloc.dart';

import 'cmp_tabbar_event.dart';
import 'cmp_tabbar_state.dart';

class CMPTabbarBloc extends Bloc<CMPTabbarEvent, CMPTabbarState> {
  CMPTabbarBloc() : super(CMPHomeButtonTapped(0)) {
    on<CMPTabbarItemSelected>(_tabbarItemSelected);
  }

  void _tabbarItemSelected(CMPTabbarEvent event, Emitter<CMPTabbarState> emit) {
    int tabId = (event as CMPTabbarItemSelected).tabId;
    switch (tabId) {
      case 0:
        emit(CMPHomeButtonTapped(tabId));
        break;
      case 1:
        emit(CMProfileButtonTapped(tabId));
        break;
      case 2:
        emit(CMPSettingsButtonTapped(tabId));
        break;
    }
  }
}
