import 'package:flutter/material.dart';
import 'package:vaultbank/features/home/ui/page/home/home_screen.dart';
import 'package:vaultbank/features/home/ui/page/profile/profile.dart';
import 'package:vaultbank/features/transfer/ui/pages/transfer_home_page.dart';

// Navbar
class NavBar extends StatefulWidget {
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
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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
