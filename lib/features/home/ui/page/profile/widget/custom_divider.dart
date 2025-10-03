import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart'; 

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.greyDivider,
      indent: 20,
      endIndent: 20,
    );
  }
}