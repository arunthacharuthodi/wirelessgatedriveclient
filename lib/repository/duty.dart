import 'dart:convert';

import 'package:http/http.dart' as http;

class DutyRepo {
  Future<void> updateDuty(int duty) async {
    var post_body = jsonEncode({"duty": duty});
    try {
      final response = await http.post(
          Uri(
            host: "192.168.1.8",
            path: "dutycycle",
            port: 3000,
            scheme: "http",
          ),
          // encoding: Utf8Codec(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': "*/*",
            'connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate, br',
          },
          body: post_body);
      print(response);
    } catch (e) {
      print(e);
    }
  }
}
