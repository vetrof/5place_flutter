// models/place.dart
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

  bool isFavorite;

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
    required this.isFavorite,
  });

  // // 📦 Моки для теста
  // static List<Place> testPlaces = [
  //   Place(
  //     id: 1,
  //     cityName: 'Астана',
  //     name: 'Кафе "Уютное"',
  //     geom: '',
  //     desc: 'Прекрасное место для завтрака',
  //     distance: 2.5,
  //     photos: [
  //       'https://img1.akspic.ru/previews/1/6/0/6/7/176061/176061-yablochnyj_pejzazh-yabloko-illustracia-prirodnyj_landshaft-purpur-500x.jpg'
  //     ],
  //     lat: 51.128207,
  //     lng: 71.430411,
  //     type: 'кафе',
  //     price: 1500,
  //     currency: 'KZT',
  //     isFavorite: false
  //   ),
  //   Place(
  //     id: 2,
  //     cityName: 'Астана',
  //     name: 'Парк "Зелёный"',
  //     geom: '',
  //     desc: 'Отличное место для прогулок',
  //     distance: 1.2,
  //     photos: [
  //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGL9RC7RwT5OBzNhN86NZ3aoOrf17qcI8j5w&s'
  //     ],
  //     lat: 51.129207,
  //     lng: 71.431411,
  //     type: 'парк',
  //     price: 0,
  //     currency: 'KZT',
  //     isFavorite: true
  //   ),
  //   Place(
  //     id: 3,
  //     cityName: 'Астана',
  //     name: 'Музей истории',
  //     geom: '',
  //     desc: 'Погружаемся в прошлое',
  //     distance: 3.1,
  //     photos: ['https://example.com/museum.jpg'],
  //     lat: 51.130207,
  //     lng: 71.432411,
  //     type: 'музей',
  //     price: 1000,
  //     currency: 'KZT',
  //     isFavorite: false
  //   ),
  //   Place(
  //     id: 4,
  //     cityName: 'Астана',
  //     name: 'Ресторан "Шашлычок"',
  //     geom: '',
  //     desc: 'Вкуснейшие блюда на углях',
  //     distance: 0.8,
  //     photos: ['https://example.com/restaurant.jpg'],
  //     lat: 51.131207,
  //     lng: 71.433411,
  //     type: 'ресторан',
  //     price: 3000,
  //     currency: 'KZT',
  //     isFavorite: false
  //   ),
  //   Place(
  //     id: 5,
  //     cityName: 'Астана',
  //     name: 'Центральный парк',
  //     geom: '',
  //     desc: 'Простор и природа в центре города',
  //     distance: 2.0,
  //     photos: ['https://example.com/central_park.jpg'],
  //     lat: 51.132207,
  //     lng: 71.434411,
  //     type: 'парк',
  //     price: 0,
  //     currency: 'KZT',
  //     isFavorite: false
  //   ),
  // ];

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
      isFavorite: json['isFavorite'] ?? false,
    );

    // Отладочное сообщение для проверки созданного объекта
    print('[DEBUG] Создано место: ${place.name} с координатами (${place.lat}, ${place.lng})');

    return place;
  }

}
