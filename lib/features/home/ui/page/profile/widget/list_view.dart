import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart'; 
import 'package:vaultbank/features/user/domain/entities/user_entity.dart'; 
import './item.dart';
import 'custom_divider.dart';

class SettingsListView extends StatelessWidget {
  final UserEntity user;
  final File? profileImageFile;
  final VoidCallback onEditPicture;

  const SettingsListView({
    super.key,
    required this.user,
    required this.profileImageFile,
    required this.onEditPicture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SettingItem(
            label: 'Edit profile picture',
            valueWidget: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.whiteBackground,
              backgroundImage:
                  profileImageFile != null ? FileImage(profileImageFile!) : null,
              child: profileImageFile == null
                  ? const Icon(
                      Icons.person,
                      color: AppColors.blueIcon,
                      size: 24,
                    )
                  : null,
            ),
            onTap: onEditPicture,
          ),
          const CustomDivider(),
          SettingItem(
            label: 'Edit username',
            valueWidget: Text(
              user.username,
              style: const TextStyle(
                color: AppColors.blackText,
                fontSize: 16,
              ),
            ),
            onTap: () {
              print('Edit username tapped');
            },
          ),
          const CustomDivider(),
          SettingItem(
            label: 'Edit No Hp',
            valueWidget: Text(
              user.notelp.toString(),
              style: const TextStyle(
                color: AppColors.blackText,
                fontSize: 16,
              ),
            ),
            onTap: () {
              print('Edit No Hp tapped');
            },
          ),
          const CustomDivider(),
          SettingItem(
            label: 'Edit Email',
            valueWidget: Text(
              user.email,
              style: const TextStyle(
                color: AppColors.blackText,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              print('Edit Email tapped');
            },
          ),
        ],
      ),
    );
  }
}