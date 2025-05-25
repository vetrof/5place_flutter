import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import '../utils/constants.dart';

class PlacesApiService {
  static Future<List<Place>> getNearbyPlaces(double lat, double lng) async {
    try {
      final url = Uri.parse(
          '${AppConstants.apiBaseUrl}/near_place?lat=$lat&long=$lng'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Place.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Ошибка загрузки мест: $e');
      return [];
    }
  }
}