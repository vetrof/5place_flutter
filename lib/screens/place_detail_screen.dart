// screens/place_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/place.dart';


class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailScreen({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Случайные места')),
      body: Center(
        child: Text('Здесь будут случайные места'),
      ),
    );
  }
}