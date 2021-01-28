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

class Listing {
  final String uuid;
  final String title;
  final String description;
  final int price;
  final String category;
  final int status;
  final int quantity;
  final int sold;
  final int views;
  final DateTime dateCreated;
  final DateTime dateExpires;
  final int location;
  final bool conditionNew;
  final String characteristics;
  final Profile seller;
  final List<dynamic> photos;

  Listing.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        category = json['category'],
        status = json['status'],
        quantity = json['quantity'],
        sold = json['sold'],
        views = json['views'],
        dateCreated = DateTime.parse(json['date_created']),
        dateExpires = DateTime.parse(json['date_expires']),
        location = json['location'],
        conditionNew = json['condition_new'],
        characteristics = null, // json['characteristics'],
        seller = Profile.fromJson(json['seller']),
        photos = json['photos'];
}
