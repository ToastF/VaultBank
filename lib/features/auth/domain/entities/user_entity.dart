//User Model

class UserEntity {
  final String uid;
  final String email;
  final String pin; // transaction pin
  final String notelp;

  UserEntity({required this.uid, required this.email, required this.pin, required this.notelp});
}
