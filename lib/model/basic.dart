class Basic {
  final String charactername;
  final String worldname;
  final String charactergender;
  final String characterclass;
  final String characterclasslevel;
  final int characterlevel;
  final int characterexp;
  final String characterexprate;
  final String characterimage;

  Basic({
    required this.charactername,
    required this.worldname,
    required this.charactergender,
    required this.characterclass,
    required this.characterclasslevel,
    required this.characterlevel,
    required this.characterexp,
    required this.characterexprate,
    required this.characterimage,
  });

  factory Basic.fromJson(Map<String, dynamic> json) {
    return Basic(
      charactername: json['character_name'] as String, // JSON → Dart 매핑;
      worldname: json['world_name'] as String,
      charactergender: json['character_gender'] as String,
      characterclass: json['character_class'] as String,
      characterclasslevel: json['character_class_level'] as String,
      characterlevel: (json['character_level'] as num).toInt(),
      characterexp: (json['character_exp'] as num).toInt(),
      characterexprate: json['character_exp_rate'] as String,
      characterimage: json['character_image'] as String,
    );
  }
}
