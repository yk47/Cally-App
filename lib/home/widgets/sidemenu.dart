// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/models/user_model.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  User? currentUser;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _userRepository.getUser();
    if (mounted) {
      setState(() {
        currentUser = user;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Logout'),
              ),
            ],
          );
        },
      );

      if (shouldLogout == true) {
        // Clear user data
        await _userRepository.clearUser();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged out successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to login screen
          context.go('/login');
        }
      }
    } catch (e) {
      // Show error message if logout fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(248, 250, 252, 1),
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/profile.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  currentUser?.name ?? 'User',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Add dot between name and Personal
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 199, 120, 1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    'Personal',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 199, 120, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentUser?.email ?? 'user@example.com',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 16),
                _buildMenuItem(
                  assetPath: 'assets/icons/rocket.png',
                  title: 'Getting Started',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/sync.png',
                  title: 'Sync Data',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/squares.png',
                  title: 'Gamification',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/message_call.png',
                  title: 'Send Logs',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/settings.png',
                  title: 'Settings',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/help.png',
                  title: 'Help?',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/cancle_person.png',
                  title: 'Cancel Subscription',
                  onTap: () {},
                ),

                Divider(),
                const SizedBox(height: 10),
                // App Info Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'App Info',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                _buildMenuItem(
                  assetPath: 'assets/icons/aboutus.png',
                  title: 'About Us',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/policy.png',
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/version.png',
                  title: 'Version 1.01.52',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/share.png',
                  title: 'Share App',
                  onTap: () {},
                ),
                _buildMenuItem(
                  assetPath: 'assets/icons/logout.png',
                  title: 'Logout',
                  onTap: _handleLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String assetPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              assetPath,
              width: 22,
              height: 22,
              color: Color(0xFF64748B),
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.error_outline,
                    color: Color(0xFF64748B),
                    size: 22,
                  ),
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 16,
      ),
    );
  }
}
