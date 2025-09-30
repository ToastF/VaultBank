//TODO: WILL NOT BE USED DELETE SOON
import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart';

class ActionButtonWidget extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final VoidCallback onTap;

  const ActionButtonWidget({
    super.key,
    this.icon,
    this.imagePath,
    required this.label,
    required this.onTap,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided.');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteBackground,
                shape: BoxShape.circle,
              ),
              // Logika untuk menampilkan gambar dari aset atau ikon
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 28,
                      height: 28,
                    )
                  : Icon(
                      icon!, 
                      color: AppColors.blueIcon, 
                      size: 28
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}