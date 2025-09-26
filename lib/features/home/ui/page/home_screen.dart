import 'package:flutter/material.dart';
import 'package:vaultbank/features/home/ui/home_widget/action_button.dart';
import 'package:vaultbank/features/home/ui/home_widget/balance_card.dart';
import 'package:vaultbank/features/home/ui/home_widget/history_list.dart';
import 'package:vaultbank/features/home/ui/home_widget/home_header.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // untuk background bagian putih
      backgroundColor: const Color(0xFFF1F4F8),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const HomeHeader(),

            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  SizedBox(height: screenHeight * 0.28 - screenHeight * 0.06,),
                  BalanceCard(),
                  ActionButtons(),
                  HistoryList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
