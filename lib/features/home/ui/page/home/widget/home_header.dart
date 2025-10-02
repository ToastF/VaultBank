import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? profileImagePath;

  const HomeHeader({
    super.key,
    required this.userName,
    this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {

    // biar dinamis
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.05; 
    final double topPadding = screenHeight * 0.025; 
    final double bottomPadding = screenHeight * 0.09; 
    final double avatarRadius = screenWidth * 0.065;
    final double iconSize = screenWidth * 0.08;
    final double spacing = screenWidth * 0.04;
    final double welcomeFontSize = screenWidth * 0.035;
    final double nameFontSize = screenWidth * 0.045;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.28,
      color: AppColors.blueHeader,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            bottomPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: AppColors.white,
            // Tampilkan gambar dari state jika ada
            backgroundImage: profileImagePath != null
                ? FileImage(File(profileImagePath!))
                : null,
            child: profileImagePath == null
                ? Icon(Icons.person, size: iconSize, color: AppColors.blueIcon)
                : null,
          ),
              SizedBox(width: spacing), 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: welcomeFontSize, 
                    ),
                  ),
                  Text(
                    userName, 
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: nameFontSize, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}