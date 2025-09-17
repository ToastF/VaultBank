import 'package:flutter/material.dart';
import 'package:vaultbank/features/home/ui/page/profile.dart';
import '../../../auth/service/logout_user.dart';
import '../../../auth/service/handle_AC_flow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await AccessCodeFlow(context).handle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Home",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            child: const Text("profile"),
          ),
          OutlinedButton(
            onPressed: () {
              final logout = LogoutUser(context);
              logout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
