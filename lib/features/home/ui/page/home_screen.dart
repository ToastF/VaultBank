import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/home/ui/home_widget/action_button.dart';
import 'package:vaultbank/features/home/ui/home_widget/balance_card.dart';
import 'package:vaultbank/features/home/ui/home_widget/history_list.dart';
import 'package:vaultbank/features/home/ui/home_widget/home_header.dart';
import '../../../user/ui/cubit/user_cubit.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // untuk background bagian putih
      backgroundColor: const Color.fromRGBO(240, 241, 243, 1),
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
                  HomeHeader(userName: userName),

                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.28 - screenHeight * 0.06,
                        ),
                        BalanceCard(balance: state.user.balance),
                        ActionButtons(),
                        HistoryList(),
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
