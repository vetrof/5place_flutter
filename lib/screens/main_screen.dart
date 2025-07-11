// screens/main_screen.dart
import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'favorites_tab.dart';
import 'random_tab.dart';
import 'search_tab.dart';
import 'about_tab.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Список всех вкладок
  final List<Widget> _tabs = [
    HomeTab(),
    RandomTab(),
    SearchTab(),
    FavoritesTab(),
    AboutTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex], // Показываем выбранную вкладку
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.shuffle), label: 'Случайные'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'О нас'),
        ],
      ),
    );
  }
}