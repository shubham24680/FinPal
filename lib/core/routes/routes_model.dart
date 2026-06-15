class ExtraModel {
  final String? id;
  final String? type;
  final String? icon;
  final String? title;

  ExtraModel({this.id, this.type, this.icon, this.title});

  factory ExtraModel.fromJson(Map<String, dynamic> json) => ExtraModel(
    id: json["id"],
    type: json["type"],
    icon: json["icon"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "icon": icon,
    "title": title,
  };
}
