import 'dart:io';
import 'package:finpal/app/app.dart';

Widget transTitle(
  BuildContext context,
  String title, {
  bool isMandatory = false,
}) {
  return Row(
    spacing: 4.spMin,
    children: [
      CustomTypography(
        text: title,
        fontType: FontType.label1Bold,
        color: context.colors.onSurface,
      ),
      if (isMandatory)
        CustomTypography(
          text: UnicodeConstants.asterisk,
          fontType: FontType.label1Bold,
          color: context.colors.error,
        ),
    ],
  );
}

void showReceiptPreview(BuildContext context, String path) {
  final widget = ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: Image.file(File(path)),
  );
  CustomBottomSheet.show(context, child: widget, title: "Receipt Preview");
}

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;
  static const double _strokeWidth = 1.5;
  static const double _dashLength = 6;
  static const double _gapLength = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = _strokeWidth
          ..style = PaintingStyle.stroke;

    final path =
        Path()..addRRect(
          RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
        );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashLength;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color || radius != oldDelegate.radius;
}
