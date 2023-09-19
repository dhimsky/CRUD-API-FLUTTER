import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;

class Repository {
  final _baseUrl = 'http://192.168.1.83:9000';

  Future<List<Book>> getData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + '/book'));

      if (response.statusCode == 200) {
        // print(response.body);
        final List<dynamic> jsonDataList =
            jsonDecode(response.body) as List<dynamic>;
        List<Book> bookList =
            jsonDataList.map((e) => Book.fromJson(e)).toList();
        return bookList;
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  Future postData(String name, int price, String desc) async {
    try {
      final response = await http.post(Uri.parse(_baseUrl + '/book'),
          body: jsonEncode({"name": name, "price": price, "desc": desc}),
          headers: {
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error saat menambah data: $e');
      return false;
    }
  }

  Future<bool> putData(BigInt id, String name, int price, String desc) async {
    try {
      final response = await http.put(
        Uri.parse(_baseUrl + '/book/' + id.toString()),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "price": price,
          "desc": desc,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future deleteData(BigInt id) async {
    try {
      final response = await http.delete(
        Uri.parse(_baseUrl + '/book/' + id.toString()),
      );
      if (response == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
