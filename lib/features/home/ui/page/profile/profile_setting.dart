import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import 'package:vaultbank/core/util/color_palette.dart'; // pastikan path ini benar sesuai proyekmu

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.blueHeader,
        foregroundColor: AppColors.white,
        elevation: 1.0,
        title: const Text('Pengaturan Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // loading indicator jika data sedang dimuat
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // error handling
          if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          // if state is UserLoaded, tampilkan data profil
          if (state is UserLoaded) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Container(
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
                    _SettingItem(
                      label: 'Edit profile picture',
                      valueWidget: CircleAvatar(
                        radius: 24,
                        backgroundImage: (user.profileImagePath != null &&
                                File(user.profileImagePath!).existsSync())
                            ? FileImage(File(user.profileImagePath!))
                            : null,
                        child: (user.profileImagePath == null ||
                                !File(user.profileImagePath!).existsSync())
                            ? const Icon(Icons.person, size: 24)
                            : null,
                      ),
                      onTap: () {
                        // memanggil cubit untuk update foto (akan pick dan simpan path lokal)
                        context.read<UserCubit>().updateProfilePicture();
                      },
                    ),
                    const _CustomDivider(),
                    _SettingItem(
                      label: 'Edit username',
                      valueWidget: Text(
                        user.username,
                        style: const TextStyle(
                          color: AppColors.blackText,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // logic edit username
                      },
                    ),
                    const _CustomDivider(),
                    _SettingItem(
                      label: 'Edit No Hp',
                      valueWidget: Text(
                        user.notelp ?? '',
                        style: const TextStyle(
                          color: AppColors.blackText,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // logic edit no hp
                      },
                    ),
                    const _CustomDivider(),
                    _SettingItem(
                      label: 'Edit Email',
                      valueWidget: Text(
                        user.email,
                        style: const TextStyle(
                          color: AppColors.blackText,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // logic edit email
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          // Tampilan fallback jika state tidak dikenali
          return const Center(
            child: Text('Terjadi kesalahan tidak diketahui.'),
          );
        },
      ),
    );
  }
}

// widget untuk item setting
class _SettingItem extends StatelessWidget {
  final String label;
  final Widget valueWidget;
  final VoidCallback onTap;

  const _SettingItem({
    required this.label,
    required this.valueWidget,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.blackText, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.centerRight,
              child: valueWidget,
            ),
          ),
          const SizedBox(width: 8),
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

// Widget untuk garis pemisah
class _CustomDivider extends StatelessWidget {
  const _CustomDivider({super.key});

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
