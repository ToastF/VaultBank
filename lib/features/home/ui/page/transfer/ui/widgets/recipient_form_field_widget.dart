// Widget ini akan dimanfaatkan sebagai field input untuk memasukkan nomor rekening
// Pada add_internal_account_page.dart

import 'package:flutter/material.dart';

class RecipientFormFieldWidget extends StatelessWidget {
  final int index;
  final TextEditingController accountController;
  final TextEditingController nameController;
  final bool canBeRemoved;
  final VoidCallback onRemove;

  const RecipientFormFieldWidget({
    super.key,
    required this.index,
    required this.accountController,
    required this.nameController,
    required this.canBeRemoved,
    required this.onRemove,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Penerima ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (canBeRemoved)
              IconButton(
                onPressed: onRemove, 
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red,))
            ],
          ),

          const SizedBox(height: 8,),
          TextField(
            controller: accountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'No Rekening',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12,),
        ],
      ),
      );
  }
}