import 'dart:convert';

import 'package:http/http.dart';

extension DecodeRespose on Future<Response> {
  Future<T> decode<T>(T Function(Map<String, dynamic> json) fromJson) async {
    final body = (await this).body;
    return fromJson(jsonDecode(body));
  }
}

extension StringExtensions on String {
  Uri get uri => Uri.parse(this);
}
