import 'dart:developer';

import 'package:finpal/app/app.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with WidgetsBindingObserver {
  bool _status = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   launchBiometric();
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    setState(() {
      if (state == AppLifecycleState.resumed && _status) {
        launchBiometric();
        _status = false;
      } else if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.detached) {
        _status = true;
      }
    });

    log("status: $_status");
  }

  Future<void> launchBiometric() async {
    await ref.read(authProvider.notifier).authenticateWithBiometric();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authProv = ref.read(authProvider.notifier);
    final avatarUrl = AppImages.avatar[authState.profilePicIndex];

    ref.listen(authProvider, (prev, next) {
      if (next.isUnlocked) {
        context.go(AppRoutesPath.home.path);
        return;
      }
      if (next.toastType == ToastType.error) {
        showToast(
          context,
          next.message ?? 'Something went wrong. Please try again.',
          backgroundColor: NegativeColors.shade500,
        );
        Future.delayed(const Duration(milliseconds: 800), () {
          authProv.onClear();
        });
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                CustomContainer(
                  margin: EdgeInsets.only(top: 32.w, bottom: 16.w),
                  padding: EdgeInsets.all(2.w),
                  borderRadius: BorderRadius.circular(1000.r),
                  backgroundColor: CardColors.shade1000,
                  height: 64.w,
                  width: 64.w,
                  child: ClipOval(
                    child: CustomImage(
                      imageType: ImageType.local,
                      imageUrl: avatarUrl,
                    ),
                  ),
                ),
                CustomTypography(
                  text: authState.step.header,
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
                ),
              ],
            ),
            Expanded(
              child: PinKeypad(
                onChanged: (digit) => authProv.onChanged(digit),
                onBackspace: authProv.onBackspace,
                onClear:
                    authState.isBiometricEnabled
                        ? () => authProv.authenticateWithBiometric()
                        : authProv.onClear,
                isBiometricEnabled: authState.isBiometricEnabled,
              ).padding(horizontal: AppConstants.sidePadding),
            ),
          ],
        ),
      ),
    );
  }
}
