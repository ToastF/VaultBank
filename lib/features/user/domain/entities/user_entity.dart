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
  UserEntity copyWith({
    String? uid,
    String? username,
    String? email,
    String? notelp,
    double? balance,
    String? accountNumber,
    String? profileImagePath,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      notelp: notelp ?? this.notelp,
      balance: balance ?? this.balance,
      accountNumber: accountNumber ?? this.accountNumber,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
