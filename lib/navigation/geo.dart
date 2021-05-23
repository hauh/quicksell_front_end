part of navigation;

class Geo with ChangeNotifier {
  static const defaultLocation = Location(55.751426, 37.618879, "The Kremlin");
  static const defaultZoom = 13.0;

  late Location location = defaultLocation;
  late Location lastTappedLocation = defaultLocation;

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
    } // TODO: Request user to enable location services
    return false;
  }

  Future<bool> updateLocation() async {
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
      return false;
    }
    notifyListeners();
    return true;
  }

  Widget getMap(BuildContext context, {List<SimpleMarker> markers = const [], Location? focus}) {
    return FutureBuilder(
      future: updateLocation(),
      builder: (context, snapshot) => snapshot.hasData ? FlutterMap(
        options: MapOptions(
          zoom: defaultZoom,
          center: focus == null ? LatLng(location.latitude, location.longitude) : LatLng(focus.latitude, focus.longitude),
          onTap: (LatLng point) async {
            await _onMapTap(context, point);
          },
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
          ),
          MarkerLayerOptions(
            markers: List<Marker>.generate(
              markers.length,
              (index) => Marker(
                width: markers[index].width,
                height: markers[index].height,
                point: LatLng(markers[index].point.latitude, markers[index].point.longitude),
                builder: (cxt) => markers[index].widget
              )
            ),
          ),
        ],
      ) : Container(child: Center(child: CircularProgressIndicator()))
    );
  }

  Future<void> _onMapTap(BuildContext context, LatLng point) async {
    var fetchedAddresses = await placemarkFromCoordinates(
      point.latitude, point.longitude
    );
    var address = fetchedAddresses.first;
    lastTappedLocation = Location(
      point.latitude,
      point.longitude,
      "${address.locality}, ${address.street}, ${address.thoroughfare}"
    );
  }
}
