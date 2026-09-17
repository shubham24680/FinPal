import 'package:finpal/app/app.dart';

extension PaddingExtension on Widget {
  Widget padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
    EdgeInsetsGeometry? padding,
  }) {
    final leftPadding = all ?? horizontal ?? left ?? 0;
    final rightPadding = all ?? horizontal ?? right ?? 0;
    final topPadding = all ?? vertical ?? top ?? 0;
    final bottomPadding = all ?? vertical ?? bottom ?? 0;

    return Padding(
      padding:
          padding ??
          EdgeInsets.fromLTRB(
            leftPadding,
            topPadding,
            rightPadding,
            bottomPadding,
          ),
      child: this,
    );
  }
}
