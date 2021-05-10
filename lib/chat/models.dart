part of chat;

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
