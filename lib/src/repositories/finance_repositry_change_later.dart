import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/common/global.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/finance/finance_mode.dart';

class FinanceRepository{
  static FinanceModel? financeModel;
  static String tag = "AdsRepository";
  static Dio _dio = Dio();

  static Future<bool> addFinance({required String title,required String desc,
  required String date,required String whatsApp,required String type,
  required String cost}) async {
    bool ifTrue = false;
    Company? myCompany;
    String? sName;
    sName = await storage.read(key: "currentUser");
    myCompany = Company.fromJson(json.decode(sName!));
    _dio.options.headers["Authorization"] =
        "Bearer " + myCompany.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";
    FormData formData;
    formData = FormData.fromMap({
      "secret": APIData.secretKey,
      'seller_id':myCompany.id,
      'title':title,
      'description':desc,
      'whatsApp':whatsApp,
      'date':date,
      'type':type,
      'cost':cost
    });
    Response response;
    try {
      response = await _dio.post(APIData.addFinance, data: formData,
      options: Options(followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,));
      log("addFinance: ${jsonEncode(response.data.toString())}");
      var decoded = jsonDecode(response.toString());
      if(decoded['message']==true){
        ifTrue = true;
      }
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return ifTrue;
  }

  static Future<List<FinanceModel>> getAllFinance() async {
    financeModel = null;
    Company? myCompany;
    String? sName;
    sName = await storage.read(key: "currentUser");
    myCompany = Company.fromJson(json.decode(sName!));
    _dio.options.headers["Authorization"] =
        "Bearer " + myCompany.apiToken.toString();
    _dio.options.headers["Accept"] = "application/json";

    Map<String, String> queryParams =
    ({"secret": APIData.secretKey,});

    List<FinanceModel> thisList = [];
    try {
      final response = await _dio.get(APIData.getAllFinance,
          queryParameters: queryParams);
      log("getAllFinance: ${response.toString()}");
      var decoded  = jsonDecode(response.toString());
      var decodedData = decoded['data'];
      for(int i=0;i<decodedData.length;i++){
        thisList.add(FinanceModel(
            id: int.parse(decodedData[i]['id']),
            sellerId: int.parse(decodedData[i]['seller_id']),
            title: decodedData[i]['title'],
            description: decodedData[i]['description'],
            type: decodedData[i]['type'],
            whatsApp: decodedData[i]['whatsApp'],
            date: decodedData[i]['date'],
            cost: decodedData[i]['cost'],
        ));
      }
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return thisList;
  }
}