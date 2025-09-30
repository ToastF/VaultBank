import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';

class PinEntryPage extends StatefulWidget {
  final VoidCallback onCompleted;

  const PinEntryPage({
    super.key,
    required this.onCompleted,
  });

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  String _pin = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    
    // 🔍 DEBUGGING: Cek state user saat page dibuka
    final userState = context.read<UserCubit>().state;
    debugPrint('📌 [PinEntryPage] initState - UserState: ${userState.runtimeType}');
    
    if (userState is UserLoaded) {
      debugPrint('✅ [PinEntryPage] User sudah loaded: ${userState.user.uid}');
    } else if (userState is UserLoading) {
      debugPrint('⏳ [PinEntryPage] User masih loading...');
    } else if (userState is UserError) {
      debugPrint('❌ [PinEntryPage] User error: ${userState.message}');
    } else {
      debugPrint('⚠️ [PinEntryPage] User dalam state: ${userState.runtimeType}');
    }
  }

  void _onNumberPressed(String number) {
    if (_pin.length < 6) {
      setState(() {
        _pin += number;
        _errorMessage = null;
      });

      // Auto-verify when 6 digits entered
      if (_pin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _errorMessage = null;
      });
    }
  }

  Future<void> _verifyPin() async {
    // 🔍 DEBUGGING: Cek state sebelum verifikasi
    final userStateBefore = context.read<UserCubit>().state;
    debugPrint('🔐 [PinEntryPage] Memulai verifikasi PIN...');
    debugPrint('🔍 [PinEntryPage] UserState saat verify: ${userStateBefore.runtimeType}');
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user from UserCubit
      final userState = context.read<UserCubit>().state;
      
      if (userState is! UserLoaded) {
        debugPrint('❌ [PinEntryPage] User tidak loaded! State: ${userState.runtimeType}');
        setState(() {
          _errorMessage = 'User tidak ditemukan';
          _isLoading = false;
          _pin = '';
        });
        return;
      }

      final uid = userState.user.uid;
      debugPrint('✅ [PinEntryPage] User loaded, UID: $uid');
      debugPrint('🔑 [PinEntryPage] Memverifikasi PIN...');
      
      // Verify PIN using repository
      final userRepo = context.read<UserCubit>().userRepo;
      final isValid = await userRepo.verifyPin(uid, _pin);

      debugPrint('🔍 [PinEntryPage] Hasil verifikasi PIN: $isValid');

      if (!mounted) return;

      if (isValid) {
        debugPrint('✅ [PinEntryPage] PIN benar! Melanjutkan...');
        // PIN correct
        widget.onCompleted();
      } else {
        debugPrint('❌ [PinEntryPage] PIN salah!');
        // PIN incorrect
        setState(() {
          _errorMessage = 'PIN salah, silakan coba lagi';
          _pin = '';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('💥 [PinEntryPage] Error saat verifikasi: $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
        _pin = '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 [PinEntryPage] Building widget...');
    
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        // 🔍 DEBUGGING: Monitor perubahan state
        debugPrint('🔄 [PinEntryPage] BlocBuilder rebuild - State: ${userState.runtimeType}');
        
        // Jika user belum loaded, tampilkan loading screen
        if (userState is! UserLoaded) {
          debugPrint('⏳ [PinEntryPage] Menunggu user loaded...');
          
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  debugPrint('🔙 [PinEntryPage] User menekan tombol back saat loading');
                  Navigator.pop(context);
                },
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
                  const CircularProgressIndicator(
                    color: Color(0xFF5B9EE1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userState is UserLoading 
                        ? 'Memuat data user...'
                        : userState is UserError
                            ? 'Error: ${userState.message}'
                            : 'Menunggu data user...',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  if (userState is UserError) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('🔙 [PinEntryPage] User menekan tombol kembali karena error');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9EE1),
                      ),
                      child: const Text('Kembali'),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        // User sudah loaded, tampilkan halaman PIN
        debugPrint('✅ [PinEntryPage] User loaded, menampilkan halaman PIN');
        debugPrint('👤 [PinEntryPage] User UID: ${userState.user.uid}');
        
        return _buildPinEntryScaffold();
      },
    );
  }

  Widget _buildPinEntryScaffold() {
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
          
          // Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.swap_horiz,
              color: Color(0xFF5B9EE1),
              size: 40,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          const Text(
            'Masukan Pin',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5B9EE1),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // PIN Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < _pin.length
                      ? const Color(0xFF5B9EE1)
                      : const Color(0xFFD6E9F8),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 16),
          
          // Error Message
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          const Spacer(),
          
          // Loading Indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CircularProgressIndicator(
                color: Color(0xFF5B9EE1),
              ),
            ),
          
          // Custom Numpad
          if (!_isLoading)
            _buildNumpad(),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Row 1-2-3
          _buildNumpadRow(['1', '2', '3']),
          const SizedBox(height: 16),
          
          // Row 4-5-6
          _buildNumpadRow(['4', '5', '6']),
          const SizedBox(height: 16),
          
          // Row 7-8-9
          _buildNumpadRow(['7', '8', '9']),
          const SizedBox(height: 16),
          
          // Row empty-0-backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 70, height: 70), // Empty space
              _buildNumpadButton('0'),
              _buildBackspaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _buildNumpadButton(number)).toList(),
    );
  }

  Widget _buildNumpadButton(String number) {
    return InkWell(
      onTap: () => _onNumberPressed(number),
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
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

  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: _onBackspacePressed,
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
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