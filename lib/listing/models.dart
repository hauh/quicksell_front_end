part of listing;

class Listing with ChangeNotifier {
  final String uuid;
  final Profile seller;
  final DateTime dateCreated;
  String title;
  String description;
  int price;
  String category;
  int quantity;
  int sold;
  int views;
  DateTime dateExpires;
  Location location;
  bool conditionNew;
  String? characteristics;
  List<dynamic>? photos;
  bool closed;

  Listing.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['title'],
        description = json['description'] ?? "No description",
        price = json['price'],
        category = json['category'],
        quantity = json['quantity'],
        sold = json['sold'],
        views = json['views'],
        dateCreated = DateTime.parse(json['ts_spawn']),
        dateExpires = DateTime.parse(json['ts_expires']),
        location = Location.fromJson(json['location']),
        conditionNew = json['is_new'],
        characteristics = json['properties'],
        photos = null,
        seller = Profile.fromJson(json['seller']),
        closed = false;

  void update(Listing updatedListing) {
    title = updatedListing.title;
    description = updatedListing.description;
    price = updatedListing.price;
    category = updatedListing.category;
    quantity = updatedListing.quantity;
    sold = updatedListing.sold;
    views = updatedListing.views;
    dateExpires = updatedListing.dateExpires;
    location = updatedListing.location;
    conditionNew = updatedListing.conditionNew;
    characteristics = updatedListing.characteristics;
    photos = updatedListing.photos;
    closed = updatedListing.closed;

    notifyListeners();
  }

  void delete() {
    closed = true;
    notifyListeners();
  }
}

class ListingFormData {
  String? uuid;
  String? title;
  String? description;
  String? category;
  int? price;
  bool? conditionNew;
  Location? location;

  ListingFormData();

  ListingFormData.fromListing(Listing listing)
      : uuid = listing.uuid,
        title = listing.title,
        description = listing.description,
        category = listing.category,
        price = listing.price,
        conditionNew = listing.conditionNew,
        location = listing.location;

  ListingFormData.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        category = json['category'],
        conditionNew = json['condition_new'],
        location = Location.fromJson(json['location']);

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (category != null) 'category': category,
        if (price != null) 'price': price,
        if (conditionNew != null) 'is_new': conditionNew,
        if (location != null) 'location': location!.toJson(),
      };

  void clear() {
    uuid = null;
    title = null;
    description = null;
    category = null;
    price = null;
    conditionNew = null;
  }
}
