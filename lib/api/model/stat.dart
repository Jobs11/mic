class Stat {
  final String statName; // 스탯 이름
  final String statValueRaw; // 원본 값 (문자열)
  final double? statValueNum; // 숫자로 변환된 값 (가능하면 사용)

  Stat({required this.statName, required this.statValueRaw, this.statValueNum});

  factory Stat.fromJson(Map<String, dynamic> json) {
    final raw = json['stat_value']?.toString() ?? '';
    final parsed = double.tryParse(raw);

    return Stat(
      statName: json['stat_name'] as String? ?? '',
      statValueRaw: raw,
      statValueNum: parsed,
    );
  }
}
