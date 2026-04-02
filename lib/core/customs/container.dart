import 'package:finpal/app/app.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({
    super.key,
    this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.scaleDownFactor = 0.95,
    this.animationDuration = const Duration(milliseconds: 100),
    this.showShadow = false,
    this.height,
    this.width,
    this.alignment,
  });

  final Widget? child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final double scaleDownFactor;
  final Duration animationDuration;
  final bool showShadow;
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDownFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(16.r);
    final defaultPadding = widget.padding ?? EdgeInsets.all(16.w);

    final container = Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      padding: defaultPadding,
      alignment: widget.alignment,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? PrimaryColors.shade100,
        borderRadius: defaultBorderRadius,
        border: widget.border,
        boxShadow:
            widget.showShadow
                ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(
                      10,
                    ), // Used withAlpha instead of withOpacity
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: widget.child,
    );

    if (widget.onTap == null) {
      return container;
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(scale: _scaleAnimation, child: container),
    );
  }
}
