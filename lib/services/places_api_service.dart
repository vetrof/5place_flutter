import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import '../utils/constants.dart';

class PlacesApiService {
  static Future<List<Place>> getNearbyPlaces(double lat, double lng) async {
    print('[DEBUG] PlacesApiService.getNearbyPlaces вызван');

    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/v1/place/near?lat=$lat&long=$lng');
      print('[DEBUG] URL запроса: $url');

      final response = await http.get(url);

      print('[DEBUG] Ответ получен: ${response.statusCode}');
      print('[DEBUG] Тело ответа: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        final List<dynamic> jsonData = jsonBody['data'] ?? [];

        print('[DEBUG] Количество элементов в data: ${jsonData.length}');

        // Выводим первый элемент для проверки структуры
        if (jsonData.isNotEmpty) {
          print('[DEBUG] Первый элемент: ${jsonData[0]}');
          print('[DEBUG] Координаты первого элемента: ${jsonData[0]['coordinates']}');
        }

        return jsonData.map((json) => Place.fromJson(json)).toList();
      }

      print('[DEBUG] Ответ не 200: ${response.statusCode}');
      return [];
    } catch (e) {
      print('[ERROR] Ошибка загрузки мест: $e');
      return [];
    }
  }
}