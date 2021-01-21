class Seller {
  final String uuid;
  final DateTime dateCreated;
  final String fullName;
  final String about;
  final bool online;
  final int rating;
  final String avatar;
  final int location;

  Seller.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        dateCreated = DateTime.parse(json['date_created']),
        fullName = json['full_name'],
        about = json['about'],
        online = json['online'],
        rating = json['rating'],
        avatar = json['avatar'],
        location = json['location'];
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
  final Seller seller;
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
        seller = Seller.fromJson(json['seller']),
        photos = json['photos'];
}
