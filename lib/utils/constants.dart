import 'package:flutter_dotenv/flutter_dotenv.dart';


class AppConstants {
  static const String appName = '5Place';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = 'http://192.168.0.13:8080';

  // Алматы координаты по умолчанию
  static const double defaultLat = 43.2567;
  static const double defaultLng = 76.9286;

  // Контактная информация
  static const String supportEmail = 'support@5place.app';
  static const String website = 'www.5place.app';
}