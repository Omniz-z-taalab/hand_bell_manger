class PlanModel {
  int? _id;
  int? _numProducts;
  int? _numImages;
  int? _numVideos;
  int? _numOffers;
  int? _numAssets;
  int? _numJobs;
  String? _price;
  String? _name;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  int? get numProducts => _numProducts;
  int? get numImages => _numImages;
  int? get numVideos => _numVideos;
  int? get numOffers => _numOffers;
  int? get numAssets => _numAssets;
  int? get numJobs => _numJobs;
  String? get price => _price;
  String? get name => _name;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  PlanModel({
    int? id,
    int? numProducts,
    int? numImages,
    int? numVideos,
    int? numOffers,
    int? numAssets,
    int? numJobs,
    String? price,
    String? name,
    String? createdAt,
    String? updatedAt}){
    _id = id;
    _numProducts = numProducts;
    _numImages = numImages;
    _numVideos = numVideos;
    _numOffers = numOffers;
    _numAssets = numAssets;
    _numJobs = numJobs;
    _price = price;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  PlanModel.fromJson(dynamic json) {
    _id = json["id"];
    _numProducts = json["num_products"];
    _numImages = json["num_images"];
    _numVideos = json["num_videos"];
    _numOffers = json["num_offers"];
    _numAssets = json["num_assets"];
    _numJobs = json["num_jobs"];
    _price = json["price"];
    _name = json["name"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["num_products"] = _numProducts;
    map["num_images"] = _numImages;
    map["num_videos"] = _numVideos;
    map["num_offers"] = _numOffers;
    map["num_assets"] = _numAssets;
    map["num_jobs"] = _numJobs;
    map["price"] = _price;
    map["name"] = _name;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}