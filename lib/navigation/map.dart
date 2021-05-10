part of navigation;

class MapView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late ValueNotifier<String> addressNotifier;
  late SearchEngine searchEngine;
  late HereMapController mapController;

  @override
  void initState() {
    addressNotifier = ValueNotifier("Set your address");
    searchEngine = SearchEngine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<String>(
          valueListenable: addressNotifier,
          builder: (context, address, _) => Text(address),
        ),
      ),
      body: HereMap(onMapCreated: onMapCreated),
    );
  }

  String addressString(Place place) {
    return "${place.address.city}, ${place.address.street}, ${place.address.houseNumOrName}";
  }

  void onMapCreated(HereMapController controller) {
    var curLocation = context.geo.location;
    var geo = GeoCoordinates(curLocation.latitude, curLocation.longitude);
    mapController = controller;
    controller.mapScene.loadSceneForMapScheme(
      MapScheme.normalDay,
      (error) {
        if (error != null)
          context.notify(error.toString());
        else {
          controller.camera.lookAtPointWithDistance(geo, 8000);
          controller.gestures.disableDefaultAction(GestureType.doubleTap);
          controller.gestures.doubleTapListener = DoubleTapListener.fromLambdas(
            lambda_onDoubleTap: (point) => searchEngine.searchByCoordinates(
              controller.viewToGeoCoordinates(point),
              SearchOptions(LanguageCode.ruRu, 1),
              (error, result) => error != null
                  ? context.notify(error.toString())
                  : addressNotifier.value = addressString(result[0]),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    searchEngine.release();
    mapController.release();
    addressNotifier.dispose();
    super.dispose();
  }
}
