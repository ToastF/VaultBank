import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/ui/cubit/auth_cubit.dart';
import 'features/auth/ui/page/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepo = AuthRepositoryImpl(FirebaseAuth.instance, FirebaseFirestore.instance);

  runApp(MyApp(authRepo: authRepo));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepo;
  const MyApp({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => AuthCubit(authRepo),
        child: const SignupScreen(),
      ),
    );
  }
}
