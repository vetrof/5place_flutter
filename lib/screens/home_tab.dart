// screens/home_tab.dart
import 'package:five_place_app/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../widgets/place_card.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Place> places = Place.testPlaces; // Пока используем тестовые данные

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ближайшие места'),
      ),
      body: Column(
        children: [
          // Место для карты (пока просто заглушка)
          Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                'Здесь будет карта\n(добавим позже)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          // Список мест
          Expanded(
            child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return PlaceCard(
                  place: places[index],
                  onTap: () {
                    // Переход к деталям места
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailScreen(place: places[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}