import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/core/util/animation_slide.dart';
import 'package:vaultbank/core/util/color_palette.dart';
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
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.white,
                            child: Icon(Icons.person,
                                size: 50, color: AppColors.blueIcon),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            user.username,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.notelp.toString(),
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.whiteBackground,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person,
                        title: "Pengaturan Profil",
                        onTap: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(page: ProfileSettingScreen()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.security,
                        title: "Pengaturan Keamanan",
                        onTap: () {
                          // Navigasi ke halaman pengaturan keamanan
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.lock,
                        title: "Rubah Password",
                        onTap: () {
                          // Navigasi ke halaman rubah password
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildMenuItem(
                        icon: Icons.help,
                        title: "Pusat Bantuan",
                        onTap: () { 
                            // 
                          },
                      ),
                      _buildMenuItem(
                        icon: Icons.description,
                        title: "Syarat dan Ketentuan",
                        onTap: () {

                           },
                      ),
                      _buildMenuItem(
                        icon: Icons.privacy_tip,
                        title: "Privacy",
                        onTap: () {
  
                           },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          LogoutUser(context)();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whiteBackground,
                          side: const BorderSide(
                            color: AppColors.blueText,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Logout",
                            style: TextStyle(
                                color: AppColors.blueText)),
                      ),
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
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.blueIcon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

