class BankModel {
  final String name;
  final String code;
  final String? logoUrl; //Ini akan dipakai untuk tampilin gambar logo banknya
  // TODO: Kirimkan aku feedback apakah ini tetap dibutuhkan

  BankModel({
    required this.name,
    required this.code,
    this.logoUrl,
  });
}
