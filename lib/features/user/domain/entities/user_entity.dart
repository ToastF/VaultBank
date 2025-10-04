//User Model

class UserEntity {
  final String username;
  final String uid;
  final String email;
  final String? notelp;
  final double balance;
  final String accountNumber;
  final String? profileImagePath;

  UserEntity({
    required this.username,
    required this.uid,
    required this.email,
    this.notelp,
    required this.balance,
    required this.accountNumber,
    this.profileImagePath,
  });
}
