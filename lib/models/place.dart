// models/place.dart
class Place {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final double latitude;
  final double longitude;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });

  // Пока просто создаем тестовые данные
  static List<Place> testPlaces = [
    Place(
      id: '1',
      name: 'Кафе "Уютное"',
      description: 'Прекрасное место для завтрака',
      imageUrl: 'https://example.com/cafe1.jpg',
      rating: 4.5,
      latitude: 51.128207,
      longitude: 71.430411,
    ),
    Place(
      id: '2',
      name: 'Парк "Зеленый"',
      description: 'Отличное место для прогулок',
      imageUrl: 'https://example.com/park1.jpg',
      rating: 4.2,
      latitude: 51.129207,
      longitude: 71.431411,
    ),
  ];
}