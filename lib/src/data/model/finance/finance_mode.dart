class FinanceModel{
  int? id;
  int? sellerId;
  String? title;
  String? description;
  String? type;
  String? whatsApp;
  String? date;
  String? cost;

  FinanceModel(
      {required this.id,
      required this.sellerId,
      required this.title,
      required this.description,
      required this.type,
      required this.whatsApp,
      required this.date,
      required this.cost,
      });

  FinanceModel.fromJson(dynamic json) {
    id = json["id"];
    sellerId = json["sellerId"];
    title = json["title"];
    description = json["description"];
    type = json["type"];
    date = json["date"];
    cost = json["cost"];
  }
}

class FinanceResponse{
  List<FinanceModel>? _data;
  FinanceResponse.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data?.add(FinanceModel.fromJson(v));
      });
    }
  }
}
//Company Need Finance
//Company Provide Finance
//Company search for aquisation
//Company ask for Joint Venture