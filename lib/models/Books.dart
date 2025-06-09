import 'dart:collection';

import 'package:dio/dio.dart';
import '../../utilities/Env.dart';

final dio = Dio();

class Books {
  static Future<List<dynamic>> getAll() async {
    List<dynamic> listBuku = [];
    try {
      var response = await dio.get("${Env.base_url}/models/book/all.php");
      if (response.statusCode == 200) {
        var data = response.data;
        if (data["isSuccess"]) {
          List.from(data["data"]).forEach((book) {
            if (book["status"] == "public") {
              listBuku.add(book);
            }
          });
        }
      }
    } catch (error) {
      return listBuku;
    }
    return listBuku;
  }

  static Future<HashMap<String, dynamic>> sendRequestBorrowBook(
    dynamic idBook,
  ) async {
    HashMap<String, dynamic> response2 = HashMap();
    response2["message"] = "Telah terjadi kesalahan";
    response2["isSuccess"] = false;
    try {
      var epoch = DateTime.now().millisecondsSinceEpoch;
      var response = await dio.post(
        "${Env.base_url}/models/book/borrowed/create-request.php",
        data: {
          "id_book": idBook,
          "id_user": Env.account["id"],
          "borrowed_at": epoch,
          "return_at": epoch * 60 * 60 * 24 * 14 * 1000,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        response2["message"] = data["message"];
        response2["isSuccess"] = data["isSuccess"];
      }
    } catch (error) {
      return response2;
    }
    return response2;
  }

  static Future<bool> sendRequestCancelBorrowBook(
    dynamic idBorrowedBook,
  ) async {
    bool isSuccess = false;
    try {
      var response = await dio.post(
        "${Env.base_url}/models/book/borrowed/delete.php",
        data: {"id_borrowed": idBorrowedBook},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (error) {
      return isSuccess;
    }
    return isSuccess;
  }

  static Future<List<dynamic>> showHistoryBorrowedBooks() async {
    HashMap<String, dynamic> response2 = HashMap();
    response2["message"] = "Telah terjadi kesalahan";
    response2["isSuccess"] = false;
    try {
      var response = await dio.get(
        "${Env.base_url}/models/book/borrowed/history.php",
        queryParameters: {"id": Env.account["id"]},
      );
      if (response.statusCode == 200) {
        var data = response.data;
        response2["message"] = data["message"];
        response2["isSuccess"] = data["isSuccess"];
        return List.from(data["data"]);
      }
    } catch (error) {
      return [];
    }
    return [];
  }
}
