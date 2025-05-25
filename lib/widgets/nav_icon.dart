import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;

  const NavIcon({
    Key? key,
    required this.icon,
    required this.index,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 24,
        color: isSelected ? AppTheme.primaryColor : Colors.grey[500],
      ),
    );
  }
}