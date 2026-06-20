import 'package:finpal/app/app.dart';

class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.onChanged,
    required this.onBackspace,
    required this.onClear,
    this.isBiometricEnabled = false,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final bool isBiometricEnabled;

  static const _keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'clear',
    '0',
    'backspace',
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenType.isMobile;

    return Center(
      child: GridView.builder(
        itemCount: _keys.length,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 48.r),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.spMin,
          crossAxisSpacing: 8.spMin,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) => _pinKey(context, _keys[index]),
      ),
    );
  }

  Widget _pinKey(BuildContext context, String label) {
    return CustomContainer(
      onTap: () => _onTap(label),
      backgroundColor: _handleBgColor(context, label),
      borderRadius: BorderRadius.circular(12.r),
      alignment: Alignment.center,
      child: switch (label) {
        'clear' => CustomImage(
          imageType: ImageType.svgLocal,
          imageUrl: isBiometricEnabled ? AppSvgs.fingerprint : AppSvgs.cross,
          height: 28.spMin,
          color:
              isBiometricEnabled
                  ? context.colors.primary
                  : context.colors.inverseSurface,
        ),
        'backspace' => CustomImage(
          imageType: ImageType.svgLocal,
          imageUrl: AppSvgs.backspace,
          height: 28.spMin,
          color: context.colors.onInverseSurface,
        ),
        _ => CustomTypography(text: label, fontType: FontType.body1Semibold),
      },
    );
  }

  void _onTap(String key) {
    switch (key) {
      case 'clear':
        onClear();
      case 'backspace':
        onBackspace();
      default:
        onChanged(key);
    }
  }

  Color _handleBgColor(BuildContext context, String label) {
    return switch (label) {
      'clear' =>
        isBiometricEnabled
            ? context.colors.primaryContainer
            : context.colors.surfaceContainerHighest,
      _ => context.colors.surfaceContainerHighest,
    };
  }
}
