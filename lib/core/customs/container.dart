import 'package:finpal/app/app.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({
    super.key,
    this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.image,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.scaleDownFactor = 0.95,
    this.animationDuration = const Duration(milliseconds: 100),
    this.showShadow = false,
    this.shadow,
    this.height,
    this.width,
    this.alignment,
  });

  final Widget? child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? image;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final double scaleDownFactor;
  final Duration animationDuration;
  final bool showShadow;
  final List<BoxShadow>? shadow;
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(16.r);
    final defaultPadding = widget.padding ?? EdgeInsets.all(16.r);
    final image = widget.image;

    final container = Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      padding: defaultPadding,
      alignment: widget.alignment,
      decoration: BoxDecoration(
        image:
            image != null
                ? DecorationImage(image: AssetImage(image), fit: BoxFit.cover)
                : null,
        color: widget.backgroundColor ?? context.colors.surface,
        borderRadius: defaultBorderRadius,
        border: widget.border,
        boxShadow:
            widget.showShadow
                ? widget.shadow ??
                    [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                : null,
      ),
      child: widget.child,
    );

    return AnimatedTap(
      onTap: widget.onTap,
      scaleDownFactor: widget.scaleDownFactor,
      animationDuration: widget.animationDuration,
      child: container,
    );
  }
}
