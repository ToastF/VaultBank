// Model ini akan dipakai untuk menyimpan nomor rekening orang lain
// yang difavoritkan (bookmarked)
class RecipientModel {
  final String id;
  final String name;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  final String? bankLogoUrl;

  RecipientModel({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    this.bankLogoUrl,
  });
}