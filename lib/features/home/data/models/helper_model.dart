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
