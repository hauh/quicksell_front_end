part of navigation;

const defaultLocation = Location(55.751426, 37.618879, "The Kremlin");

class Geo with ChangeNotifier {
  late Location location;

  Future<void> init() async {
    await updateLocation();
  }

  double distanceTo(Location dst) {
    return Geolocator.distanceBetween(
        location.latitude, location.longitude, dst.latitude, dst.longitude);
  }

  Future<bool> checkPermissions() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied)
        permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) return true;
    }
    return false;
  }

  Future<void> updateLocation() async {
    if (await checkPermissions()) {
      var position = await Geolocator.getCurrentPosition();
      var fetchedAddresses =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      var address = fetchedAddresses.first;
      location = Location(
        position.latitude,
        position.longitude,
        "${address.locality}, ${address.street}, ${address.thoroughfare}",
      );
    } else {
      location = defaultLocation;
    }
    notifyListeners();
  }
}
