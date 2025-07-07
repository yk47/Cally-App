// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/models/user_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  YoutubePlayerController? _youtubeController;
  User? currentUser;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    final videoId = YoutubePlayer.convertUrlToId(
      'https://www.youtube.com/watch?v=bP4U-L4EHcg',
    );
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
    }
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
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Profile Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/profile.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.person,
                                size: 36,
                                color: Color(0xFF2563EB),
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
                        const SizedBox(height: 2),
                        Text(
                          'Calley Personal',
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
            ),
            const SizedBox(height: 24),
            // Info + Video Card Combined
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: Offset(0, 4),
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
                      margin: const EdgeInsets.only(
                        bottom: 200,
                      ), // Space for overlapping video
                      decoration: const BoxDecoration(
                        color: Color(0xFF223A6A),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'If you are here for the first time then ensure that you have uploaded the list to call from calley Web Panel hosted on https://app.getcalley.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Video Container (overlapping bottom)
                    Positioned(
                      top: 75,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child:
                              _youtubeController != null
                                  ? YoutubePlayer(
                                    controller: _youtubeController!,
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: Colors.red,
                                    progressColors: const ProgressBarColors(
                                      playedColor: Colors.red,
                                      handleColor: Colors.redAccent,
                                    ),
                                    onReady: () {
                                      debugPrint('Player is ready.');
                                    },
                                    bottomActions: [
                                      CurrentPosition(),
                                      ProgressBar(isExpanded: true),
                                      RemainingDuration(),
                                      FullScreenButton(),
                                    ],
                                  )
                                  : Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Bottom Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF25D366), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/whatsapp.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.chat,
                              color: Color(0xFF25D366),
                              size: 28,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Star Calling Now',
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
            ),
          ],
        ),
      ),
    );
  }
}
