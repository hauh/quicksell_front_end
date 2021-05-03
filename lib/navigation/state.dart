part of navigation;

class Navigation with ChangeNotifier {
  Location defaultLocation =
      Location(latitude: 55.7558, longitude: 37.6173, address: "Moscow");

  Location location =
      Location(latitude: 55.7558, longitude: 37.6173, address: "Moscow");

  String distanceBetween(Location dst) {
    double distance = Geolocator.distanceBetween(
        location.latitude!, location.longitude!, dst.latitude!, dst.longitude!);

    if (distance > 5000.0) {
      distance /= 1000;
      return "${distance.toStringAsFixed(0)} KM";
    }
    return "${distance.toStringAsFixed(0)} M";
  }

  Future<void> updateCoordinates() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      print("Service enabled");
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied)
        permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        var currentPosition = await Geolocator.getCurrentPosition();
        var currentAddress = await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude);
        location = Location(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
            address:
                "${currentAddress.first.locality}, ${currentAddress.first.street}, ${currentAddress.first.thoroughfare}");
        notifyListeners();
        return;
      }
    }
    location = defaultLocation;
    notifyListeners();
  }
}
