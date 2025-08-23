import 'package:flutter/material.dart';
import '../../../auth/service/logout_user.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Home",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
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


