import 'package:finpal/app/app.dart';

class PinDotsIndicator extends StatelessWidget {
  const PinDotsIndicator({
    super.key,
    required this.length,
    required this.pin,
    this.hasError = false,
    this.obscure = true,
    this.spacing,
    this.size,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  final int length;
  final String pin;
  final bool hasError;
  final bool obscure;
  final double? spacing;
  final double? size;
  final Duration animationDuration;

  Color _colorFor(BuildContext context, bool isFilled) {
    if (hasError) return context.colors.error;
    if (isFilled) return context.colors.primary;
    return context.colors.inverseSurface;
  }

  @override
  Widget build(BuildContext context) {
    final diameter = size ?? 10.r;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: spacing ?? 16.r,
      children: List.generate(length, (index) {
        final isFilled = index < pin.length;
        final isFilledObscured = obscure || !isFilled;

        return AnimatedContainer(
          duration: animationDuration,
          margin:
              (obscure || isFilled)
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(vertical: 8.r),
          padding: isFilledObscured ? EdgeInsets.zero : EdgeInsets.all(8.r),
          height: isFilledObscured ? diameter : null,
          width: isFilledObscured ? diameter : null,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? _colorFor(context, isFilled) : Colors.transparent,
            border: Border.all(
              color: _colorFor(context, isFilled),
              width: 1.r,
            ),
          ),
          child:
              isFilledObscured
                  ? null
                  : CustomTypography(
                    text: pin[index],
                    fontType: FontType.body1Semibold,
                    color: context.colors.surface,
                  ),
        );
      }),
    );
  }
}
