import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mic/function/currentuser.dart';
import 'package:mic/api/model/ocid.dart';

class Ocidservice {
  static const String baseUrl = "https://open.api.nexon.com/maplestory/v1/id";

  static Future<Ocid> getOcidByCharacterName(String characterName) async {
    final url = Uri.parse(
      '$baseUrl?character_name=${Uri.encodeQueryComponent(characterName)}',
    );

    final response = await http.get(
      url,
      headers: {"x-nxopen-api-key": ApiKey.apiKey},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // 응답 예: { "ocid": "xxxxxxxx..." }
      if (decoded is Map<String, dynamic> && decoded['ocid'] is String) {
        return Ocid.fromJson(decoded); // Ocid 모델이 {"ocid": "..."} 형태를 받는다고 가정
      }

      throw Exception("Unexpected JSON format: ${response.body}");
    }

    throw Exception("HTTP ${response.statusCode}: ${response.body}");
  }
}
