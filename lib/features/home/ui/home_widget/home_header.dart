import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        bottomPadding,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: iconSize, 
              color: const Color(0xFF0D63F3),
            ),
          ),
          SizedBox(width: spacing), 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: welcomeFontSize, 
                ),
              ),
              Text(
                'Filbert Ferdinand',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: nameFontSize, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}