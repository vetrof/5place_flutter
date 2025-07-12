import 'package:flutter/material.dart';
import '../cervice/place_api_cervice.dart';
import '../models/place.dart';
import '../widgets/place_card.dart';
import 'place_detail_screen.dart';


class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Place> places = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlacesFromServer();
  }

  Future<void> loadPlacesFromServer() async {
    setState(() {
      isLoading = true;
    });

    // 👇 Поставь реальные координаты, если есть
    final lat = 51.16203;
    final lng = 71.40877;

    final loadedPlaces = await PlacesApiService.getNearbyPlaces(lat, lng);

    setState(() {
      places = loadedPlaces;
      isLoading = false;
    });
  }

  Future<void> refreshPlaces() async {
    await loadPlacesFromServer();
  }

  void toggleFavorite(Place place) async {
    final success = await PlacesApiService.toggleFavorite(place.id, place.isFavorite);

    if (success) {
      setState(() {
        place.isFavorite = !place.isFavorite;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при обновлении избранного')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Карта-заглушка
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
          // Список карточек с pull-to-refresh
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: refreshPlaces,
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return PlaceCard(
                    place: place,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlaceDetailScreen(place: place),
                        ),
                      );
                    },
                    onToggleFavorite: () => toggleFavorite(place),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
