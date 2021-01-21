import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:quicksell_app/models.dart';

Map<String, dynamic> apiEndpoints;

Future<bool> connect() async {
  apiEndpoints = json.decode(await rootBundle.loadString('assets/urls.json'));
  final response = await http.get(apiEndpoints['info']);
  return (response.statusCode == 200);
}

Future<List<Listing>> getListings(int page) async {
  final response = await http.get(
    apiEndpoints['listings'] + page.toString(),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
  );

  if (response.statusCode == 200) {
    List<dynamic> decoded =
        json.decode(utf8.decode(response.bodyBytes))['results'];
    List<Listing> listings = [];
    decoded.forEach((element) => listings.add(Listing.fromJson(element)));
    return listings;
  } else {
    throw Exception('Failed to load.');
  }
}
