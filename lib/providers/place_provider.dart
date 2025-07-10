import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceProvider with ChangeNotifier {
  List<Place> _places = [];
  bool _isLoading = false;

  List<Place> get allPlaces => _places;

  List<Place> get favoritePlaces => _places.where((p) => p.isFavorite).toList();

  bool get isLoading => _isLoading;

  Future<void> fetchPlacesFromBackend() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: сюда вставим запрос к API
      await Future.delayed(Duration(seconds: 1)); // Мокаем задержку

      // Пример данных, которые можно будет убрать:
      _places = [
        Place(
          id: 1,
          cityName: 'Алматы',
          name: 'Горячий источник',
          geom: '',
          desc: 'Описание места',
          distance: 2.5,
          photos: ['https://example.com/photo1.jpg'],
          lat: 51.0,
          lng: 71.0,
          type: 'park',
          price: null,
          currency: 'KZT',
          isFavorite: false,
        ),
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(int id) {
    final index = _places.indexWhere((p) => p.id == id);
    if (index != -1) {
      _places[index] = Place(
        id: _places[index].id,
        cityName: _places[index].cityName,
        name: _places[index].name,
        geom: _places[index].geom,
        desc: _places[index].desc,
        distance: _places[index].distance,
        photos: _places[index].photos,
        lat: _places[index].lat,
        lng: _places[index].lng,
        type: _places[index].type,
        price: _places[index].price,
        currency: _places[index].currency,
        isFavorite: !_places[index].isFavorite,
      );
      notifyListeners();
    }
  }
}