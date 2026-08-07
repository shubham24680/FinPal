import 'package:finpal/app/app.dart';

extension ClickExtension on Widget {
  Widget _gestureDetector({
    void Function()? onTap,
    void Function()? onLongTap,
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) => GestureDetector(
    onTap: onTap ?? () {},
    onLongPress: onLongTap ?? () {},
    behavior: behavior,
    child: this,
  );

  Widget onTap({
    void Function()? event,
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) => _gestureDetector(onTap: event, behavior: behavior);

  Widget onLongTap({
    void Function()? event,
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) => _gestureDetector(onLongTap: event, behavior: behavior);

  Widget animatedTap({
    void Function()? onTap,
    double scaleDownFactor = 0.95,
    Duration animationDuration = const Duration(milliseconds: 100),
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) => AnimatedTap(
    onTap: onTap,
    scaleDownFactor: scaleDownFactor,
    animationDuration: animationDuration,
    behavior: behavior,
    child: this,
  );
}
