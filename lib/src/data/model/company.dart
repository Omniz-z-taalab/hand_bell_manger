import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/left_data_of_companies.dart';
import 'package:hand_bill_manger/src/data/model/local/images.dart';
import 'package:hand_bill_manger/src/data/model/plan_model.dart';

import 'local/video_model.dart';

class Company {
  int? _id;
  String? _natureActivity;
  String? _subNatureActivity;
  PlanModel? _plan;
  bool? _isVerified;
  String? _deviceToken;
  String? _banners;
  bool? _active;
  String? _offers;
  String? _assets;
  String? _apiToken;
  String? _jobs;
  String? _email;
  String? _name;
  String? _password;
  String? _confirmpassword;

  String? _createdAt;
  String? _updatedAt;
  LeftDataOfCompanies? _leftDataOfCompanies;
  List<SaveImageModel>? _images;
  SaveImageModel? _logo;
  VideoModel? _video;
  String? _phone;
  String? _country;
  String? _flag;
  String? _expiration_date;
  int? get id => _id;

  PlanModel? get plan => _plan;

  String? get natureActivity => _natureActivity;

  bool? get isVerified => _isVerified;

  String? get deviceToken => _deviceToken;

  String? get banners => _banners;

  bool? get active => _active;

  set setActive(bool value) {
    _active = value;
  }

  String? get offers => _offers;

  String? get assets => _assets;

  String? get apiToken => _apiToken;

  String? get jobs => _jobs;

  String? get email => _email;

  String? get name => _name;

  String? get password => _password;
  String? get confirmpassword => _confirmpassword;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get expirationDate => _expiration_date;

  LeftDataOfCompanies? get leftDataOfCompanies => _leftDataOfCompanies;

  List<SaveImageModel>? get images => _images;

  SaveImageModel? get logo => _logo;

  VideoModel? get video => _video;

  String? get firstPhone => _phone;

  String? get country => _country;

  String? get flag => _flag;

  Company({
    int? id,
    String? natureActivity,
    String? subNatureActivity,
    PlanModel? plan,
    bool? isVerified,
    String? deviceToken,
    String? banners,
    bool? active,
    String? offers,
    String? assets,
    String? apiToken,
    String? jobs,
    String? email,
    String? name,
    String? password,
    String? confirmpassword,
    String? createdAt,
    String? updatedAt,
    String? expirationDate,
    LeftDataOfCompanies? leftDataOfCompanies,
    List<SaveImageModel>? images,
    SaveImageModel? logo,
    VideoModel? video,
    String? firstPhone,
    String? country,
    String? flag,
  }) {
    _id = id;
    _plan = plan;
    _natureActivity = natureActivity;
    _subNatureActivity = subNatureActivity;
    _isVerified = isVerified;
    _deviceToken = deviceToken;
    _banners = banners;
    _active = active;
    _offers = offers;
    _assets = assets;
    _apiToken = apiToken;
    _jobs = jobs;
    _email = email;
    _name = name;
    _password = password;
    _confirmpassword = confirmpassword;

    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _expiration_date = expirationDate;
    _leftDataOfCompanies = leftDataOfCompanies;
    _images = images;
    _logo = logo;
    _video = video;
    _phone = firstPhone;
    _country = country;
    _flag = flag;
  }

  Company.fromJson(dynamic json) {
    _id = json["id"];
    _plan = json["plan"] != null ? PlanModel.fromJson(json["plan"]) : null;
    _natureActivity = json["nature_activity"];
    _subNatureActivity = json["sub_nature_activity"];
    _isVerified = json["is_verified"];
    _deviceToken = json["device_token"];
    _banners = json["banners"];
    _active = json["active"];
    _offers = json["offers"];
    _assets = json["assets"];
    _apiToken = json["api_token"];
    _jobs = json["jobs"];
    _email = json["email"];
    _phone = json["phone"];
    _name = json["name"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _expiration_date = json["expiration_date"];
    _leftDataOfCompanies = json["left_data_of_companies"] != null
        ? LeftDataOfCompanies.fromJson(json["left_data_of_companies"])
        : null;
    if (json["images"] != null) {
      _images = [];
      json["images"].forEach((v) {
        _images?.add(SaveImageModel.fromJson(v));
      });
    }
    _video = json["video"] != null ? VideoModel.fromJson(json["video"]) : null;
    _logo = json["logo"] != null ? SaveImageModel.fromJson(json["logo"]) : null;
    _phone = json["phone"];
    _country = json["country"];
    _flag = json["flag"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["id"] = _id;
    map["nature_activity"] = _natureActivity;
    map["sub_nature_activity"] = _subNatureActivity;
    // map["plan_id"] = _planId;
    map["is_verified"] = _isVerified;
    map["device_token"] = _deviceToken;
    map["active"] = _active;
    map["api_token"] = _apiToken;
    map["email"] = _email;
    map["country"] = _country;
    map["phone"] = _phone;
    map["flag"] = _flag;
    map["name"] = _name;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["expiration_date"] = _expiration_date;

    if (_leftDataOfCompanies != null) {
      map["left_data_of_companies"] = _leftDataOfCompanies?.toJson();
    }
    if (_images != null) {
      map["images"] = _images?.map((v) => v.toJson()).toList();
    }
    if (_plan != null) {
      map["plan"] = _plan?.toJson();
    }
    if (_logo != null) {
      map["logo"] = _logo?.toJson();
    }

    map["password"] = _password;
    map["confirm_password"] = _confirmpassword;

    return map;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    // map["thumb"] = logo;
    map["thumb"] = imageEx;
    map["device_token"] = deviceToken;
    return map;
  }

  set password(String? value) {
    _password = value;
  }

  set confirmpassword(String? value) {
    _confirmpassword = value;
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

  set natureActivity(String? value) {
    _natureActivity = value;
  }

  set logo(SaveImageModel? value) {
    _logo = value;
  }

  bool profileCompleted() {
    return _leftDataOfCompanies != null &&
        _leftDataOfCompanies != LeftDataOfCompanies() &&
        _images != null &&
        _images != [] &&
        _logo != null &&
        _logo != SaveImageModel();
  }
}
