import 'package:finpal/app/app.dart';


class NavModel {
  String id;
  Widget page;
  String? selectedIcon;
  String? unselectedIcon;
  String? title;

  NavModel({
    required this.id,
    required this.page,
    this.selectedIcon,
    this.unselectedIcon,
    this.title,
  });
}

// class HelperModel {
//   PathType pathType;
//   String? icon;
//   String? title;
//   String? screenPath;
//   ExtraModel? extra;
//   ProfileAction action;

//   HelperModel({
//     this.pathType = PathType.screenPath,
//     this.icon,
//     this.title,
//     this.screenPath,
//     this.extra,
//     this.action = ProfileAction.navigate,
//   });
// }
