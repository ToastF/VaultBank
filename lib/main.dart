import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaultbank/features/auth/ui/page/welcome_screen.dart';
import 'package:vaultbank/features/recipient/UI/cubit/recipient_cubit.dart';
import 'package:vaultbank/features/recipient/data/repositories/recipient_repository_impl.dart';
import 'package:vaultbank/features/transaction_history/data/repositories/transaction_history_repo_impl.dart';
import 'package:vaultbank/features/transaction_history/ui/cubit/transaction_cubit.dart';
import 'package:vaultbank/features/transfer/data/repositories/transfer_repository_impl.dart';
import 'package:vaultbank/features/transfer/ui/cubits/transfer_cubit.dart';
import './data/local_storage.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import './features/auth/ui/cubit/auth_cubit.dart';
import './core/util/navi_util.dart';
import 'features/auth/service/register_user.dart';
import './features/user/ui/cubit/user_cubit.dart';
import 'features/home/ui/page/navbar/NavBar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Initialize Firebase and Isar
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.init();
  await initializeDateFormatting('id_ID', null);
  // Instantiate repositories or services for global provider
  final authRepo = AuthRepositoryImpl(FirebaseAuth.instance);
  final userRepo = UserRepositoryImpl(FirebaseFirestore.instance);
  final registerUser = RegisterUser(authRepo, userRepo);
  final recipientRepo = RecipientRepositoryImpl(FirebaseFirestore.instance);
  final transferRepo = TransferRepositoryImpl(FirebaseFirestore.instance);
  final transactionRepo = TransactionHistoryRepositoryImpl(
    FirebaseFirestore.instance,
  );

  runApp(
    // Multirepositoryprovider for dependency injection,
    // A single instance of a repository can be used by its children widget
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: userRepo),
        RepositoryProvider.value(value: registerUser),
        RepositoryProvider.value(value: recipientRepo),
        RepositoryProvider.value(value: transferRepo),
        RepositoryProvider.value(value: transactionRepo),
      ],
      // MultiBlockProvider, to nest multiple BlocProviders
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            // Cubit responsible for authentication, calls checkAuthStatus immediately
            // to check whether user is logged in or not
            create: (context) => AuthCubit.create(context)..checkAuthStatus(),
          ),
          BlocProvider(
            // Cubit responsible for user profile data
            create: (context) => UserCubit(userRepo),
          ),
          BlocProvider(create: (context) => RecipientCubit(recipientRepo)),
          BlocProvider(
            create:
                (context) => TransferCubit(
                  transferRepo: transferRepo,
                  userRepo: userRepo,
                  userCubit: context.read<UserCubit>(),
                ),
          ),
          BlocProvider(create: (context) => TransactionCubit(transactionRepo)),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

// First widget created at app start
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Default app font
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: const TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: const TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
          bodySmall: const TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
          titleSmall: TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // BlocListener (checks for state change)
      home: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // if user is authenticated, skip login/signup and go to HomeScreen
          if (state is AuthSuccess) {
            // data cache first for UI, then syncs cache with cloud,
            // then start listening for cloud changes and cache those changes
            context.read<UserCubit>()
              ..loadUser(state.auth.uid)
              ..startUserListener(state.auth.uid);

            context.read<RecipientCubit>()
              ..loadRecipients(state.auth.uid)
              ..startRecipientListener(state.auth.uid);

            context.read<TransactionCubit>()
              ..loadTransactions(state.auth.uid)
              ..startTransactionListener(state.auth.uid);

            // go to HomeScreen, destroy previous pages
            NavigationHelper.goToAndRemoveAll(context, NavBar());

            // if not logged in, go to welcome screen
          } else if (state is AuthLoggedOut) {
            NavigationHelper.goToAndRemoveAll(context, WelcomeScreen());
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // could be a splash/loading screen until listener redirects
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
