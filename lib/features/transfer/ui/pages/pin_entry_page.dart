import 'package:flutter/material.dart';

class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  String _pin = '';

  void _onKeyPressed(String value) {
    if (!mounted) return;
    setState(() {
      if (value == 'backspace') {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else if (_pin.length < 6) {
        _pin += value;
      }
    });

    if (_pin.length == 6) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          Navigator.pop(context, _pin);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: Icon(Icons.swap_horiz, color: Colors.blue[800], size: 32),
                  ),
                  const SizedBox(height: 24),
                  const Text('Masukan Pin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < _pin.length ? Colors.blueAccent : Colors.grey[300],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'backspace'];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 1.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        final key = keys[index];
        if (key.isEmpty) return const SizedBox.shrink();
        return Material(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => _onKeyPressed(key),
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: key == 'backspace'
                  ? const Icon(Icons.backspace_outlined)
                  : Text(key, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}