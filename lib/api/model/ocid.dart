class Ocid {
  final String ocid;

  const Ocid({required this.ocid});

  factory Ocid.fromJson(Map<String, dynamic> json) {
    return Ocid(
      ocid: json['ocid'], // JSON → Dart 매핑;
    );
  }
}
