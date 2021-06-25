import 'dart:convert' show json, jsonEncode, utf8;

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' show Response, Client;
import 'package:quicksell_app/chat/lib.dart' show Chat, Message;
import 'package:quicksell_app/listing/lib.dart' show Listing, ListingFormData;
import 'package:quicksell_app/profile/lib.dart' show User;

class APIException implements Exception {
  String message;
  Response response;
  APIException(this.message, this.response);

  @override
  String toString() => "$message: ${response.statusCode}\n${response.body}";
}

class API {
  API._();
  static final _instance = API._();
  factory API() => API._instance;

  final Client _client = Client();

  late Uri apiUri;
  late String accessToken;

  late Map<String, dynamic> _categories;
  Map<String, dynamic> get categories => _categories;

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
    bool authorization = false,
  }) async {
    return await _client.get(
      apiUri.resolve(endpoint).replace(queryParameters: params),
      headers: authorization ? {'Authorization': "Bearer $accessToken"} : null,
    );
  }

  Future<Response> post(
    String endpoint, {
    required dynamic body,
    required bool authorization,
  }) async {
    var encoded = jsonEncode(body);
    return await _client.post(
      apiUri.resolve(endpoint),
      body: encoded,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Content-Lenght': encoded.length.toString(),
        if (authorization) 'Authorization': "Bearer $accessToken"
      },
    );
  }

  Future<Response> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    required bool authorization,
  }) async {
    var encoded = jsonEncode(body);
    return await _client.patch(
      apiUri.resolve(endpoint),
      body: encoded,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Content-Lenght': encoded.length.toString(),
        if (authorization) 'Authorization': "Bearer $accessToken"
      },
    );
  }

  Future<Response> delete(String endpoint) async {
    return await _client.delete(
      apiUri.resolve(endpoint),
      headers: {'Authorization': "Bearer $accessToken"},
    );
  }

  dynamic _decode(Response response) =>
      json.decode(utf8.decode(response.bodyBytes));

  Future<void> init() async {
    apiUri = Uri.parse(await rootBundle.loadString('assets/api_url'));
    final response = await get('listings/categories/');
    if (response.statusCode != 200)
      throw APIException("API connection failed", response);
    _categories = _decode(response);
  }

  Future<void> authorize(String email, String password) async {
    final response = await _client.post(
      apiUri.resolve('users/auth/'),
      body: {'username': email, 'password': password},
    );
    if (response.statusCode != 200)
      throw APIException("Authorization failed", response);
    accessToken = _decode(response)['access_token'];
  }

  Future<User> authenticate(String email, String password) async {
    await authorize(email, password);
    final response = await get('users/', authorization: true);
    if (response.statusCode != 200)
      throw APIException("Authentication failed", response);
    return User.fromJson(_decode(response));
  }

  Future<User> createAccount(
    String name,
    String email,
    String phone,
    String password,
    String fcmId,
  ) async {
    final response = await post(
      'users/',
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'fcm_id': fcmId,
      },
      authorization: false,
    );
    if (response.statusCode != 201)
      throw APIException("Registration failed", response);
    await authorize(email, password);
    return User.fromJson(_decode(response));
  }

  Future<void> logOut() async {
    final response = await delete('users/auth/');
    if (response.statusCode != 200)
      throw APIException("Logout failed", response);
    accessToken = '';
  }

  Future<List<Listing>> getListings(
    int page, [
    Map<String, String>? filters,
  ]) async {
    var params = {'page': page.toString()};
    if (filters != null) params.addAll(filters);
    final response = await get('listings/', params: params);
    if (response.statusCode != 200)
      throw APIException("Failed to get listings", response);
    List<dynamic> listings = _decode(response);
    return listings.map((data) => Listing.fromJson(data)).toList();
  }

  Future<Listing> createListing(ListingFormData formData) async {
    final response = await post(
      'listings/',
      body: formData.toJson(),
      authorization: true,
    );
    if (response.statusCode != 201)
      throw APIException("Failed to create listing", response);
    return Listing.fromJson(_decode(response));
  }

  Future<Listing> updateListing(ListingFormData formData) async {
    final response = await patch(
      'listings/${formData.uuid}/',
      body: formData.toJson(),
      authorization: true,
    );
    if (response.statusCode != 200)
      throw APIException("Failed to update listing", response);
    return Listing.fromJson(_decode(response));
  }

  Future<void> deleteListing(String uuid) async {
    final response = await delete('listings/$uuid/');
    if (response.statusCode != 204) {
      throw APIException("Failed to delete listing", response);
    }
  }

  Future<List<Chat>> getChats(int page, [Map<String, String>? filters]) async {
    var params = {'page': page.toString()};
    if (filters != null) params.addAll(filters);
    final response = await get(
      'chats/',
      params: params,
      authorization: true,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 404) return <Chat>[];
      throw APIException("Failed to get chats", response);
    }
    List<dynamic> chats = _decode(response);
    return (chats.map((data) => Chat.fromJson(data)).toList());
  }

  Future<Chat> createChat(String listingUuid) async {
    final response = await post(
      'chats/',
      body: listingUuid,
      authorization: true,
    );
    if (response.statusCode != 201)
      throw APIException("Failed to create message", response);
    return Chat.fromJson(_decode(response));
  }

  Future<List<Message>> getMessages(String uuid, int page) async {
    final response = await get(
      'chats/$uuid/',
      params: {'page': page.toString()},
      authorization: true,
    );
    if (response.statusCode != 200) {
      throw APIException("Failed to get messages", response);
    }
    List<dynamic> messages = _decode(response);
    return (messages.map((data) => Message.fromJson(data)).toList());
  }

  Future<Message> createMessage(String uuid, String text) async {
    final response = await post(
      'chats/$uuid/',
      body: text,
      authorization: true,
    );
    if (response.statusCode != 201)
      throw APIException("Failed to create message", response);
    return Message.fromJson(_decode(response));
  }

  void dispose() => _client.close();
}
