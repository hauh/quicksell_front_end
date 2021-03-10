import 'dart:convert' show json, jsonEncode, utf8;
import 'dart:async';

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

  //###########################################################################
  final _chatController = StreamController<List<Chat>>.broadcast();
  final _messageController = StreamController<List<Message>>.broadcast();
  final _profileController = StreamController<Profile>.broadcast();

  Timer _chatsTimer;
  Timer _messagesTimer;
  Timer _profileTimer;

  void startChatsTimer() {
    _chatsTimer = Timer.periodic(Duration(milliseconds: 5000), (timer) async {
      _chatController.sink.add(await API().getChats());
    });
  }

  void startMessagesTimer(String uuid) {
    _messagesTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      _messageController.sink.add(await API().getChatMessages(uuid));
    });
  }

  void startProfileTimer(String uuid) {
    _profileTimer = Timer.periodic(Duration(milliseconds: 5000), (timer) async {
      _profileController.sink.add(await API().getProfile(uuid));
    });
  }

  void stopChatsTimer() => _chatsTimer.cancel();
  void stopMessagesTimer() => _messagesTimer.cancel();
  void stopProfileTimer() => _profileTimer.cancel();

  Stream<List<Chat>> get chatsStream => _chatController.stream;
  Stream<List<Message>> get messagesStream => _messageController.stream;
  Stream<Profile> get profileStream => _profileController.stream;

  //###########################################################################


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
    if (response.statusCode != 200) {
        return false;
    }
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
    final response = await get(
      _endpoints['listings'] + "?page=${page.toString()}",
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
      _endpoints['listings'],
      body: formData.toJson(),
    );
    if (response.statusCode != 201)
      throw Exception("Failed to create listing: \n" + response.body);
    return Listing.fromJson(_decode(response));
  }

  Future<ListingFormData> updateListing(ListingFormData formData) async {
    final response = await patch(
      _endpoints['listings'] + "${formData.uuid}/",
      body: formData.toJson(),
    );
    if (response.statusCode != 200)
      throw Exception("Failed to update listing: \n" + response.body);
    return ListingFormData.fromJson(_decode(response));
  }

  Future<List<Chat>> getChats() async {
    var response = await get(_endpoints['chats']);

    if (response.statusCode != 200) {
      if (response.statusCode != 404)
        throw Exception("Failed to get chats!");
      return <Chat>[];
    }

    List<dynamic> chats = _decode(response)['results'];
    return (chats.map((data) => Chat.fromJson(data)).toList());

  }

  Future<List<Message>> getChatMessages(String uuid) async {
    var response = await get(_endpoints['chats'] + uuid + '/');

    if (response.statusCode != 200) {
      if (response.statusCode != 404)
        throw Exception("Failed to get messages!");
      return <Message>[];
    }

    List<dynamic> messages = json.decode(utf8.decode(response.bodyBytes));
    return (messages.map((data) => Message.fromJson(data)).toList());
  }

  Future<List<Chat>> getChatsWithMessages() async {
    List<Chat> chats = await getChats();

    for (var chat in chats) {
      chat.messages = await getChatMessages(chat.uuid);
    }

    return (chats);
  }

  Future<Profile> getProfile(String uuid) async {
    var response = await get(_endpoints['profiles'] + uuid + '/');

    if (response.statusCode != 200) {
      if (response.statusCode != 404)
        throw Exception("Failed to get profile!");
      return null;
    }

    return (Profile.fromJson(_decode(response)));
  }

  Future<Message> createMessage(String uuid, String text) async {
    final response = await post(
      _endpoints['chats'] + uuid + '/',
      body: json.encode({"text": text}),
    );
    if (response.statusCode != 201)
      throw Exception("Failed to create message: \n" + response.body);
    return Message.fromJson(_decode(response));
  }

  void dispose() => _client.close();
}