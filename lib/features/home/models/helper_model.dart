import 'package:finpal/app/app.dart';

enum PathType { screenPath, urlPath, defaultPath }

enum ProfileAction { toggle, navigate }

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
  ProfileAction action;

  HelperModel({
    this.pathType = PathType.screenPath,
    this.icon,
    this.title,
    this.screenPath,
    this.extra,
    this.action = ProfileAction.navigate,
  });
}
