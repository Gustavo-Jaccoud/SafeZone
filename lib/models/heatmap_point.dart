class HeatmapPoint {
  final double latitude;
  final double longitude;
  final double weight;

  HeatmapPoint({
    required this.latitude,
    required this.longitude,
    this.weight = 1,
  });

  factory HeatmapPoint.fromJson(Map<String, dynamic> json) {
    return HeatmapPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      weight: (json['weight'] ?? 1).toDouble(),
    );
  }

  Map<String, dynamic> toGeoJsonFeature() {
    return {
      "type": "Feature",
      "properties": {
        "weight": weight,
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          longitude,
          latitude,
        ],
      },
    };
  }
}