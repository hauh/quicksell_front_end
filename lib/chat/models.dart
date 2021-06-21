part of chat;

class Message {
  Profile author;
  String text;
  DateTime timestamp;

  Message.fromJson(Map<String, dynamic> json)
      : author = Profile.fromJson(json['author']),
        text = json['text'],
        timestamp = DateTime.parse(json['ts_spawn']);
}

class Chat with ChangeNotifier {
  String uuid;
  String subject;
  DateTime updateTimestamp;
  List<Profile> members;
  Message? lastMessage;

  Chat.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        subject = json['subject'],
        updateTimestamp = DateTime.parse(json['ts_update']),
        lastMessage = json['last_message'] != null
            ? Message.fromJson(json['last_message'])
            : null,
        members = json['members']
            .map<Profile>((memberJson) => Profile.fromJson(memberJson))
            .toList();

  void updateLastMessage(Message newMessage) {
    if (newMessage.timestamp.isAfter(updateTimestamp)) {
      lastMessage = newMessage;
      updateTimestamp = newMessage.timestamp;
      notifyListeners();
    }
  }
}
