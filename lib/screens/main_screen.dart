import 'package:flutter/material.dart';
import '../widgets/nav_icon.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import 'places/places_list_screen.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    PlacesListScreen(),
    FavoritesScreen(),
    HistoryScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.place,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey[500],
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: NavIcon(icon: Icons.home, index: 0, selectedIndex: _selectedIndex),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: NavIcon(icon: Icons.favorite, index: 1, selectedIndex: _selectedIndex),
              label: 'Избранное',
            ),
            BottomNavigationBarItem(
              icon: NavIcon(icon: Icons.history, index: 2, selectedIndex: _selectedIndex),
              label: 'История',
            ),
            BottomNavigationBarItem(
              icon: NavIcon(icon: Icons.info, index: 3, selectedIndex: _selectedIndex),
              label: 'О приложении',
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}