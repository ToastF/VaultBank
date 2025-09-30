import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaultbank/features/auth/ui/page/welcome_screen.dart';
import 'package:vaultbank/features/home/ui/page/home_screen.dart';
import 'package:vaultbank/features/home/ui/page/profile.dart';
import 'package:vaultbank/features/home/ui/page/splash_screen.dart';
import './data/local_storage.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import './features/auth/ui/cubit/auth_cubit.dart';
import './core/util/navi_util.dart';
import 'features/auth/service/register_user.dart';
import './features/user/ui/cubit/user_cubit.dart';
// 🆕 Import DummyTestPage untuk testing PIN
import 'package:vaultbank/features/common/dummy_test_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialize Firebase and Isar
  Future<void> _initApp() async {
    debugPrint('🚀 [Main] Initializing Firebase...');
    await Firebase.initializeApp();
    debugPrint('💾 [Main] Initializing Local Storage...');
    await LocalStorage.init();
    debugPrint('✅ [Main] Initialization complete!');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // show indicator WHILE initializing Firebase + storage
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Init error: ${snapshot.error}')),
            );
          } else {
            // Once init done → go into your real Bloc setup
            return AppProviders();
          }
        },
      ),
    );
  }
}

// Extracted your MultiRepositoryProvider + MultiBlocProvider
class AppProviders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('🏗️ [Main] Building AppProviders...');
    
    // Instantiate repositories or services for global provider
    final authRepo = AuthRepositoryImpl(FirebaseAuth.instance);
    final userRepo = UserRepositoryImpl(FirebaseFirestore.instance);
    final registerUser = RegisterUser(authRepo, userRepo);

    // Multirepositoryprovider for dependency injection,
    // A single instance of a repository can be used by its children widget
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: userRepo),
        RepositoryProvider.value(value: registerUser),
      ],
      // MultiBlockProvider, to nest multiple BlocProviders
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            // Cubit responsible for authentication, calls checkAuthStatus immediately
            // to check whether user is logged in or not
            create: (context) {
              debugPrint('🔐 [Main] Creating AuthCubit...');
              return AuthCubit.create(context)..checkAuthStatus();
            },
          ),
          // Cubit responsible for user profile data
          BlocProvider(
            create: (context) {
              debugPrint('👤 [Main] Creating UserCubit...');
              return UserCubit(userRepo);
            },
          ),
        ],
        child: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        debugPrint('🚪 [AuthGate] State changed: ${state.runtimeType}');
        
        // if user is authenticated, skip login/signup and go to HomeScreen
        if (state is AuthSuccess) {
          debugPrint('✅ [AuthGate] User authenticated: ${state.auth.uid}');
          debugPrint('📥 [AuthGate] Loading user data...');
          
          // uses cache first for UI, then syncs cache with cloud,
          // then start listening for cloud changes and cache those changes
          context.read<UserCubit>()
            ..loadUser(state.auth.uid)
            ..startUserListener(state.auth.uid);
          
          debugPrint('🏠 [AuthGate] Navigating to NavBar...');
          // go to HomeScreen, destroy previous pages
          NavigationHelper.goToAndRemoveAll(context, const NavBar());
        } else if (state is AuthLoggedOut) {
          debugPrint('🚪 [AuthGate] User logged out, going to WelcomeScreen');
          // if not logged in, go to welcome screen
          NavigationHelper.goToAndRemoveAll(context, WelcomeScreen());
        }
      },
      child: const Scaffold(body: Center(child: SplashScreen())),
    );
  }
}

// Navbar
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 1; // Default ke Home (index 1)

  // 🆕 UPDATED: Ganti HomeScreen dengan DummyTestPage untuk testing
  static final List<Widget> _widgetOptions = <Widget>[
    const DummyTestPage(), // 🔄 Changed from HomeScreen() to DummyTestPage()
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    debugPrint('📱 [NavBar] Tab selected: $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint('🧭 [NavBar] NavBar initialized');
    
    // 🔍 Debug: Cek state UserCubit saat NavBar dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<UserCubit>().state;
      debugPrint('👤 [NavBar] UserCubit state saat NavBar dibuat: ${userState.runtimeType}');
      
      if (userState is UserLoaded) {
        debugPrint('✅ [NavBar] User sudah loaded: ${userState.user.uid}');
      } else if (userState is UserLoading) {
        debugPrint('⏳ [NavBar] User masih loading...');
      } else {
        debugPrint('⚠️ [NavBar] User state: ${userState.runtimeType}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home', // Label tetap "Home" meski isinya DummyTestPage
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