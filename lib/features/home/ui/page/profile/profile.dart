import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/core/util/animation_slide.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:vaultbank/features/home/ui/page/profile/help_center.dart';
import 'package:vaultbank/features/home/ui/page/profile/privacy_policy.dart';
import 'package:vaultbank/features/home/ui/page/profile/terms_condition.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import '../../../../auth/service/logout_user.dart';
import 'profile_setting.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;

        return Scaffold(
          backgroundColor: AppColors.whiteBackground,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.3,
                pinned: false,
                backgroundColor: AppColors.blueHeader,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppColors.blueHeader,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.white,
                            backgroundImage: user.profileImagePath != null
                                ? FileImage(File(user.profileImagePath!))
                                : null,
                            child: user.profileImagePath == null
                                ? const Icon(Icons.person, size: 50, color: AppColors.blueIcon)
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            user.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.accountNumber.toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: "Pengaturan Profil",
                        onTap: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(page: const ProfileSettingScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: "Pusat Bantuan",
                        onTap: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(page: const HelpCenterScreen()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.description_outlined,
                        title: "Syarat dan Ketentuan",
                        onTap: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(
                              page: const TermsAndConditionsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy",
                        onTap: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(page: const PrivacyPolicyScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          LogoutUser(context)();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.white, 
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.1),
                          side: const BorderSide(color: AppColors.blueButton),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 32,
                          ),
                        ),
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            color: AppColors.blueButton,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.blueIcon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
