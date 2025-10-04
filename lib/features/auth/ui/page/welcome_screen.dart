import 'package:flutter/material.dart';
import '../../../../core/util/navi_util.dart';
import '../page/login_screen.dart';
import '../page/signup_screen.dart';
import 'package:vaultbank/core/util/color_palette.dart'; // assuming you have global colors

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // If not authenticated, this is the first entry to the app where we'll show buttons to go to signup or login screen
  @override
  Widget build(BuildContext context) {
    // Dynamic Sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.08;
    final double topPadding = screenHeight * 0.12;
    final double spacing = screenHeight * 0.04;
    final double titleFontSize = screenWidth * 0.06;
    final double subtitleFontSize = screenWidth * 0.045;
    final double buttonHeight = screenHeight * 0.065;

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: topPadding),

              // Logo icon
              Image.asset(
                "assets/images/icon_logo.png",
                width: screenWidth * 0.18,
                height: screenWidth * 0.18,
              ),

              SizedBox(height: spacing),

              // Title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackText,
                  ),
                  children: [
                    const TextSpan(text: "The "),
                    TextSpan(
                      text: "future",
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        color: AppColors.blueText,
                      ),
                    ),
                    const TextSpan(text: " of\nBanking is here"),
                  ],
                ),
              ),

              // Image
              Image.asset(
                "assets/images/welcome.png",
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                fit: BoxFit.contain,
              ),

              SizedBox(height: spacing * 1.2),

              // Login button
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.blueText, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    NavigationHelper.goTo(context, const LoginScreen());
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      color: AppColors.blueText,
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: spacing * 0.7),

              // Register button
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blueText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    NavigationHelper.goTo(context, const SignupScreen());
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
