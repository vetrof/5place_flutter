class Place {
  final int id;
  final String cityName;
  final String name;
  final String geom;
  final String desc;
  final double distance;
  final List<String> photos;
  final double lat;
  final double lng;
  final String type;
  final double? price;
  final String currency;

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

  factory Place.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] ?? {};

    print('[DEBUG] Raw coordinates: $coords');
    print('[DEBUG] coords[lat]: ${coords['lat']} (type: ${coords['lat'].runtimeType})');
    print('[DEBUG] coords[lng]: ${coords['lng']} (type: ${coords['lng'].runtimeType})');

    // Получаем координаты
    double latitude = 0.0;
    double longitude = 0.0;

    if (coords['lat'] != null && coords['lng'] != null) {
      latitude = (coords['lat'] as num).toDouble();
      longitude = (coords['lng'] as num).toDouble();
    }

    // Обработка фотографий
    List<String> photosList = [];
    if (json['photos'] != null) {
      if (json['photos'] is List) {
        photosList = List<String>.from(json['photos']);
      }
    }

    final place = Place(
      id: json['id'] ?? 0,
      cityName: json['cityName'] ?? '',
      name: json['name'] ?? '',
      geom: json['geom'] ?? '',
      desc: json['desc'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      photos: photosList,
      lat: latitude,
      lng: longitude,
      type: json['type'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'] ?? '',
    );

    print('[DEBUG] Создано место: ${place.name} с координатами (${place.lat}, ${place.lng})');

    return place;
  }
}