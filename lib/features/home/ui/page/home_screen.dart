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
    return Scaffold(
      // untuk background bagian putih
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            // background bagian biru
            height: MediaQuery.of(context).size.height * 0.35,
            color: const Color(0xFF0D63F3),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                
                children: const[
                  HomeHeader(),
                  BalanceCard(),
                  ActionButtons(),
                  HistoryList()
                ],
              ),
            ))
        ],
      ),
    );
  }
}
