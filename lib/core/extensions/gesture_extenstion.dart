import 'package:finpal/app/app.dart';

extension ClickExtension on Widget {
  Widget _gestureDetector({
    void Function()? onTap,
    void Function()? onLongTap,
  }) => GestureDetector(
    onTap: onTap ?? () {},
    onLongPress: onLongTap ?? () {},
    child: this,
  );

  Widget onTap({void Function()? event}) => _gestureDetector(onTap: event);

  Widget onLongTap({void Function()? event}) =>
      _gestureDetector(onLongTap: event);
}
