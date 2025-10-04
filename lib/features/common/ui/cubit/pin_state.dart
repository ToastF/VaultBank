import 'package:equatable/equatable.dart';

abstract class PinState extends Equatable {
  final String currentPin;
  const PinState({this.currentPin = ''});

  @override
  List<Object?> get props => [currentPin];
}

// State awal saat halaman baru dibuka
class PinInitial extends PinState {}

// State saat user memasukkan PIN
class PinInput extends PinState {
  const PinInput(String currentPin) : super(currentPin: currentPin);
}

// State saat PIN sedang diverifikasi (menampilkan loading)
class PinLoading extends PinState {
  const PinLoading(String currentPin) : super(currentPin: currentPin);
}

// State ketika verifikasi PIN berhasil
class PinSuccess extends PinState {
  const PinSuccess() : super(currentPin: '      '); // Pin penuh untuk visual
}

// State ketika verifikasi gagal (PIN salah atau error)
class PinFailure extends PinState {
  final String message;
  const PinFailure(this.message);

  @override
  List<Object?> get props => [message];
}
