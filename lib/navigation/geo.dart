part of navigation;

class Geo with ChangeNotifier {
  static const defaultLocation = Location.undefined();
  static const defaultZoom = 13.0;
  static const defaultRotation = 1;

  Location location = defaultLocation;

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

  static Future<Location> coordinatesToLocation(double lat, double long) async {
    var addresses = await placemarkFromCoordinates(lat, long);
    return Location(lat, long, addresses.first);
  }

  Future<Location> updateLocation() async {
    if (await checkPermissions()) {
      var pos = await Geolocator.getCurrentPosition();
      location = await coordinatesToLocation(pos.latitude, pos.longitude);
      notifyListeners();
    }
    return location;
  }

  Future<dynamic> showMap(
    BuildContext context, {
    List<Location>? points,
    Location? focus,
  }) {
    focus ??= location;
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => focus != defaultLocation
            ? MapView(focus!, points)
            : FutureBuilder(
                future: updateLocation(),
                builder: (context, snapshot) => snapshot.hasData
                    ? MapView(location, points)
                    : Scaffold(
                        appBar:
                            AppBar(title: Text("Fetching your position...")),
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
  final Location focus;
  final List<SimpleMarker>? markers;

  MapView(this.focus, points)
      : markers =
            points?.map<SimpleMarker>((point) => SimpleMarker(point)).toList();

  @override
  State<StatefulWidget> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final controller = MapController();
  late Location focus;

  @override
  void initState() {
    focus = widget.focus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(focus),
        ),
        title: FittedBox(
          clipBehavior: Clip.antiAlias,
          child: Text(focus.address),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.navigation_sharp),
            tooltip: "Go to your position",
            onPressed: locateUser,
          )
        ],
      ),
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(
          zoom: Geo.defaultZoom,
          center: LatLng(focus.latitude, focus.longitude),
          onLongPress: (point) async => focusMap(
            await Geo.coordinatesToLocation(point.latitude, point.longitude),
          ),
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(markers: [SimpleMarker(focus)]),
          if (widget.markers != null && widget.markers!.isNotEmpty)
            MarkerLayerOptions(markers: widget.markers!),
        ],
      ),
    );
  }

  void focusMap(Location nextLocation) {
    setState(() => focus = nextLocation);
    controller.move(
      LatLng(nextLocation.latitude, nextLocation.longitude),
      Geo.defaultZoom,
    );
    controller.rotate(0.0);
  }

  void locateUser() {
    context.waiting("Fetching your position...");
    context.geo
        .updateLocation()
        .then((location) => focusMap(location))
        .whenComplete(() => context.stopWaiting())
        .catchError((err) => context.notify(err.toString()));
  }
}
