import 'package:finpal/app/app.dart';

class NavModel {
  String icon;
  Widget screenPath;

  NavModel({required this.icon, required this.screenPath});
}

enum PathType { screenPath, urlPath }

class HelperModel {
  PathType pathType;
  String? icon;
  String? title;
  String? screenPath;
  ExtraModel? extra;

  HelperModel({
    this.pathType = PathType.screenPath,
    this.icon,
    this.title,
    this.screenPath,
    this.extra,
  });
}
