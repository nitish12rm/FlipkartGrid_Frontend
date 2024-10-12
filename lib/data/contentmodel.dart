import 'dart:convert';
import 'dart:ffi';

class GeoResponse {
  Coordinates? coordinates;
  double? zoom;
  bool? polygon;
  Area? area;

  GeoResponse({
     this.coordinates,
     this.zoom,
     this.polygon,
     this.area,
  });

  // Convert JSON to GeoResponse
  factory GeoResponse.fromJson(Map<String, dynamic> json) {
    return GeoResponse(
      coordinates: Coordinates.fromJson(json['coordinates']),
      zoom: double.parse(json['zoom'].toString()).toDouble(), // Convert to int
      polygon: json['polygon'] == true, // Ensure boolean
      area: Area.fromJson(json['area']),
    );
  }

  // Convert GeoResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'coordinates': coordinates!.toJson(),
      'zoom': zoom,
      'polygon': polygon,
      'area': area!.toJson(),
    };
  }
}

class Coordinates {
  String lat;
  String long;

  Coordinates({
    required this.lat,
    required this.long,
  });

  // Convert JSON to Coordinates
  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat'],
      long: json['long'],
    );
  }

  // Convert Coordinates to JSON
  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }
}

class Area {
  Coordinates center;
  String spread;

  Area({
    required this.center,
    required this.spread,
  });

  // Convert JSON to Area
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      center: Coordinates.fromJson(json['center']),
      spread: json['spread'],
    );
  }

  // Convert Area to JSON
  Map<String, dynamic> toJson() {
    return {
      'center': center.toJson(),
      'spread': spread,
    };
  }
}
