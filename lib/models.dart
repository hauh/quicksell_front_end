import 'package:here_sdk/core.dart';
import 'package:quicksell_app/listing/lib.dart';

class Profile {
  final String uuid;
  final DateTime dateCreated;
  final String fullName;
  final String about;
  final bool online;
  final int rating;
  final String? avatar;
  late GeoCoordinates? location;

  Profile.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        dateCreated = DateTime.parse(json['date_created']),
        fullName = json['full_name'],
        about = json['about'],
        online = json['online'],
        rating = json['rating'],
        avatar = json['avatar'];

  @override
  bool operator ==(Object rhs) => rhs is Profile && rhs.uuid == uuid;
}

class User {
  final String email;
  final bool isEmailVerified;
  final int balance;
  final Profile profile;

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        isEmailVerified = json['is_email_verified'],
        balance = json['balance'],
        profile = Profile.fromJson(json['profile']);
}

class Message {
  bool read;
  bool is_yours;
  String text;
  DateTime timestamp;

  Message.fromJson(Map<String, dynamic> json)
      : read = json['read'],
        is_yours = json['is_yours'],
        text = json['text'],
        timestamp = DateTime.parse(json['timestamp']);
}

class Chat {
  String uuid;
  String subject;
  Profile interlocutor;
  Listing listing;
  Message? latestMessage;

  late List<Message> messages;

  Chat.prepareFromListing(Listing listing)
      : uuid = "",
        subject = listing.title,
        interlocutor = listing.seller,
        listing = listing;

  Chat.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        subject = json['subject'],
        interlocutor = Profile.fromJson(json['interlocutor']),
        listing = Listing.fromJson(json['listing']),
        latestMessage = Message.fromJson(json['latest_message']);
}
