part of navigation;

class Location {
  final double latitude;
  final double longitude;
  final String address;

  const Location(this.latitude, this.longitude, this.address);

  Location.fromJson(Map<String, dynamic> json)
      : latitude = double.parse(json['coordinates'].split(',')[0]),
        longitude = double.parse(json['coordinates'].split(',')[1]),
        address = json['address'];

  Map<String, dynamic> toDict() => {
        'coordinates': "$latitude, $longitude",
        'address': address,
      };

  @override
  String toString() => "lat: $latitude, lng: $longitude, addr: $address";

  @override
  bool operator ==(Object rhs) =>
      rhs is Location && rhs.latitude == latitude && rhs.longitude == longitude;
}

class SimpleMarker {
  double width;
  double height;
  Widget widget;

  final Location point;

  SimpleMarker(this.point, this.widget, {this.width = 50.0, this.height = 50.0});
}
