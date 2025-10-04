import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart'; 

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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), 
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.blackText, fontSize: 16),
            ),
            const SizedBox(width: 16), 

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: valueWidget,
              ),
            ),
            const SizedBox(width: 8), 

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit',
                  style: TextStyle(color: AppColors.blueText, fontSize: 16),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.blueText,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}