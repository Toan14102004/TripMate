import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/features/settings/presentation/providers/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleNotification() {
    emit(state.copyWith(isNotificationEnabled: !state.isNotificationEnabled));
  }

  void toggleEmailNotification() {
    emit(state.copyWith(isEmailNotificationEnabled: !state.isEmailNotificationEnabled));
  }
}