import 'dart:convert';

import 'package:jyo_app/data/remote/commet_chat_api_interface.dart';
import 'package:http/http.dart' as http;
import 'package:jyo_app/utils/commet_chat_constants.dart';

class CommetChatApiService extends CommetChatApiInterface {
  @override
  Future commetChatPostApi({
    String? url,
    Map? data,
  }) async {   
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(url!),
        headers: <String, String>{
          'accept': 'application/json',
          'content-type': 'application/json',
          'apikey': CometChatConstants.restApiKey
        },
        body: jsonEncode(data));
    responseJson = jsonDecode(response.body);
    return responseJson; 
  }
  
  @override
  Future commetChatDeleteApi({String? url, Map? data}) async{
   var client = http.Client();
    dynamic responseJson;
    final response = await client.delete(
        Uri.parse(url!),
        headers: <String, String>{
          'accept': 'application/json',
          'content-type': 'application/json',
          'apikey': CometChatConstants.restApiKey
        },
        body: jsonEncode(data));
    responseJson = jsonDecode(response.body);
    return responseJson; 
  }
  
  @override
  Future commetChatGetApi({String? url}) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(url!),
        headers: <String, String>{
          'accept': 'application/json',
          'content-type': 'application/json',
          'apikey': CometChatConstants.restApiKey
        });
    responseJson = jsonDecode(response.body);
    return responseJson; 
  }

}
