import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/home/ui/page/home/widget/action_button.dart';
import 'package:vaultbank/features/home/ui/page/home/widget/balance_card.dart';
import 'package:vaultbank/features/home/ui/page/home/widget/history_list.dart';
import 'package:vaultbank/features/home/ui/page/home/widget/home_header.dart';
import '../../../../user/ui/cubit/user_cubit.dart';
import '../../../../auth/service/handle_AC_flow.dart';
import '../../../../../../core/util/color_palette.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = screenHeight * 0.28;

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is UserLoaded) {
            final String userName = state.user.username;
            final String? profileImagePath = state.user.profileImagePath;

            return SingleChildScrollView(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  HomeHeader(
                    userName: userName,
                    profileImagePath: profileImagePath,
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: headerHeight - 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        BalanceCard(
                          balance: state.user.balance,
                          accountNumber: state.user.accountNumber,
                        ),
                        const SizedBox(height: 20),
                        const ActionButtons(),
                        const SizedBox(height: 20),
                        const HistoryList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
