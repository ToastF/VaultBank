import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/common/ui/cubit/pin_cubit.dart';
import 'package:vaultbank/features/common/ui/cubit/pin_state.dart';

import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';

class PinEntryPage extends StatelessWidget {
  final VoidCallback onCompleted;

  const PinEntryPage({super.key, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCubit(
        userCubit: context.read<UserCubit>(),
      ),
      child: BlocListener<PinCubit, PinState>(
        listener: (context, state) {
          if (state is PinSuccess) {
            onCompleted();
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState is UserLoaded) {
              return const _PinEntryView();
            }
            return _buildUserLoadingScreen(context, userState);
          },
        ),
      ),
    );
  }

  Widget _buildUserLoadingScreen(BuildContext context, UserState userState) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Masukan PIN',
          style: TextStyle(
            color: Color(0xFF5B9EE1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userState is UserLoading)
              const CircularProgressIndicator(
                color: Color(0xFF5B9EE1),
              ),
            const SizedBox(height: 16),
            Text(
              userState is UserLoading
                  ? 'Memuat data user...'
                  : userState is UserError
                      ? 'Error: ${userState.message}'
                      : 'Gagal memuat data user.',
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinEntryView extends StatelessWidget {
  const _PinEntryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinCubit, PinState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Masukan PIN',
              style: TextStyle(
                color: Color(0xFF5B9EE1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  color: Color(0xFF5B9EE1),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Masukan Pin',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5B9EE1),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < state.currentPin.length
                          ? const Color(0xFF5B9EE1)
                          : const Color(0xFFD6E9F8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: Center(
                  child: state is PinFailure
                      ? Text(
                          state.message,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        )
                      : state is PinLoading
                          ? const CircularProgressIndicator(color: Color(0xFF5B9EE1))
                          : null,
                ),
              ),
              const Spacer(),
              if (state is! PinLoading) _buildNumpad(context),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNumpad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          _buildNumpadRow(context, ['1', '2', '3']),
          const SizedBox(height: 16),
          _buildNumpadRow(context, ['4', '5', '6']),
          const SizedBox(height: 16),
          _buildNumpadRow(context, ['7', '8', '9']),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 70, height: 70),
              _buildNumpadButton(context, '0'),
              _buildBackspaceButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadRow(BuildContext context, List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _buildNumpadButton(context, number)).toList(),
    );
  }

  Widget _buildNumpadButton(BuildContext context, String number) {
    return InkWell(
      onTap: () => context.read<PinCubit>().addDigit(number),
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(BuildContext context) {
    return InkWell(
      onTap: () => context.read<PinCubit>().removeDigit(),
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.black54,
          size: 24,
        ),
      ),
    );
  }
}