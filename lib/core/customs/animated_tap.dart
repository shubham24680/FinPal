import 'package:finpal/app/app.dart';

class AnimatedTap extends StatefulWidget {
  const AnimatedTap({
    super.key,
    required this.child,
    this.onTap,
    this.onLongTap,
    this.scaleDownFactor = 0.95,
    this.animationDuration = const Duration(milliseconds: 100),
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;
  final double scaleDownFactor;
  final Duration animationDuration;
  final HitTestBehavior behavior;

  @override
  State<AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap>
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
  void didUpdateWidget(AnimatedTap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (oldWidget.scaleDownFactor != widget.scaleDownFactor) {
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.scaleDownFactor,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    await _controller.forward();
    if (mounted) {
      await _controller.reverse();
    }
  }

  Future<void> _handleTap() async {
    widget.onTap?.call();
    await _playAnimation();
  }

  Future<void> _handleLongTap() async {
    widget.onLongTap?.call();
    await _playAnimation();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null && widget.onLongTap == null) {
      return widget.child;
    }

    return GestureDetector(
      onTap: widget.onTap == null ? null : _handleTap,
      onLongPress: widget.onLongTap == null ? null : _handleLongTap,
      behavior: widget.behavior,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
