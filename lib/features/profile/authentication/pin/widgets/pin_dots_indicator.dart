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

  Color _colorFor(bool isFilled) {
    if (hasError) return NegativeColors.shade700;
    if (isFilled) return PrimaryColors.shade500;
    return TextColors.shade900;
  }

  @override
  Widget build(BuildContext context) {
    final diameter = size ?? 10.w;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: spacing ?? 16.w,
      children: List.generate(length, (index) {
        final isFilled = index < pin.length;
        final isFilledObscured = obscure || !isFilled;

        return AnimatedContainer(
          duration: animationDuration,
          margin:
              (obscure || isFilled)
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(vertical: 8.w),
          padding: isFilledObscured ? EdgeInsets.zero : EdgeInsets.all(8.w),
          height: isFilledObscured ? diameter : null,
          width: isFilledObscured ? diameter : null,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _colorFor(isFilled),
          ),
          child: isFilledObscured ? null : CustomTypography(text: pin[index]),
        );
      }),
    );
  }
}
