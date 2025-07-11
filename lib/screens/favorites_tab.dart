// screens/favorites_tab.dart
import 'package:flutter/material.dart';

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Избранное')),
      body: Center(
        child: Text('Здесь будут избранные места'),
      ),
    );
  }
}
