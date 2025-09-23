// Model ini akan dipakai untuk menyimpan nomor rekening orang lain
// yang difavoritkan (bookmarked)
class RecipientModel {
  final String name;
  final String accountNumber;
  final String bankName;

  RecipientModel({
    required this.name,
    required this.accountNumber,
    required this.bankName,
  });
}