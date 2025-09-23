import 'package:intl/intl.dart';
import 'package:mic/api/model/basic.dart';
import 'package:mic/api/model/ocid.dart';

class CurrentUser {
  // 1) 프로그램 전체에서 딱 1개만 존재하는 instance
  static final CurrentUser instance = CurrentUser._internal();

  // 2) private 생성자 → 외부에서 new 불가
  CurrentUser._internal();

  // 3) 여기에 로그인한 유저 정보를 담음
  Ocid? ocid;
}

class CurrentCharacter {
  // 1) 프로그램 전체에서 딱 1개만 존재하는 instance
  static final CurrentCharacter instance = CurrentCharacter._internal();

  // 2) private 생성자 → 외부에서 new 불가
  CurrentCharacter._internal();

  // 3) 여기에 로그인한 유저 정보를 담음
  Basic? basic;
}

class ApiKey {
  static const String apiKey =
      "live_da6f72d9c70b2283a2c35e3028a299350e412e2aabd496681ef9be1a8d975d88efe8d04e6d233bd35cf2fabdeb93fb0d";
}

class Bossdata {
  static final List<Map<String, dynamic>> bossList = [];
}

String formatNumber(num value) {
  final formatter = NumberFormat('#,###');
  return formatter.format(value);
}

String formatPower(int number) {
  if (number == 0) return "0";

  int jo = number ~/ 1000000000000; // 조 단위 (10¹²)
  int eok = (number % 1000000000000) ~/ 100000000; // 억 단위
  int man = (number % 100000000) ~/ 10000; // 만 단위
  int rest = number % 10000; // 나머지

  StringBuffer result = StringBuffer();

  if (jo > 0) {
    result.write("$jo조");
    if (eok > 0 || man > 0 || rest > 0) result.write(" ");
  }

  if (eok > 0) {
    result.write("$eok억");
    if (man > 0 || rest > 0) result.write(" ");
  }

  if (man > 0) {
    result.write("$man만");
    if (rest > 0) result.write(" ");
  }

  if (rest > 0) {
    result.write("$rest");
  }

  return result.toString();
}
