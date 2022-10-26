import 'package:hand_bill_manger/src/data/model/local/images.dart';

class User {
  int? _id;
  String? _isVerified;
  String? _deviceToken;
  String? _active;
  String? _apiToken;
  String? _address;
  String? _email;
  String? _name;
  String? _phone;
  String? _password;
  ImageModel? _image;

  int? get id => _id;

  String? get isVerified => _isVerified;

  String? get deviceToken => _deviceToken;

  String? get active => _active;

  String? get apiToken => _apiToken;

  String? get address => _address;

  String? get email => _email;

  String? get name => _name;

  String? get phone => _phone;

  String? get password => _password;

  ImageModel? get image => _image;

  User(
      {int? id,
      String? isVerified,
      String? deviceToken,
      String? active,
      String? apiToken,
      String? address,
      String? email,
      String? username,
      String? phone,
      ImageModel? image,
      String? name}) {
    _id = id;
    _isVerified = isVerified;
    _deviceToken = deviceToken;
    _active = active;
    _apiToken = apiToken;
    _address = address;
    _email = email;
    _name = name;
    _phone = phone;
    _image = image;
  }

  User.fromJson(dynamic json) {
    _id = json["id"];
    _isVerified = json["is_verified"];
    _deviceToken = json["device_token"];
    _active = json["active"];
    _apiToken = json["api_token"];
    _address = json["address"];
    _email = json["email"];
    _name = json["name"];
    _phone = json["phone"];
    _image = json["image"] != null ? ImageModel.fromJson(json["image"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["is_verified"] = _isVerified;
    map["device_token"] = _deviceToken;
    map["active"] = _active;
    map["api_token"] = _apiToken;
    map["address"] = _address;
    map["email"] = _email;
    map["name"] = name;
    map["phone"] = _phone;
    if (_image != null) {
      map["image"] = _image?.toJson();
    }
    return map;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = image!.url;
    map["device_token"] = deviceToken;
    return map;
  }

  set password(String? value) {
    _password = value;
  }

  set name(String? value) {
    _name = value;
  }

  set email(String? value) {
    _email = value;
  }

  set deviceToken(String? value) {
    _deviceToken = value;
  }
}
