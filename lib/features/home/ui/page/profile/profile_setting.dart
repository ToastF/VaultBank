import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import 'package:vaultbank/core/util/color_palette.dart'; 
import '../profile/services/profile_image_service.dart'; 
import '../profile/widget/list_view.dart'; 

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  File? _profileImageFile;
  final _imageService = ProfileImageService();

  @override
  void initState() {
    super.initState();
    _loadInitialImage();
  }

  Future<void> _loadInitialImage() async {
    final imageFile = await _imageService.loadProfileImage();
    if (mounted) {
      setState(() {
        _profileImageFile = imageFile;
      });
    }
  }

  Future<void> _handleEditPicture() async {
    final newImageFile = await _imageService.pickAndSaveImage();
    if (newImageFile != null) {
      setState(() {
        _profileImageFile = newImageFile;
      });
      // Update profile image path in UserCubit
      final userCubit = context.read<UserCubit>();
      final currentState = userCubit.state;
      if (currentState is UserLoaded) {
        final uid = currentState.user.uid;
        await userCubit.updateProfileImagePath(uid, newImageFile.path);
      }
    }
  }

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
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is UserLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: SettingsListView(
                user: state.user,
                profileImageFile: _profileImageFile,
                onEditPicture: _handleEditPicture,
              ),
            );
          }
          return const Center(
            child: Text('Terjadi kesalahan tidak diketahui.'),
          );
        },
      ),
    );
  }
}