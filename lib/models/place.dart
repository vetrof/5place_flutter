class Place {
  final int id;
  final String cityName;
  final String name;
  final String geom;
  final String desc;
  final double distance;
  final List<String> photo;

  Place({
    required this.id,
    required this.cityName,
    required this.name,
    required this.geom,
    required this.desc,
    required this.distance,
    required this.photo,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['ID'],
      cityName: json['CityName'],
      name: json['Name'],
      geom: json['Geom'],
      desc: json['Desc'],
      distance: json['Distance'].toDouble(),
      photo: List<String>.from(json['photo']),
    );
  }
}