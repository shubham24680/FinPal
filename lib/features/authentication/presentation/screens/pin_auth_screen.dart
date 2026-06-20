import 'package:finpal/app/app.dart';

class PinAuthScreen extends ConsumerWidget {
  const PinAuthScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authProv = ref.read(authProvider.notifier);

    ref.listen(authProvider, (prev, next) {
      if ((next.toastType == ToastType.error)) {
        showToast(
          context,
          next.message ?? 'Something went wrong. Please try again.',
          backgroundColor: NegativeColors.shade500,
        );
        Future.delayed(const Duration(milliseconds: 800), () {
          authProv.onClear();
        });
      }
      if (next.toastType == ToastType.success) {
        showToast(
          context,
          next.message ?? "Something went wrong. Please try again.",
          backgroundColor: TextColors.shade900,
        );
        if (context.mounted) {
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: customAppBar(context, title: authState.step.description),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                CustomTypography(
                  text: authState.step.description,
                  fontType: FontType.h2Semibold,
                  align: TextAlign.center,
                ),
                CustomTypography(
                  text: authState.step.description,
                  fontType: FontType.body2Regular,
                  color: TextColors.shade700,
                  align: TextAlign.center,
                ).padding(
                  horizontal: AppConstants.sidePadding,
                  bottom: 24.w,
                  top: 8.w,
                ),
                PinDotsIndicator(
                  length: authProv.pinLength,
                  pin: authState.confirmPin,
                  hasError: authState.toastType == ToastType.error,
                  obscure: authState.step != PinScreen.create,
                ),
              ],
            ),
            Expanded(
              child: PinKeypad(
                onChanged: (digit) => authProv.onChanged(digit),
                onBackspace: authProv.onBackspace,
                onClear: authProv.onClear,
              ).padding(horizontal: AppConstants.sidePadding),
            ),
          ],
        ),
      ),
    );
  }
}
