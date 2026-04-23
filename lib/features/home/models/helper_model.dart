import 'package:finpal/app/app.dart';

enum PathType { screenPath, urlPath, defaultPath }

class NavModel {
  String icon;
  PathType pathType;
  String? screenPath;
  Widget defaultPath;

  NavModel({
    required this.icon,
    required this.defaultPath,
    this.screenPath,
    this.pathType = PathType.defaultPath,
  });
}

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
