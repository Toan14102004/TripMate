// TODO: Settings 기능의 화면(Screen)을 구현하세요.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/features/choose_mode/presentation/bloc/theme_cubit.dart';
import 'package:trip_mate/features/root/presentation/screens/root_screen.dart';
import 'package:trip_mate/features/settings/presentation/providers/settings_bloc.dart';
import 'package:trip_mate/features/settings/presentation/providers/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isDark = context.isDarkMode;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: isDark ? const Color(0xFF1C1C1E) : Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 70.0,
                floating: true,
                pinned: false,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: !isDark ? Colors.white : Colors.black),
                  ),
                ),
                actions: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                           rootScaffoldKey.currentState?.openDrawer(); 
                        },
                        color: isDark ? Colors.white : Colors.black,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSettingSection(
                            context,
                            children: [
                              _buildSwitchTile(
                                context,
                                title: 'Notification',
                                icon: Icons.notifications,
                                value: state.isNotificationEnabled,
                                onChanged: (value) =>
                                    context.read<SettingsCubit>().toggleNotification(),
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildDarkModeTile(context, isDark: isDark),
                              _buildDivider(isDark),
                              _buildSwitchTile(
                                context,
                                title: 'Email Notification',
                                icon: Icons.email,
                                value: state.isEmailNotificationEnabled,
                                onChanged: (value) =>
                                    context.read<SettingsCubit>().toggleEmailNotification(),
                                isDark: isDark,
                              ),
                            ],
                            isDark: isDark,
                          ),
                          const SizedBox(height: 32),
                          _buildSettingSection(
                            context,
                            children: [
                              _buildNavigationTile(
                                context,
                                title: 'About App',
                                icon: Icons.info,
                                onTap: () => _showAboutDialog(context),
                                isDark: isDark,
                              ),
                              _buildDivider(isDark),
                              _buildNavigationTile(
                                context,
                                title: 'Share App',
                                icon: Icons.share,
                                onTap: () => _showShareDialog(context),
                                isDark: isDark,
                              ),
                            ],
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  //                           WIDGET HỖ TRỢ CHO SETTINGS
  // -------------------------------------------------------------------------

  Widget _buildSettingSection(
    BuildContext context, {
    required List<Widget> children,
    required bool isDark,
  }) {
    final Color containerColor =
        isDark ? const Color(0xFF2C2C2E) : Colors.white;
    List<BoxShadow> shadows = [];

    if (!isDark) {
      // Đổ bóng nhẹ khi ở chế độ sáng
      shadows.add(
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadows,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
      BuildContext context, {
      required String title,
      required IconData icon,
      required bool value,
      required Function(bool) onChanged,
      required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Icon màu xám nhẹ
          Icon(icon, color: isDark ? Colors.blueGrey[300] : Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF007AFF),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(
      BuildContext context, {
      required String title,
      required IconData icon,
      required VoidCallback onTap,
      required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      // Hiệu ứng highlight khi chạm
      highlightColor: isDark ? Colors.white10 : Colors.grey[200],
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Icon màu xám nhẹ
            Icon(icon, color: isDark ? Colors.blueGrey[300] : Colors.blueGrey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeTile(BuildContext context, {required bool isDark}) {
    final themeCubit = context.read<ThemeCubit>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // AnimatedSwitcher cho hiệu ứng chuyển đổi icon
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isDark ? Icons.brightness_3 : Icons.wb_sunny,
              key: ValueKey<bool>(isDark),
              color: isDark ? Colors.yellow : Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Switch.adaptive(
            value: isDark,
            onChanged: (value) =>
                themeCubit.updateTheme(value ? ThemeMode.dark : ThemeMode.light),
            activeColor: const Color(0xFF007AFF),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: isDark ? Colors.grey[700] : Colors.grey[300],
      indent: 16,
      endIndent: 16,
    );
  }
  
  // -------------------------------------------------------------------------
  //                           HÀM HIỂN THỊ DIALOG
  // -------------------------------------------------------------------------
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About App'),
            content: const Text(
              'This is a demo settings app built with Flutter and Cubit.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Share App'),
            content: const Text('Share this amazing app with your friends!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App shared successfully!')),
                  );
                },
                child: const Text('Share'),
              ),
            ],
          ),
    );
  }
}