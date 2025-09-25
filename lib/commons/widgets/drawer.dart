import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCustomDrawer(BuildContext context, {required bool isDark}) {
    // Màu xanh chủ đạo từ hình ảnh
    const Color primaryBlue = Color(0xFF007AFF);

    return Drawer(
      backgroundColor: primaryBlue,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header: Thông tin người dùng
          const UserAccountsDrawerHeader(
            accountName: Text("Jonathan Smith", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text("jonathansmith@gmail.com", style: TextStyle(fontSize: 14)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: primaryBlue),
            ),
            decoration: BoxDecoration(
              color: primaryBlue,
            ),
            margin: EdgeInsets.zero,
          ),
          
          // Các mục trong Drawer
          _buildDrawerTile(
            title: 'My Profile',
            icon: Icons.person_outline,
            onTap: () { Navigator.of(context).pop(); /* Điều hướng tới My Profile */ },
          ),
          _buildDrawerTile(
            title: 'Notification',
            icon: Icons.notifications_none,
            onTap: () { Navigator.of(context).pop(); /* Điều hướng tới Notification Settings */ },
          ),
          _buildDrawerTile(
            title: 'My Recent Trips',
            icon: Icons.map,
            onTap: () { Navigator.of(context).pop(); },
          ),
          _buildDrawerTile(
            title: 'Added Address',
            icon: Icons.location_on_outlined,
            onTap: () { Navigator.of(context).pop(); },
          ),
          _buildDrawerTile(
            title: 'My wallet',
            icon: Icons.account_balance_wallet_outlined,
            onTap: () { Navigator.of(context).pop(); },
          ),
          _buildDrawerTile(
            title: 'Invite Friends',
            icon: Icons.group_outlined,
            onTap: () { Navigator.of(context).pop(); },
          ),
          _buildDrawerTile(
            title: 'Help & Support',
            icon: Icons.help_outline,
            onTap: () { Navigator.of(context).pop(); },
          ),
          
          const SizedBox(height: 20),
          const Divider(color: Colors.white70, height: 1), // Đường phân cách
          const SizedBox(height: 20),

          // Sign Out
          _buildDrawerTile(
            title: 'Sign Out',
            icon: Icons.logout,
            onTap: () { Navigator.of(context).pop(); /* Thực hiện chức năng Đăng xuất */ },
          ),
        ],
      ),
    );
  }
  
  // Widget hỗ trợ cho Drawer Tile
  Widget _buildDrawerTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
