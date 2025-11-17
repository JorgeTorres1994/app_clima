class FavoriteCity {
  final String name;
  final double lat;
  final double lon;

  const FavoriteCity(this.name, this.lat, this.lon);

  Map<String, dynamic> toMap() => {'name': name, 'lat': lat, 'lon': lon};
  static FavoriteCity fromMap(Map<String, dynamic> m) =>
      FavoriteCity(m['name'] as String, (m['lat'] as num).toDouble(), (m['lon'] as num).toDouble());

  String get id => '${lat}_${lon}';
}
