import 'dart:convert' show json, jsonEncode, utf8;

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:quicksell_app/models.dart';

class API extends http.BaseClient {
  API._();
  static final _instance = API._();
  factory API() => API._instance;

  final _client = http.Client();
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  Map<String, dynamic> _endpoints;
  Map<String, dynamic> _categories;
  Map<String, dynamic> get categories => _categories;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  Future<bool> init() async {
    final loadedUrls = await rootBundle.loadString('assets/urls.json');
    _endpoints = json.decode(loadedUrls);
    final response = await get(_endpoints['info']);
    if (response.statusCode != 200) return false;
    _categories = _decode(response)['categories'];
    return true;
  }

  Map<String, dynamic> _decode(http.Response response) =>
      json.decode(utf8.decode(response.bodyBytes));

  Future<void> authorize(String email, String password) async {
    final response = await post(
      _endpoints['auth'],
      body: jsonEncode({'username': email, 'password': password}),
    );
    if (response.statusCode != 200) throw Exception("Authorization failed.");
    _headers['Authorization'] = "Token ${_decode(response)['token']}";
  }

  Future<User> authenticate(String email, String password) async {
    await authorize(email, password);
    final response = await get(_endpoints['users']);
    if (response.statusCode != 200) throw Exception("Authentication failed.");
    return User.fromJson(_decode(response));
  }

  Future<User> createAccount(String email, String password) async {
    final response = await post(
      _endpoints['users'],
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 201)
      throw Exception("Registration failed:\n" + response.body);
    await authorize(email, password);
    return User.fromJson(_decode(response));
  }

  Future<void> logOut() async {
    await delete(_endpoints['users']);
    _headers.remove('Authorization');
  }

  Future<List<Listing>> getListings(int page) async {
    final response = await get(_endpoints['listings'] + page.toString());
    if (response.statusCode != 200) {
      if (response.statusCode != 404)
        throw Exception("Failed to get listings.");
      return [];
    }
    List<dynamic> listings = _decode(response)['results'];
    return listings.map((data) => Listing.fromJson(data)).toList();
  }

  Future<Listing> createListing(
    String title,
    String description,
    String category,
    int price,
    bool condition,
  ) async {
    final response = await post(
      _endpoints['listings'],
      body: jsonEncode({
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'condition_new': condition,
      }),
    );
    if (response.statusCode != 201)
      throw Exception("Failed to create listing: \n" + response.body);
    return Listing.fromJson(_decode(response));
  }

  void dispose() => _client.close();
}
