import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/recipient/ui/cubit/recipient_cubit.dart';
import 'package:vaultbank/features/transaction_history/ui/cubit/transaction_cubit.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/util/navi_util.dart';
import 'package:vaultbank/features/home/ui/page/navbar/NavBar.dart';
import 'package:vaultbank/core/util/color_palette.dart';

// Page to signup a user
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final telpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;
    final double titleFontSize = screenWidth * 0.08;
    final double inputFontSize = screenWidth * 0.045;
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
                        const SnackBar(content: Text("Signup success!")),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.001),

                          // Title
                          Text(
                            "Get started",
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: verticalSpacing / 2),
                          Text(
                            "Let's get to know you",
                            style: TextStyle(
                              fontSize: inputFontSize,
                              color: AppColors.blackText,
                            ),
                          ),

                          SizedBox(height: verticalSpacing * 2),

                          // Username
                          Text(
                            "Username",
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                          TextField(
                            controller: nameCtrl,
                            decoration: const InputDecoration(
                              hintText: "Enter your username",
                            ),
                          ),
                          SizedBox(height: verticalSpacing),

                          // Email
                          Text(
                            "Email",
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                          TextField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(
                              hintText: "Enter your email",
                            ),
                          ),
                          SizedBox(height: verticalSpacing),

                          // Password
                          Text(
                            "Password",
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                          TextField(
                            controller: passwordCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Enter your password",
                            ),
                          ),
                          SizedBox(height: verticalSpacing),

                          // Confirm Password
                          Text(
                            "Confirm Password",
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                          TextField(
                            controller: confirmPasswordCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Confirm your password",
                            ),
                          ),
                          SizedBox(height: verticalSpacing),

                          // Transaction PIN
                          Text(
                            "Transaction PIN",
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                          TextField(
                            controller: pinCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Enter your PIN",
                            ),
                          ),
                          SizedBox(height: verticalSpacing),

                          // Telephone Number
                          Text(
                            "Telephone Number (+62)",
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                          TextField(
                            controller: telpCtrl,
                            decoration: const InputDecoration(
                              hintText: "eg. 53535400010",
                            ),
                          ),

                          SizedBox(height: verticalSpacing * 2),

                          // Signup button
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
                                final username = nameCtrl.text.trim();
                                final email = emailCtrl.text.trim();
                                final password = passwordCtrl.text.trim();
                                final confirmPassword =
                                    confirmPasswordCtrl.text.trim();
                                final pin = pinCtrl.text.trim();
                                final telp = telpCtrl.text.trim();

                                // Check required fields
                                if (username.isEmpty ||
                                    email.isEmpty ||
                                    password.isEmpty ||
                                    confirmPassword.isEmpty ||
                                    pin.isEmpty ||
                                    telp.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "All fields must be filled",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Username length check
                                if (username.length > 30) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Username cannot exceed 30 characters",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Email format validation
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(email)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Invalid email format"),
                                    ),
                                  );
                                  return;
                                }

                                // Space checks
                                if (email.contains(" ") ||
                                    password.contains(" ") ||
                                    confirmPassword.contains(" ") ||
                                    pin.contains(" ") ||
                                    telp.contains(" ")) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Spaces are not allowed in fields except Username",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Password match check
                                if (password != confirmPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Passwords do not match"),
                                    ),
                                  );
                                  return;
                                }

                                // Telephone validations
                                if (telp.length != 11) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Telephone number must be 11 digits",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (!RegExp(r'^[0-9]+$').hasMatch(telp)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Telephone number must contain only digits",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // sign up
                                context.read<AuthCubit>().signUp(
                                  username,
                                  email,
                                  password,
                                  pin,
                                  telp,
                                );
                              },

                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: inputFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
