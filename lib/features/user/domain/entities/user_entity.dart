//User Model

class UserEntity {
  final String username;
  final String uid;
  final String email;
  final String? notelp;
  final double balance;

  UserEntity({
    required this.username,
    required this.uid,
    required this.email,
    this.notelp,
    required this.balance,
  });
}
