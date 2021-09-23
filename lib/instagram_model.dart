import 'dart:convert';

import 'package:dio/dio.dart';

import 'instagram_constant.dart';

class InstagramModel {
  List<String> userFields = ['id', 'username'];

  String? authorizationCode;
  String? accessToken;
  String? userID;
  String? username;

  void getAuthorizationCode(String url) {
    authorizationCode = url
        .replaceAll('${InstagramConstant.redirectUri}?code=', '')
        .replaceAll('#_', '');
  }

  Future<bool> getTokenAndUserID() async {

    var url = ('https://api.instagram.com/oauth/access_token');
    final response = await Dio().post(url, data: {
      'client_id': InstagramConstant.clientID,
      'redirect_uri': InstagramConstant.redirectUri,
      'client_secret': InstagramConstant.appSecret,
      'code': authorizationCode,
      'grant_type': 'authorization_code'
    });
    accessToken = json.decode(response.data)['access_token'];
    print(accessToken);
    userID = json.decode(response.data)['user_id'].toString();
    return (accessToken != null && userID != null) ? true : false;
  }

  Future<bool> getUserProfile() async {
    final fields = userFields.join(',');
    final responseNode = await Dio().get(
        'https://graph.instagram.com/$userID?fields=$fields&access_token=$accessToken');
    var instaProfile = {
      'id': json.decode(responseNode.data)['id'].toString(),
      'username': json.decode(responseNode.data)['username'],
    };
    username = json.decode(responseNode.data)['username'];
    print('username: $username');
    return instaProfile != null ? true : false;
  }
}