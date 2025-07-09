import 'package:flutter_dotenv/flutter_dotenv.dart';


class AppConstants {
  static const String appName = '5Place';
  static const String appVersion = '1.0.0';
  // static const String apiBaseUrl = 'http://10.0.3.2:8080';
  static const String apiBaseUrl = 'https://lovely-funny-cougar.ngrok-free.app';

  // Алматы координаты по умолчанию
  static const double defaultLat = 43.2567;
  static const double defaultLng = 76.9286;

  // Контактная информация
  static const String supportEmail = 'support@5place.app';
  static const String website = 'www.5place.app';

  static const String login = 'testuser';
  static const String password = 'password123';

  static const String jwtToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6InRlc3R1c2VyIiwiZW1haWwiOiJ0ZXN0QGV4YW1wbGUuY29tIiwiZXhwIjoxNzUyMTY4NDA1LCJpYXQiOjE3NTIwODIwMDV9.LsGFu_PIKT4ZgSswukRK5rAOBxJvId-sxIu6WA1N0ps';
}