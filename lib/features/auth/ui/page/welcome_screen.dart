import 'package:flutter/material.dart';
import '../../../../core/util/navi_util.dart';
import '../page/login_screen.dart';
import '../page/signup_screen.dart';
import '../cubit/auth_cubit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to VaultBank!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                   NavigationHelper.goToWithCubit(context, SignupScreen(), AuthCubit.create(context));
                },
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  NavigationHelper.goToWithCubit(context, LoginScreen(), AuthCubit.create(context));
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


