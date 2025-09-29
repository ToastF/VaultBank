// Model ini akan dipakai untuk menyimpan nomor rekening orang lain
// yang difavoritkan (bookmarked)
class RecipientEntity {
  final String name;
  final String accountNumber;
  final String? alias;

  const RecipientEntity({
    required this.name,
    required this.accountNumber,
    this.alias,
  });
}
