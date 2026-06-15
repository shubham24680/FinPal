import 'package:finpal/app/app.dart';

typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, ScreenType screenType);

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    this.builder,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : assert(
         builder != null || mobile != null || tablet != null || desktop != null,
         'Provide builder or at least one of mobile, tablet, desktop.',
       );

  final ResponsiveWidgetBuilder? builder;
  final WidgetBuilder? mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = ScreenType.fromWidth(constraints.maxWidth);
        final builder = this.builder;

        if (builder != null) {
          return builder(context, screenType);
        }

        return switch (screenType) {
          ScreenType.mobile =>
            mobile?.call(context) ??
                tablet?.call(context) ??
                desktop?.call(context) ??
                SizedBox.shrink(),
          ScreenType.tablet =>
            tablet?.call(context) ??
                mobile?.call(context) ??
                desktop?.call(context) ??
                SizedBox.shrink(),
          ScreenType.desktop =>
            desktop?.call(context) ??
                tablet?.call(context) ??
                mobile?.call(context) ??
                SizedBox.shrink(),
        };
      },
    );
  }
}

/// Centers content and caps width on tablet/desktop.
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        final horizontal =
            padding ??
            EdgeInsets.symmetric(
              horizontal: context.responsive<double>(
                mobile: 16.spMin,
                tablet: 24.spMin,
                desktop: 32.spMin,
              ),
            );

        return Padding(
          padding: horizontal,
          child: Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    screenType.isMobile
                        ? double.infinity
                        : ResponsiveBreakpoints.maxContentWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
