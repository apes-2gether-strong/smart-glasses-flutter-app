import 'package:latlong2/latlong.dart';

class LocationData {
  final double latitude;
  final double longitude;
  static const isiLocation = LatLng(36.8613660882078, 10.18895141238018);

  LocationData(this.latitude, this.longitude);

  @override
  String toString() {
    return 'LocationData{latitude: $latitude, longitude: $longitude}';
  }

  static LocationData fromPayload(String payload) {
    // Assuming the payload is a string in the format "latitude,longitude"
    List<String> parts = payload.split(',');

    if (parts.length == 2) {
      try {
        double latitude = double.parse(parts[0]);
        double longitude = double.parse(parts[1]);

        return LocationData(latitude, longitude);
      } catch (e) {
        print('Error parsing payload: $e');
      }
    }

    // Return a default location if parsing fails
    return LocationData(isiLocation.latitude, isiLocation.longitude);
  }
}
