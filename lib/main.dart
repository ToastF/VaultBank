import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaultbank/features/auth/ui/page/welcome_screen.dart';
import 'package:vaultbank/features/home/ui/page/home_screen.dart';
import 'package:vaultbank/features/home/ui/page/profile.dart';
import 'package:vaultbank/features/transfer/ui/pages/transfer_home_page.dart';
import './data/local_storage.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import './features/auth/ui/cubit/auth_cubit.dart';
import './core/util/navi_util.dart';
import 'features/auth/service/register_user.dart';
import './features/user/ui/cubit/user_cubit.dart';
import 'package:vaultbank/features/transfer/data/repositories/transfer_repository.dart';
import 'package:vaultbank/features/transfer/logic/transfer_cubit.dart';

void main() async {
  // Initialize Firebase and Isar
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.init();
  // Instantiate repositories or services for global provider
  final authRepo = AuthRepositoryImpl(FirebaseAuth.instance);
  final userRepo = UserRepositoryImpl(FirebaseFirestore.instance);
  final registerUser = RegisterUser(authRepo, userRepo);
  final transferRepo = FakeTransferRepository();
  runApp(
    // Multirepositoryprovider for dependency injection, 
    // A single instance of a repository can be used by its children widget 
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: userRepo),
        RepositoryProvider.value(value: registerUser),
        RepositoryProvider.value(value: transferRepo),
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
          BlocProvider(
            create: (context) => TransferCubit(
              transferRepository: transferRepo, 
              userRepository: userRepo, 
              userCubit: context.read<UserCubit>()),
              )
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
      // BlocListener (checks for state change)
      debugShowCheckedModeBanner: false,
      home: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // if user is authenticated, skip login/signup and go to HomeScreen
          if (state is AuthSuccess) {
            // uses cache first for UI, then syncs cache with cloud,
            // then start listening for cloud changes and cache those changes
            context.read<UserCubit>()..loadUser(state.auth.uid)..startUserListener(state.auth.uid);
            // go to HomeScreen, destroy previous pages
            NavigationHelper.goToAndRemoveAll(context, const NavBar());
            
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

// Navbar
class NavBar extends StatefulWidget{
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 1; // Default ke Home

  static final List<Widget> _widgetOptions = <Widget>[
    const TransferHomePage(), 
    HomeScreen(), 
    const ProfilePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( 
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, 
        selectedItemColor: Colors.blue, 
        onTap: _onItemTapped, 
      ),
    );
  }
}

/// Placeholder sementara untuk halaman Transfer.
class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Halaman Transfer'),
      ),
    );
  }
}
