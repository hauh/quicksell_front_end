import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:quicksell_app/models.dart';

Map<String, dynamic> apiEndpoints;

var headers = {
  'Content-Type': 'application/json; charset=utf-8',
};

Future<bool> connect() async {
  apiEndpoints = json.decode(await rootBundle.loadString('assets/urls.json'));
  final response = await http.get(apiEndpoints['info']);
  return (response.statusCode == 200);
}

Future<bool> authorize(String email, String password) async {
  final response = await http.post(
    apiEndpoints['auth'],
    body: jsonEncode({'username': email, 'password': password}),
    headers: headers,
  );
  if (response.statusCode != 201) return false;
  var token = json.decode(utf8.decode(response.bodyBytes))['token'];
  headers['Authorization'] = "Token $token";
  return true;
}

Future<List<Listing>> getListings(int page) async {
  final response = await http.get(
    apiEndpoints['listings'] + page.toString(),
    headers: headers,
  );

  if (response.statusCode == 200) {
    List<dynamic> decoded =
        json.decode(utf8.decode(response.bodyBytes))['results'];
    List<Listing> listings = [];
    decoded.forEach((element) => listings.add(Listing.fromJson(element)));
    return listings;
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception('Failed to load.');
  }
}
