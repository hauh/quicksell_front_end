import 'dart:convert' show json, jsonEncode, utf8;

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:quicksell_app/listing/lib.dart' show Listing, ListingFormData;
import 'package:quicksell_app/models.dart';

class API extends http.BaseClient {
  API._();
  static final _instance = API._();
  factory API() => API._instance;

  final _client = http.Client();
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  late Uri apiUri;
  late Map<String, dynamic> _categories;
  Map<String, dynamic> get categories => _categories;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  Future<bool> init() async {
    apiUri = Uri.parse(await rootBundle.loadString('assets/api_url'));
    final response = await get(apiUri.resolve('info/'));
    if (response.statusCode != 200) return false;
    _categories = _decode(response)['categories'];
    return true;
  }

  Map<String, dynamic> _decode(http.Response response) =>
      json.decode(utf8.decode(response.bodyBytes));

  Future<void> authorize(String email, String password) async {
    final response = await post(
      apiUri.resolve('users/login/'),
      body: jsonEncode({'username': email, 'password': password}),
    );
    if (response.statusCode != 200) throw Exception("Authorization failed.");
    _headers['Authorization'] = "Token ${_decode(response)['token']}";
  }

  Future<User> authenticate(String email, String password) async {
    await authorize(email, password);
    final response = await get(apiUri.resolve('users/'));
    if (response.statusCode != 200) throw Exception("Authentication failed.");
    return User.fromJson(_decode(response));
  }

  Future<User> createAccount(String email, String password) async {
    final response = await post(
      apiUri.resolve('users/'),
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 201)
      throw Exception("Registration failed:\n" + response.body);
    await authorize(email, password);
    return User.fromJson(_decode(response));
  }

  Future<void> logOut() async {
    await delete(apiUri.resolve('users/login/'));
    _headers.remove('Authorization');
  }

  Future<List<Listing>> getListings(int page,
      [Map<String, String>? filters]) async {
    var queryParams = {'page': page.toString()};
    if (filters != null) queryParams.addAll(filters);
    final response = await get(
      apiUri.resolve('listings/').replace(queryParameters: queryParams),
    );
    if (response.statusCode != 200) {
      if (response.statusCode != 404)
        throw Exception("Failed to get listings.");
      return [];
    }
    List<dynamic> listings = _decode(response)['results'];
    return listings.map((data) => Listing.fromJson(data)).toList();
  }

  Future<Listing> createListing(ListingFormData formData) async {
    final response = await post(
      apiUri.resolve('listings/'),
      body: formData.toJson(),
    );
    if (response.statusCode != 201)
      throw Exception("Failed to create listing: \n" + response.body);
    return Listing.fromJson(_decode(response));
  }

  Future<ListingFormData> updateListing(ListingFormData formData) async {
    final response = await patch(
      apiUri.resolve('listings/${formData.uuid}/'),
      body: formData.toJson(),
    );
    if (response.statusCode != 200)
      throw Exception("Failed to update listing: \n" + response.body);
    return ListingFormData.fromJson(_decode(response));
  }

  void dispose() => _client.close();
}
