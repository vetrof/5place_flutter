import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  print('API_BASE_URL: ${dotenv.env['API_BASE_URL']}');

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