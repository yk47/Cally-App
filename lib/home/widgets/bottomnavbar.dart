// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        border: Border(top: BorderSide(color: Colors.blueAccent, width: 1.5)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItemWithAsset(
            assetPath: 'assets/icons/home.png',
            index: 0,
            isSelected: selectedIndex == 0,
          ),
          _buildNavItemWithAsset(
            assetPath: 'assets/icons/IDcard.png',
            index: 1,
            isSelected: selectedIndex == 1,
          ),
          _buildPlayButton(),
          _buildNavItemWithAsset(
            assetPath: 'assets/icons/receivedphone.png',
            index: 3,
            isSelected: selectedIndex == 3,
          ),
          _buildNavItemWithAsset(
            assetPath: 'assets/icons/calender.png',
            index: 4,
            isSelected: selectedIndex == 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItemWithAsset({
    required String assetPath,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          assetPath,
          width: 24,
          height: 24,
          color: isSelected ? const Color(0xFF2563EB) : Colors.black,
          errorBuilder:
              (context, error, stackTrace) => Icon(
                Icons.error_outline,
                size: 24,
                color: isSelected ? const Color(0xFF2563EB) : Colors.black,
              ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(
          'assets/icons/play.png',
          width: 24,
          height: 24,
          color: Colors.white,
          errorBuilder:
              (context, error, stackTrace) =>
                  Icon(Icons.play_arrow, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
