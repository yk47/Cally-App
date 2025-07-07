// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import '../widgets/bottomnavbar.dart';
import '../widgets/sidemenu.dart';
import 'package:go_router/go_router.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: SideMenu(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Add navigation logic here if needed
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Dashboard title and profile icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder:
                            (context) => IconButton(
                              icon: Icon(
                                Icons.menu,
                                size: 24,
                                color: Colors.black,
                              ),
                              onPressed:
                                  () => Scaffold.of(context).openDrawer(),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/callhead.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.notifications_outlined,
                              size: 24,
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(width: 15),
                      Image.asset(
                        'assets/icons/notification.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.notifications_outlined,
                              size: 24,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Welcome Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange,
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
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello ${currentUser?.name ?? 'User'}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Welcome to Calley!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Load Number Card
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Text Container (top)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 20,
                                left: 16,
                                right: 16,
                              ),
                              // Space for overlapping video
                              decoration: const BoxDecoration(
                                color: Color(0xFF223A6A),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                'LOAD NUMBER TO CALL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Video Container (overlapping bottom)
                            Positioned(
                              top: 40,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                width: double.infinity,

                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Text at top
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: 'Visit ',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'https://app.getcalley.com',
                                              style: TextStyle(
                                                color: Color(0xFF2563EB),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' to upload numbers that you wish to call using Calley Mobile App.',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Image at bottom left touching edges
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Image.asset(
                                        'assets/images/homeImg.png',

                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 60,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bottom action buttons
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFF25D366),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/images/whatsapp.png',
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.chat,
                                    color: Color(0xFF25D366),
                                    size: 24,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _showCallingListsBottomSheet(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Start Calling Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallingListsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Text Container (top)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 20,
                      left: 16,
                      right: 16,
                    ),
                    // Space for overlapping video
                    decoration: const BoxDecoration(
                      color: Color(0xFF223A6A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      'CALLING LISTS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Video Container (overlapping bottom)
                  Positioned(
                    top: 40,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,

                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Select Calling List text field
                            GestureDetector(
                              onTap: () {
                                // Handle tap to show dropdown options
                              },
                              child: Container(
                                width: double.infinity,
                                height: 55,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Select Calling List',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Image.asset(
                                        'assets/icons/refresh.png',
                                        width: 12,
                                        height: 12,
                                      ),
                                      label: const Text(
                                        'Refresh',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF2563EB,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 6,
                                        ),
                                        minimumSize: Size(0, 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Test List item
                            Container(
                              width: double.infinity,
                              height: 55,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Test List',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.go('/testlist');
                                    },

                                    icon: Image.asset(
                                      'assets/icons/arrow_right.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
