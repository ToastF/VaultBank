import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/auth/service/register_user.dart';
import 'features/auth/ui/page/Welcome_screen.dart';
import 'features/auth/data/local/access_code_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AccessCodeStorage.init();

  final authRepo = AuthRepositoryImpl(FirebaseAuth.instance);
  final userRepo = UserRepositoryImpl(FirebaseFirestore.instance,);
  final registerUser = RegisterUser(authRepo,userRepo);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: userRepo),
        RepositoryProvider.value(value: registerUser),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomeScreen(),
    );
  }
}
