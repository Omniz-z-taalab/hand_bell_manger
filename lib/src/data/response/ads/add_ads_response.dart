class AddAdsResponse {
  Data? _data;

  Data? get data => _data;

  AddAdsResponse({
      Data? data}){
    _data = data;
}

  AddAdsResponse.fromJson(dynamic json) {
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    return map;
  }

}

class Data {
  bool? _status;
  String? _message;

  bool? get status => _status;
  String? get message => _message;

  Data({
      bool? status,
      String? message}){
    _status = status;
    _message = message;
}

  Data.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _status;
    map["message"] = _message;
    return map;
  }

}