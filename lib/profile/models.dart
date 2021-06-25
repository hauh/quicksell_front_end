part of profile;

class Profile {
  final String uuid;
  final String name;
  final String phone;
  final String about;
  final DateTime registrationDate;
  final bool online;
  final int rating;
  final String? avatar;

  Profile.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        phone = json['phone'],
        about = json['about'],
        registrationDate = DateTime.parse(json['ts_spawn']),
        online = json['online'],
        rating = json['rating'],
        avatar = json['avatar'];

  @override
  bool operator ==(Object rhs) => rhs is Profile && rhs.uuid == uuid;

  SearchFilters listingsSearchFilters() {
    return SearchFilters.byProfile(this);
  }
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
