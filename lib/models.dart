class Profile {
  final String uuid;
  final DateTime dateCreated;
  final String fullName;
  final String about;
  final bool online;
  final int rating;
  final String avatar;
  final int location;

  Profile.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        dateCreated = DateTime.parse(json['date_created']),
        fullName = json['full_name'],
        about = json['about'],
        online = json['online'],
        rating = json['rating'],
        avatar = json['avatar'],
        location = json['location'];

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
