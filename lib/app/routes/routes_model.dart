class ExtraModel {
  final String type;
  final String? title;

  ExtraModel({required this.type, this.title});

  factory ExtraModel.fromJson(Map<String, dynamic> json) =>
      ExtraModel(type: json["type"], title: json["title"]);

  Map<String, dynamic> toJson() => {"type": type, "title": title};
}
