/// Класс для представления места/достопримечательности
class Place {
  // Уникальный идентификатор места
  final int id;

  // Название города, где находится место
  final String cityName;

  // Название места/достопримечательности
  final String name;

  // Геометрическая информация о месте (возможно, в формате WKT или GeoJSON)
  final String geom;

  // Описание места
  final String desc;

  // Расстояние до места (в километрах или милях)
  final double distance;

  // Список URL-адресов фотографий места
  final List<String> photos;

  // Географическая широта
  final double lat;

  // Географическая долгота
  final double lng;

  // Тип места (например, "ресторан", "музей", "парк" и т.д.)
  final String type;

  // Цена за посещение (может быть null для бесплатных мест)
  final double? price;

  // Валюта для цены (например, "RUB", "USD", "EUR")
  final String currency;

  /// Конструктор класса Place
  /// Все поля обязательны, кроме price (может быть null)
  Place({
    required this.id,
    required this.cityName,
    required this.name,
    required this.geom,
    required this.desc,
    required this.distance,
    required this.photos,
    required this.lat,
    required this.lng,
    required this.type,
    required this.price,
    required this.currency,
  });

  /// Фабричный метод для создания объекта Place из JSON
  /// Используется для десериализации данных, полученных из API
  factory Place.fromJson(Map<String, dynamic> json) {

    // Извлекаем объект с координатами из JSON
    final coords = json['coordinates'] ?? {};

    // За комментированные строки для отладки координат
    // print('[DEBUG] Raw coordinates: $coords');
    // print('[DEBUG] coords[lat]: ${coords['lat']} (type: ${coords['lat'].runtimeType})');
    // print('[DEBUG] coords[lng]: ${coords['lng']} (type: ${coords['lng'].runtimeType})');

    // Инициализируем координаты значениями по умолчанию
    double latitude = 0.0;
    double longitude = 0.0;

    // Проверяем, что координаты существуют в JSON и безопасно их извлекаем
    if (coords['lat'] != null && coords['lng'] != null) {
      // Преобразуем любое числовое значение в double
      latitude = (coords['lat'] as num).toDouble();
      longitude = (coords['lng'] as num).toDouble();
    }

    // Обрабатываем список фотографий
    List<String> photosList = [];
    if (json['photos'] != null) {
      // Проверяем, что photos действительно является списком
      if (json['photos'] is List) {
        // Преобразуем в список строк
        photosList = List<String>.from(json['photos']);
      }
    }

    // Создаем объект Place с данными из JSON
    final place = Place(
      // Используем значения по умолчанию, если поле отсутствует в JSON
      id: json['id'] ?? 0,
      cityName: json['cityName'] ?? '',
      name: json['name'] ?? '',
      geom: json['geom'] ?? '',
      desc: json['desc'] ?? '',
      // Безопасно преобразуем distance в double
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      photos: photosList,
      lat: latitude,
      lng: longitude,
      type: json['type'] ?? '',
      // Если price существует, преобразуем в double, иначе оставляем null
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'] ?? '',
    );

    // Отладочное сообщение для проверки созданного объекта
    print('[DEBUG] Создано место: ${place.name} с координатами (${place.lat}, ${place.lng})');

    return place;
  }
}