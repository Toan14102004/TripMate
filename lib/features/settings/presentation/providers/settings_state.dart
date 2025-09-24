class SettingsState {
  final bool isNotificationEnabled;
  final bool isEmailNotificationEnabled;

  const SettingsState({
    this.isNotificationEnabled = true,
    this.isEmailNotificationEnabled = false,
  });

  SettingsState copyWith({
    bool? isNotificationEnabled,
    bool? isEmailNotificationEnabled,
  }) {
    return SettingsState(
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      isEmailNotificationEnabled: isEmailNotificationEnabled ?? this.isEmailNotificationEnabled,
    );
  }
}