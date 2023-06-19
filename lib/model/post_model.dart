// To parse this JSON data, do
//
//     final personalList = personalListFromJson(jsonString);

import 'dart:convert';

PersonalList personalListFromJson(String str) =>
    PersonalList.fromJson(json.decode(str));

String personalListToJson(PersonalList data) => json.encode(data.toJson());

class PersonalList {
  String id;
  DateTime createdAt;

  PersonalList({
    required this.id,
    required this.createdAt,
  });

  factory PersonalList.fromJson(Map<String, dynamic> json) => PersonalList(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
      };
}
