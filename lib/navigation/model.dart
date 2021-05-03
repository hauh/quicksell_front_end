part of navigation;

class Location {
  final double? latitude;
  final double? longitude;
  final String? address;

  const Location({this.latitude, this.longitude, this.address});

  Location.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        address = json['address'];
}