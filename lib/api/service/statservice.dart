import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mic/function/currentuser.dart';
import 'package:mic/api/model/stat.dart';

class Statservice {
  static const String baseUrl =
      "https://open.api.nexon.com/maplestory/v1/character/stat";

  static Future<List<Stat>> getStat(String ocid) async {
    final uri = Uri.parse("$baseUrl?ocid=$ocid");

    final response = await http.get(
      uri,
      headers: {"x-nxopen-api-key": ApiKey.apiKey},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final list = decoded['final_stat'] as List<dynamic>? ?? [];
        return list
            .map((e) => Stat.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("Unexpected JSON format: ${response.body}");
    }

    throw Exception("HTTP ${response.statusCode}: ${response.body}");
  }
}
