class HomeModel {
  bool? status;
  HomeDataModel? data;

  HomeModel.fromjson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? HomeDataModel.fromjson(json['data']) : null;
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductsModel> products = [];

  HomeDataModel.fromjson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      json['banners'].forEach((element) {
        banners.add(BannerModel.fromjson(element));
      });
    }

    if (json['products'] != null) {
      json['products'].forEach((element) {
        products.add(ProductsModel.fromjson(element));
      });
    }
  }
}

class BannerModel {
  int? id;
  String? image;

  BannerModel.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductsModel {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  bool? inFavorites;
  bool? inCart;

  ProductsModel.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
