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
    return Center(
      child: GridView.builder(
        itemCount: _keys.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.w,
          crossAxisSpacing: 8.w,
          childAspectRatio: 1,
        ),
        itemBuilder:
            (context, index) =>
                _pinKey(label: _keys[index], onTap: () => _onTap(_keys[index])),
      ),
    );
  }

  Widget _pinKey({required String label, required VoidCallback onTap}) {
    return CustomContainer(
      onTap: onTap,
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.all(4.w),
      backgroundColor: BGColors.shade300,
      borderRadius: BorderRadius.circular(1000.r),
      alignment: Alignment.center,
      child: switch (label) {
        'clear' => CustomImage(
          imageType: ImageType.svgLocal,
          imageUrl: isBiometricEnabled ? AppSvgs.fingerprint : AppSvgs.cross,
          height: 28.w,
          color: TextColors.shade800,
        ),
        'backspace' => CustomImage(
          imageType: ImageType.svgLocal,
          imageUrl: AppSvgs.backspace,
          height: 28.w,
          color: TextColors.shade800,
        ),
        _ => CustomTypography(
          text: label,
          fontType: FontType.body1Semibold,
          color: TextColors.shade800,
        ),
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
}
