import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart'; // Sesuaikan path

class SettingItem extends StatelessWidget {
  final String label;
  final Widget valueWidget;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.label,
    required this.valueWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.blackText, fontSize: 16),
          ),
          const Spacer(),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: valueWidget,
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit',
                  style: TextStyle(color: AppColors.blueText, fontSize: 16),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.blueText,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}