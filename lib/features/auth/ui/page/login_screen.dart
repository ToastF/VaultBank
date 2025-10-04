import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/auth/ui/page/signup_screen.dart';
import 'package:vaultbank/features/recipient/ui/cubit/recipient_cubit.dart';
import 'package:vaultbank/features/transaction_history/ui/cubit/transaction_cubit.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/util/navi_util.dart';
import 'package:vaultbank/features/home/ui/page/navbar/NavBar.dart';
import 'package:vaultbank/core/util/color_palette.dart';

// Page to login a user
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Dynamic Sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;
    final double titleFontSize = screenWidth * 0.08;
    final double inputFontSize = screenWidth * 0.040;
    final double buttonHeight = screenHeight * 0.065;

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: EdgeInsets.only(top: verticalSpacing),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Scrollable
              Expanded(
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      context.read<UserCubit>()
                        ..loadUser(state.auth.uid)
                        ..startUserListener(state.auth.uid);

                      context.read<RecipientCubit>()
                        ..loadRecipients(state.auth.uid)
                        ..startRecipientListener(state.auth.uid);

                      context.read<TransactionCubit>()
                        ..loadTransactions(state.auth.uid)
                        ..startTransactionListener(state.auth.uid);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login success!")),
                      );
                      NavigationHelper.goToAndRemoveAll(
                        context,
                        const NavBar(),
                      );
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.005),

                          // Illustration
                          Image.asset(
                            "assets/images/login.png",
                            width: screenWidth * 0.4,
                          ),

                          // Title
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackText,
                            ),
                          ),

                          SizedBox(height: verticalSpacing * 4),

                          // Email field
                          TextField(
                            controller: emailCtrl,
                            decoration: InputDecoration(
                              hintText: "Email",
                              contentPadding: EdgeInsets.all(
                                screenWidth * 0.04,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            style: TextStyle(fontSize: inputFontSize),
                          ),

                          SizedBox(height: verticalSpacing * 2),

                          // Password field
                          TextField(
                            controller: passwordCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              contentPadding: EdgeInsets.all(
                                screenWidth * 0.04,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            style: TextStyle(fontSize: inputFontSize),
                          ),

                          SizedBox(height: verticalSpacing * 2),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blueButton,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                context.read<AuthCubit>().logIn(
                                  emailCtrl.text,
                                  passwordCtrl.text,
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: inputFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: verticalSpacing * 3),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(fontSize: inputFontSize),
                              ),
                              GestureDetector(
                                onTap: () {
                                  NavigationHelper.goTo(
                                    context,
                                    SignupScreen(),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: inputFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blueLightText,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
