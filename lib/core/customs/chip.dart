import 'package:finpal/app/app.dart';

enum ChipVariant { primary, inactive }

enum ChipSize { extraSmall, small, medium, large, extraLarge }

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    this.variant = ChipVariant.primary,
    this.size = ChipSize.medium,
    this.label,
    this.imageUrl,
    this.imageType = ImageType.svgLocal,
    this.onTap,
    this.selected = false,
    this.outlined = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final ChipVariant variant;
  final ChipSize size;
  final String? label;
  final String? imageUrl;
  final ImageType imageType;
  final bool selected;
  final bool outlined;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final metrics = ChipMetrics.of(size);

    final colors = ChipColors.resolve(
      context: context,
      variant: variant,
      selected: selected,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: metrics.gap,
      children: [
        if (imageUrl != null)
          CustomImage(
            imageType: imageType,
            imageUrl: imageUrl,
            height: metrics.iconSize,
            width: metrics.iconSize,
            color: colors.foreground,
          ),
        if (label != null)
          CustomTypography(
            text: label,
            fontType: metrics.fontType,
            color: colors.foreground,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );

    return CustomContainer(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding,
        vertical: metrics.verticalPadding,
      ),
      backgroundColor:
          (outlined && !selected) ? Colors.transparent : colors.background,
      borderRadius: BorderRadius.circular(metrics.borderRadius),
      border: Border.all(color: colors.border, width: metrics.borderWidth),
      child: content,
    );
  }
}

class ChipMetrics {
  const ChipMetrics({
    required this.minHeight,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.gap,
    required this.fontType,
    required this.borderRadius,
    required this.borderWidth,
  });

  final double minHeight;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double gap;
  final FontType fontType;
  final double borderRadius;
  final double borderWidth;

  static ChipMetrics of(ChipSize size) => switch (size) {
    ChipSize.extraSmall => ChipMetrics(
      minHeight: 24.spMin,
      horizontalPadding: 8.r,
      verticalPadding: 4.r,
      iconSize: 12.spMin,
      gap: 4.r,
      fontType: FontType.label2Regular,
      borderRadius: 12.r,
      borderWidth: 1.r,
    ),
    ChipSize.small => ChipMetrics(
      minHeight: 28.spMin,
      horizontalPadding: 10.r,
      verticalPadding: 5.r,
      iconSize: 14.spMin,
      gap: 5.r,
      fontType: FontType.label1Regular,
      borderRadius: 14.r,
      borderWidth: 1.r,
    ),
    ChipSize.medium => ChipMetrics(
      minHeight: 32.spMin,
      horizontalPadding: 12.r,
      verticalPadding: 6.r,
      iconSize: 16.spMin,
      gap: 6.r,
      fontType: FontType.body2Medium,
      borderRadius: 16.r,
      borderWidth: 1.r,
    ),
    ChipSize.large => ChipMetrics(
      minHeight: 36.spMin,
      horizontalPadding: 14.r,
      verticalPadding: 7.r,
      iconSize: 18.spMin,
      gap: 7.r,
      fontType: FontType.body2Medium,
      borderRadius: 18.r,
      borderWidth: 1.5.r,
    ),
    ChipSize.extraLarge => ChipMetrics(
      minHeight: 40.spMin,
      horizontalPadding: 16.r,
      verticalPadding: 8.r,
      iconSize: 20.spMin,
      gap: 8.r,
      fontType: FontType.body1Medium,
      borderRadius: 20.r,
      borderWidth: 1.5.r,
    ),
  };
}

class ChipColors {
  const ChipColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;

  factory ChipColors.resolve({
    required BuildContext context,
    ChipVariant variant = ChipVariant.primary,
    bool selected = false,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (variant) {
      ChipVariant.primary =>
        selected
            ? ChipColors(
              background: scheme.primary,
              foreground: scheme.surface,
              border: scheme.primary,
            )
            : ChipColors(
              background: scheme.primaryContainer,
              foreground: scheme.inversePrimary,
              border: scheme.onPrimaryContainer,
            ),
      ChipVariant.inactive =>
        selected
            ? ChipColors(
              background: scheme.secondary,
              foreground: scheme.surface,
              border: scheme.secondary,
            )
            : ChipColors(
              background: scheme.secondaryContainer,
              foreground: scheme.secondary,
              border: scheme.onSecondaryContainer,
            ),
    };

    return ChipColors(
      background: backgroundColor ?? color.background,
      foreground: foregroundColor ?? color.foreground,
      border: borderColor ?? color.border,
    );
  }
}
