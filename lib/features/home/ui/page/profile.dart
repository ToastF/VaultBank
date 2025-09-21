import 'package:flutter/material.dart';

// 1. Impor file logout_user.dart (sesuaikan path jika perlu)
import '../../../auth/service/logout_user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Blue background
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.3, // 30% layar
            pinned: false,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.blue,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.blue),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Filbert Ferdinand",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "081***1323",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // white background
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMenuItem(Icons.person, "Pengaturan Profil"),
                  _buildMenuItem(Icons.security, "Pengaturan Keamanan"),
                  _buildMenuItem(Icons.lock, "Rubah Password"),
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.help, "Pusat Bantuan"),
                  _buildMenuItem(Icons.description, "Syarat dan Ketentuan"),
                  _buildMenuItem(Icons.privacy_tip, "Privacy"),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    // ===============================================
                    // == 2. Panggil service LogoutUser di sini ==
                    // ===============================================
                    onPressed: () {
                      // Membuat instance dari LogoutUser dan langsung memanggilnya
                      LogoutUser(context)();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Logout",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}