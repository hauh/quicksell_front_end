part of navigation;

class Location {
  final double latitude;
  final double longitude;
  final String address;

  const Location.undefined()
      : latitude = 55.751426,
        longitude = 37.618879,
        address = "The Kremlin";

  Location(double latitude, double longitude, Placemark placemark)
      : latitude = latitude,
        longitude = longitude,
        address = [
          placemark.locality,
          placemark.thoroughfare ?? placemark.street,
          placemark.name
        ].where((part) => part != null && part.isNotEmpty).toList().join(', ');

  Location.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        address = json['address'];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      };

  @override
  String toString() => "lat: $latitude, lng: $longitude, addr: $address";

  @override
  bool operator ==(Object rhs) =>
      rhs is Location && rhs.latitude == latitude && rhs.longitude == longitude;
}
