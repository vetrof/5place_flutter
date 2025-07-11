import 'package:five_place_app/theme.dart';
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(FivePlaceApp());
}


class FivePlaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5Place',
      theme: AppTheme.lightTheme,
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}