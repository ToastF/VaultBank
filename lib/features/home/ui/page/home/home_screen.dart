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
  // Variabel ini akan menerima fungsi dari NavBar (specific case untuk Transfer nantinya)
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

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
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // loading indicator saat data dimuat
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // error handling
          if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is UserLoaded) {
            final String userName = state.user.username;

            return SingleChildScrollView(
              child: Stack(
                children: [
                  HomeHeader(
                    userName: userName,
                    profileImagePath: state.user.profileImagePath),

                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.28 - screenHeight * 0.08,
                        ),
                        BalanceCard(
                          balance: state.user.balance, 
                          accountNumber: state.user.accountNumber),
                        ActionButtons(onNavigate: widget.onNavigate,),
                        HistoryList(),
                        SizedBox(height: screenHeight * 0.02),
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
