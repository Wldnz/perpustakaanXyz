import 'dart:collection';

import 'package:dio/dio.dart';
import '../../utilities/Env.dart';

final dio = Dio();

class Account {
  static Future<HashMap<String, dynamic>> register(registerData) async {
    HashMap<String, dynamic> result = HashMap();
    result["isSuccess"] = false;
    result["message"] = "fail";
    if (registerData == null) {
      return result;
    }
    try {
      var response = await dio.post(
        "${Env.base_url}/models/anggota/register.php",
        data: registerData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        result["message"] = data["message"];
        if (data["isSuccess"]) {
          result["isSuccess"] = true;
        }
      }
    } catch (error) {
      return result;
    }
    return result;
  }

  static Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }
    try {
      var response = await dio.post(
        "${Env.base_url}/models/anggota/login.php",
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        if (data["isLogin"]) {
          Env.account["isLogin"] = true;
          Env.account["id"] = data["id"];
          Env.account["username"] = data["username"];
          return true;
        }
      }
    } catch (error) {
      return false;
    }
    return false;
  }

  static Future<HashMap<String, dynamic>> updateProfile(
    HashMap<String, dynamic> accountData,
  ) async {
    HashMap<String, dynamic> result = HashMap();
    result["isSuccess"] = false;
    result["message"] = "Something error with the server...";
    if (accountData.isEmpty) {
      return result;
    }
    try {
      var response = await dio.post(
        "${Env.base_url}/models/anggota/edit.php",
        data: accountData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        if (data["isSuccess"]) {
          result["isSuccess"] = data["isSuccess"];
        }
        result["message"] = data["message"];
      }
    } catch (error) {
      return result;
    }
    return result;
  }

  static Future<HashMap<String, dynamic>> sendVerificationRequest(
    HashMap<String, dynamic> accountData,
  ) async {
    HashMap<String, dynamic> result = HashMap();
    result["isSuccess"] = false;
    if (accountData.isEmpty) {
      return result;
    }
    print("oke?");
    try {
      print("oke? sblm request");
      var response = await dio.post(
        "${Env.base_url}/models/anggota/verification.php",
        data: accountData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      print(response);
      if (response.statusCode == 200) {
        var data = response.data;
        if (data["isSuccess"]) {
          result["isSuccess"] = data["isSuccess"];
        }
        result["message"] = data["message"];
      }
    } catch (error) {
      print(error);
      result["message"] = "Something error with the server...";
    }
    return result;
  }

  static Future<HashMap<String, dynamic>> getAccountById(String id) async {
    HashMap<String, dynamic> akun = HashMap();
    if (Env.account["isLogin"]) {
      try {
        var response = await dio.get(
          "${Env.base_url}/models/anggota/detail.php",
          data: {"id": id},
          queryParameters: {"id": id},
          options: Options(contentType: Headers.formUrlEncodedContentType),
        );
        if (response.statusCode == 200) {
          var data = response.data;
          var expectedFields = {
            "name",
            "fullname",
            "email",
            "phone",
            "role",
            "status",
          };
          if (data["isSuccess"]) {
            expectedFields.forEach((key) {
              akun[key] = data["data"][key];
            });
            akun["isSuccess"] = true;
          }
        }
      } catch (error) {
        return akun;
      }
    }
    return akun;
  }

  static Future<HashMap<String, dynamic>> getPersonalAccount() async {
    HashMap<String, dynamic> akun = HashMap();
    if (Env.account["isLogin"]) {
      try {
        var response = await dio.get(
          "${Env.base_url}/models/anggota/detailPersonal.php",
          queryParameters: {"id": Env.account["id"]},
          options: Options(contentType: Headers.formUrlEncodedContentType),
        );
        if (response.statusCode == 200) {
          var data = response.data;
          if (data["isSuccess"]) {
            akun = HashMap.from(data["data"]);
          }
        }
      } catch (error) {
        return akun;
      }
    }
    return akun;
  }
}
