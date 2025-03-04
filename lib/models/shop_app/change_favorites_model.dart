class ChangeFavoritesModel {
  bool status;
  String? message;
  Data? data;

  ChangeFavoritesModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = json['data'] != null ? Data.fromJson(json['data']) : null;
}

class Data {
  int currentPage;
  List<FavoritesData> data = [];
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int to;
  int total;

  Data.fromJson(Map<String, dynamic> json)
      : currentPage = json['current_page'],
        firstPageUrl = json['first_page_url'],
        from = json['from'],
        lastPage = json['last_page'],
        lastPageUrl = json['last_page_url'],
        nextPageUrl = json['next_page_url'],
        path = json['path'],
        perPage = json['per_page'],
        prevPageUrl = json['prev_page_url'],
        to = json['to'],
        total = json['total'] {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(FavoritesData.fromJson(v));
      });
    }
  }
}

class FavoritesData {
  int id;
  Product? product;

  FavoritesData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        product = json['product'] != null ? Product.fromJson(json['product']) : null;
}

class Product {
  int id;
  dynamic price;
  dynamic oldPrice;
  int discount;
  String image;
  String name;
  String description;

  Product({
    required this.id,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.image,
    required this.name,
    required this.description,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        price = json['price'],
        oldPrice = json['old_price'],
        discount = json['discount'],
        image = json['image'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['old_price'] = oldPrice;
    data['discount'] = discount;
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
