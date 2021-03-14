import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:quicksell_app/extensions.dart';

// The Kremlin
final defaultCoordinates = GeoCoordinates(55.7520, 37.6175);

void mapInit() => SdkContext.init(IsolateOrigin.main);

class MapView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late ValueNotifier<String> addressNotifier;
  late SearchEngine searchEngine;
  late HereMapController mapController;
  late GeoCoordinates currentCoordinates;

  @override
  void initState() {
    addressNotifier = ValueNotifier("Set your address");
    searchEngine = SearchEngine();
    currentCoordinates = defaultCoordinates;
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
      body: FutureBuilder<GeoCoordinates>(
        future: _determinePosition(),
        builder: (context, snapshot) => !snapshot.hasData
            ? Center(child: CircularProgressIndicator())
            : HereMap(onMapCreated: onMapCreated),
      ),
    );
  }

  Future<GeoCoordinates> _determinePosition() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied)
        permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        var currentPosition = await Geolocator.getCurrentPosition();

        currentCoordinates =
            GeoCoordinates(currentPosition.latitude, currentPosition.longitude);
      }
    }
    return currentCoordinates;
  }

  String addressString(Place place) {
    return "${place.address.city}, ${place.address.street}, ${place.address.houseNumOrName}";
  }

  void onMapCreated(HereMapController controller) {
    mapController = controller;
    controller.mapScene.loadSceneForMapScheme(
      MapScheme.normalDay,
      (error) {
        if (error != null)
          context.notify(error.toString());
        else {
          controller.camera.lookAtPointWithDistance(currentCoordinates, 8000);
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
