
import 'package:dio/dio.dart';
import 'package:hand_bill_manger/src/common/api_data.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/help/help_center_response.dart';

import '../data/response/account/agent_response.dart';
class HelpRepository {
  String tag = "HelpsRepository";
  Dio _dio = Dio();

  Future<AgentResponse> getAgentData({required int page}) async {
    Map<String, String> queryParams = ({
      "secret": APIData.secretKey,
      // "page": page.toString(),
      // "paginate": "6"
    });

    late AgentResponse agentResponse;
    Response response;
    try {
      response =
          await _dio.get(APIData.getAllAgent, queryParameters: queryParams);

      agentResponse = AgentResponse.fromJson(response.data);
      
      // log("rrr ${jsonEncode(response.data)}");
      if (agentResponse.status!) {
        return agentResponse;
      } else {
        return agentResponse;
      }
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return agentResponse;

  }

  Future<HelpCenterModel?> fetchEmails() async {
    late HelpCenterModel helpCenterModel;
    Response response;
    try {
      response =
      await _dio.get(APIData.helpCenter);

      helpCenterModel = HelpCenterModel.fromJson(response.data);
      if (helpCenterModel.status!) {
        return helpCenterModel;
      } else {
        return helpCenterModel;
      }
    } catch (error, stackTrace) {
      print("$tag error : $error , stackTrace:  $stackTrace");
    }
    return helpCenterModel;

    }

}
