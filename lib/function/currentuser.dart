import 'package:intl/intl.dart';
import 'package:mic/model/ocid.dart';

class CurrentUser {
  // 1) 프로그램 전체에서 딱 1개만 존재하는 instance
  static final CurrentUser instance = CurrentUser._internal();

  // 2) private 생성자 → 외부에서 new 불가
  CurrentUser._internal();

  // 3) 여기에 로그인한 유저 정보를 담음
  Ocid? ocid;
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
