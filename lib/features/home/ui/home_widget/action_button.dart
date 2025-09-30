import 'package:flutter/material.dart';
import '../page/topup/top_up.dart';
import '../../../../core/util/animation_slide.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // biar dinamis
    final screenWidth = MediaQuery.of(context).size.width;

    final double iconSize = screenWidth * 0.075;
    final double circlePadding = screenWidth * 0.035;
    final double fontSize = screenWidth * 0.032;
    final double spacing = screenWidth * 0.02;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(240,241,243,1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.add,
                label: 'Top up',
                onTap: () {
                  Navigator.push(
                    context,
                    SlidePageRoute(page: const TopUpPage()),
                  );
                },
                iconSize: iconSize,
                circlePadding: circlePadding,
                fontSize: fontSize,
                spacing: spacing,
              ),
            ),
            Expanded(
              child: _buildActionButton(
                icon: Icons.arrow_downward,
                label: 'Tarik Tunai',
                onTap: () {
                  // Navigator.push
                },
                iconSize: iconSize,
                circlePadding: circlePadding,
                fontSize: fontSize,
                spacing: spacing,
              ),
            ),
            Expanded(
              child: _buildActionButton(
                icon: Icons.send,
                label: 'Transfer',
                onTap: () {
                  // Navigator.push
                },
                iconSize: iconSize,
                circlePadding: circlePadding,
                fontSize: fontSize,
                spacing: spacing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double iconSize,
    required double circlePadding,
    required double fontSize,
    required double spacing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(circlePadding),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(197,219,250, 1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: iconSize, color: const Color.fromRGBO(39,60,139, 1)),
          ),
          SizedBox(height: spacing),
          Text(
            label,
            style: TextStyle(fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
