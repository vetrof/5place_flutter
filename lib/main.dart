import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/places/state/places_controller.dart';
import 'features/places/data/places_repository.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PlacesRepository repository = PlacesRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlacesController(repository: repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '5Place',
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        home: MainScreen(),
      ),
    );
  }
}