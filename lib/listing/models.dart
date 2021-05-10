part of listing;

class Listing with ChangeNotifier {
  final String uuid;
  final Profile seller;
  final DateTime dateCreated;
  String title;
  String description;
  int price;
  String category;
  int status;
  int quantity;
  int sold;
  int views;
  DateTime dateExpires;
  Location location;
  bool conditionNew;
  String? characteristics;
  List<dynamic> photos;
  bool closed;

  Listing.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['title'],
        description = json['description'] ?? "No description",
        price = json['price'],
        category = json['category'],
        status = json['status'],
        quantity = json['quantity'],
        sold = json['sold'],
        views = json['views'],
        dateCreated = DateTime.parse(json['date_created']),
        dateExpires = DateTime.parse(json['date_expires']),
        location = Location.fromJson(json['location']),
        conditionNew = json['condition_new'],
        characteristics = null, // json['characteristics'],
        seller = Profile.fromJson(json['seller']),
        photos = json['photos'],
        closed = false;

  void updateWithForm(ListingFormData formData) {
    title = formData.title!;
    description = formData.description!;
    price = formData.price!;
    category = formData.category!;
    conditionNew = formData.conditionNew!;

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

  String toJson() => jsonEncode({
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'condition_new': conditionNew,
        'location': location!.toDict(),
      });

  void clear() {
    uuid = null;
    title = null;
    description = null;
    category = null;
    price = null;
    conditionNew = null;
  }
}
