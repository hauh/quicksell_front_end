part of navigation;

class Location {
  final double latitude;
  final double longitude;
  final String address;

  const Location(this.latitude, this.longitude, this.address);

  Location.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        address = json['address'];

  Map<String, dynamic> toDict() => {
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
