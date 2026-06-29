import 'package:finpal/app/app.dart';

class SwipeActionRow extends StatefulWidget {
  const SwipeActionRow({
    super.key,
    required this.child,
    this.onEdit,
    this.onDelete,
    this.actionExtent = 80,
    this.backgroundColor = BGColors.shade500,
  });

  final Widget child;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final double actionExtent;
  final Color backgroundColor;

  @override
  State<SwipeActionRow> createState() => _SwipeActionRowState();
}

class _SwipeActionRowState extends State<SwipeActionRow>
    with SingleTickerProviderStateMixin {
  double _offset = 0;
  late final AnimationController _snap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  Animation<double>? _snapAnim;

  double get _maxRevealRight => widget.onEdit != null ? widget.actionExtent : 0;
  double get _maxRevealLeft =>
      widget.onDelete != null ? widget.actionExtent : 0;

  @override
  void initState() {
    super.initState();
    _snap.addListener(_onSnapTick);
  }

  void _onSnapTick() {
    if (!mounted || _snapAnim == null) return;
    setState(() => _offset = _snapAnim!.value);
  }

  @override
  void dispose() {
    _snap.removeListener(_onSnapTick);
    _snap.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _snap.stop();
    _snapAnim = Tween<double>(
      begin: _offset,
      end: target,
    ).animate(CurvedAnimation(parent: _snap, curve: Curves.easeOutCubic));
    _snap.forward(from: 0);
  }

  void _onDragEnd(DragEndDetails details) {
    final v = details.velocity.pixelsPerSecond.dx;
    const fling = 700;

    if (_maxRevealLeft > 0 &&
        (_offset < -widget.actionExtent / 2 || v < -fling)) {
      _animateTo(-_maxRevealLeft);
      return;
    }
    if (_maxRevealRight > 0 &&
        (_offset > widget.actionExtent / 2 || v > fling)) {
      _animateTo(_maxRevealRight);
      return;
    }
    _animateTo(0);
  }

  Future<void> _closeThenRun(VoidCallback action) async {
    if (_offset == 0) {
      action();
      return;
    }
    _snap.stop();
    _snapAnim = Tween<double>(
      begin: _offset,
      end: 0,
    ).animate(CurvedAnimation(parent: _snap, curve: Curves.easeOutCubic));
    await _snap.forward(from: 0);
    if (!mounted) return;
    action();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onEdit == null && widget.onDelete == null) {
      return widget.child;
    }

    return ClipRect(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // if (widget.onEdit != null)
                //   _buildActionButton(AppSvgs.edit, onTap: widget.onEdit),
                // const Spacer(),
                // if (widget.onDelete != null)
                //   _buildActionButton(
                //     AppSvgs.delete,
                //     onTap: widget.onDelete,
                //     backgroundColor: NegativeColors.shade800,
                //   ),
              ],
            ),
          ),
          GestureDetector(
            onHorizontalDragStart: (_) => _snap.stop(),
            onHorizontalDragUpdate: (details) {
              setState(() {
                _offset = (_offset + details.delta.dx).clamp(
                  -_maxRevealLeft,
                  _maxRevealRight,
                );
              });
            },
            onHorizontalDragEnd: _onDragEnd,
            behavior: HitTestBehavior.translucent,
            child: Transform.translate(
              offset: Offset(_offset, 0),
              child: Material(
                color: widget.backgroundColor,
                elevation: 0,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String imageUrl, {
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return SizedBox(
      width: widget.actionExtent,
      child: Material(
        color: backgroundColor ?? CardColors.shade1000,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              _closeThenRun(onTap);
            }
          },
          child: Center(
            child: CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: imageUrl,
              color: iconColor ?? Colors.white,
              height: 24.w,
              width: 24.w,
            ),
          ),
        ),
      ),
    );
  }
}
