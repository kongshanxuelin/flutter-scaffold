import '../model/User.dart';
import '../util/NetUtils.dart';

class Api {
  static const String BASE_URL = "http://localhost:6060/report";
  static const String Login = BASE_URL + "/auth/login";
  static const String Logout = BASE_URL + "/auth/logout";
  static const String CheckToken = BASE_URL + "/auth/checktoken";

  // 登陆获取用户信息
  static Future doLogin(Map<String, String> params) async {
    var response = await NetUtils.get(Login, params);
    try {
      User userInfo = User.fromJson(response['data']);
      return userInfo;
    } catch (err) {
      return response['code'];
    }
  }
}