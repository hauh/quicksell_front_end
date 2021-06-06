part of navigation;

class Geo with ChangeNotifier {
  static const defaultLocation = Location(55.751426, 37.618879, "The Kremlin");
  static const defaultZoom = 13.0;

  late Location location = defaultLocation;

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
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<dynamic> showMap(
    BuildContext context, {
    List<Location> points = const [],
    Location? focus,
  }) {
    var markers = points.map((point) => SimpleMarker(point)).toList();
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FutureBuilder(
          future: updateLocation(),
          builder: (context, snapshot) => snapshot.hasData
              ? MapView(focus ?? location, markers)
              : Scaffold(
                  appBar: AppBar(title: Text("Loading map...")),
                  body: Center(child: CircularProgressIndicator()),
                ),
        ),
      ),
    );
  }
}

class SimpleMarker extends Marker {
  SimpleMarker(
    location, {
    width = 70.0,
    height = 70.0,
    widget = const Icon(Icons.pin_drop, color: Colors.purple),
  }) : super(
          width: width,
          height: height,
          point: LatLng(location.latitude, location.longitude),
          builder: (_) => widget,
        );
}

class MapView extends StatefulWidget {
  final Location location;
  final List<SimpleMarker> markers;
  MapView(this.location, this.markers);

  @override
  State<StatefulWidget> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late Location location;

  @override
  void initState() {
    location = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(location),
          ),
          title: Text(location.address)),
      body: FlutterMap(
        options: MapOptions(
          zoom: Geo.defaultZoom,
          center: LatLng(widget.location.latitude, widget.location.longitude),
          onTap: (LatLng point) async {
            await onMapTap(context, point);
          },
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(markers: [SimpleMarker(location)]),
          MarkerLayerOptions(markers: widget.markers),
        ],
      ),
    );
  }

  Future<void> onMapTap(BuildContext context, LatLng point) async {
    var fetchedAddresses =
        await placemarkFromCoordinates(point.latitude, point.longitude);
    var address = fetchedAddresses.first;
    var newLocation = Location(
      point.latitude,
      point.longitude,
      "${address.locality}, ${address.street}, ${address.thoroughfare}",
    );
    setState(() => location = newLocation);
  }
}
