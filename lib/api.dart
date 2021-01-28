import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:quicksell_app/models.dart';

class API extends http.BaseClient {
  API._();
  static final _instance = API._();
  factory API() => API._instance;

  final _client = http.Client();
  Map<String, dynamic> _endpoints;
  Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(this._headers);
    return this._client.send(request);
  }

  Future<bool> init() async {
    final loadedUrls = await rootBundle.loadString('assets/urls.json');
    this._endpoints = json.decode(loadedUrls);
    final response = await http.get(this._endpoints['info']);
    return (response.statusCode == 200);
  }

  Map<String, dynamic> _decode(http.Response response) =>
      json.decode(utf8.decode(response.bodyBytes));

  Future<void> authorize(String email, String password) async {
    final response = await post(
      this._endpoints['auth'],
      body: jsonEncode({'username': email, 'password': password}),
    );
    if (response.statusCode != 200) throw Exception("Authorization failed.");
    this._headers['Authorization'] = "Token ${_decode(response)['token']}";
  }

  Future<User> authenticate(String email, String password) async {
    await authorize(email, password);
    final response = await get(this._endpoints['users']);
    if (response.statusCode != 200) throw Exception("Authentication failed.");
    return User.fromJson(_decode(response));
  }

  Future<User> createAccount(String email, String password) async {
    final response = await post(
      this._endpoints['users'],
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 201) throw Exception("Registration failed.");
    await authorize(email, password);
    return User.fromJson(_decode(response));
  }

  Future<void> logOut() async {
    await delete(this._endpoints['users']);
    this._headers.remove('Authorization');
  }

  Future<List<Listing>> getListings(int page) async {
    final response = await get(this._endpoints['listings'] + page.toString());
    if (response.statusCode != 200) {
      if (response.statusCode != 404)
        throw Exception("Failed to get listings.");
      return [];
    }
    List<dynamic> listings = _decode(response)['results'];
    return listings.map((data) => Listing.fromJson(data)).toList();
  }

  void dispose() => this._client.close();
}
