import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/enum/page_enum.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/features/choose_mode/presentation/bloc/theme_cubit.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';
import 'package:trip_mate/features/root/presentation/providers/page_bloc.dart';
import 'package:trip_mate/features/root/presentation/screens/root_screen.dart';

final List<Map<String, dynamic>> _quickActions = [
  {'label': 'Settings', 'icon': Icons.settings_outlined, 'color': Colors.blue},
  {'label': 'My Trips', 'icon': Icons.map, 'color': Colors.green},
  {
    'label': 'Saved Places',
    'icon': Icons.bookmark_outline,
    'color': Colors.red,
  },
  {
    'label': 'My Wallet',
    'icon': Icons.account_balance_wallet_outlined,
    'color': Colors.orange,
  },
  {'label': 'Privacy', 'icon': Icons.security_rounded, 'color': Colors.indigo},
  {'label': 'Help', 'icon': Icons.help_outline, 'color': Colors.purple},
  {'label': 'Logout', 'icon': Icons.logout_rounded, 'color': Colors.teal},
];

/// Chức năng hiển thị Dialog hành động nhanh.
void showQuickActionsDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) {
      return Stack(
        children: [
          // Invisible barrier to close dialog
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          // Dialog positioned at right side
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.1,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 400),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.topRight,
                  child: Transform.translate(
                    offset: Offset(50 * (1 - value), 0),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  ),
                );
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color:
                        context.isDarkMode
                            ? const Color(0xFF2E2E3E)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(5, 8),
                      ),
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color:
                          context.isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[200]!,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(context),
                        Divider(
                          height: 0,
                          color:
                              context.isDarkMode
                                  ? Colors.grey[700]!.withOpacity(0.5)
                                  : Colors.grey[200]!,
                          thickness: 0.8,
                        ),
                        ..._quickActions.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> action = entry.value;
                          bool isLast = index == _quickActions.length - 1;

                          return _buildActionItem(
                            context,
                            action,
                            isLast,
                            context.isDarkMode,
                          );
                        }).toList(),
                        Divider(
                          height: 0,
                          color:
                              context.isDarkMode
                                  ? Colors.grey[700]!.withOpacity(0.5)
                                  : Colors.grey[200]!,
                          thickness: 0.8,
                        ),
                        _buildThemeSwitchRow(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// ---
// ## Components
// ---

Widget _buildHeader(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.orange.shade400, Colors.blue.shade400],
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.apps_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Widget _buildThemeSwitchRow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
          ),
          child: Icon(
            // Hiển thị icon tương ứng với chế độ đang được bật
            context.isDarkMode
                ? Icons.nights_stay_rounded
                : Icons.wb_sunny_rounded,
            color: Colors.purple,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            !context.isDarkMode ? 'Light' : 'Dark',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Switch.adaptive(
          value: context.isDarkMode,
          onChanged: (value) {
            context.read<ThemeCubit>().updateTheme(
              !context.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            );
            HapticFeedback.lightImpact();
          },
          activeColor: Colors.purple,
          inactiveThumbColor: Colors.grey[500],
          inactiveTrackColor: Colors.grey[300]!.withOpacity(0.5),
        ),
      ],
    ),
  );
}

Widget _buildActionItem(
  BuildContext context,
  Map<String, dynamic> action,
  bool isLast,
  bool isDarkMode,
) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
      HapticFeedback.selectionClick();
      _handleQuickAction(action['label'], context);
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            isLast
                ? null
                : Border(
                  bottom: BorderSide(
                    color:
                        context.isDarkMode
                            ? Colors.grey[700]!.withOpacity(0.5)
                            : Colors.grey[200]!,
                    width: 0.8,
                  ),
                ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: action['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: action['color'].withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(action['icon'], color: action['color'], size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              action['label'],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: context.isDarkMode ? Colors.grey[500] : Colors.grey[400],
          ),
        ],
      ),
    ),
  );
}

void _handleQuickAction(String action, BuildContext context) {
  switch (action) {
    case 'Settings':
      Navigator.of(context).pop();
      rootScaffoldKey.currentState?.closeDrawer();
      context.read<PageCubit>().changePage(index: PageEnum.settings.index);
      break;
    case 'Help':
      _showHelpDialog(context);
      break;
    case 'Share':
      print('Share Profile');
      break;
    case 'Saved Places':
      Navigator.of(context).pop();
      rootScaffoldKey.currentState?.closeDrawer();
      context.read<PageCubit>().changePage(index: PageEnum.saved.index);
      break;
    case 'My Wallet':
      logDebug('Navigate to My Wallet');
      break;
    case 'My Trips':
      Navigator.of(context).pop();
      rootScaffoldKey.currentState?.closeDrawer();
      context.read<PageCubit>().changePage(index: PageEnum.myTrip.index);
      break;
    case 'Logout':
      _showLogoutDialog(context);
      break;
    case 'Privacy':
      logDebug('Navigate to Privacy Settings');
      break;
  }
}

void _showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor:
              context.isDarkMode ? const Color(0xFF2E2E3E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Help & Support',
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'Need assistance? Contact our support team or check our FAQ section for common questions.',
            style: TextStyle(
              color: context.isDarkMode ? Colors.grey[300] : Colors.grey[600],
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor:
              context.isDarkMode ? const Color(0xFF2E2E3E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(
              color: context.isDarkMode ? Colors.grey[300] : Colors.grey[600],
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color:
                      context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ProfileCubit>().logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
  );
}
