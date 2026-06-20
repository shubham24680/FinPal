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
    final authProv = ref.read(authProvider.notifier);

    ref.listen(authProvider, (prev, next) {
      if (next.isUnlocked) {
        context.showSnackBar(
          "Unlock successful",
          toastType: ToastType.success,
        );
        if (context.mounted) {
          context.go(AppRoutesPath.home.path);
        }
        return;
      }
      if (next.toastType == ToastType.error) {
        context.showSnackBar(
          next.message ?? 'Something went wrong. Please try again.',
          toastType: next.toastType,
        );
        Future.delayed(const Duration(milliseconds: 800), () {
          authProv.onClear();
        });
      }
    });

    return ResponsiveBuilder(
      builder: (context, screenType) {
        final isMobile = screenType.isMobile;
        final items = [
          _buildTopItem(),
          _buildMainItem(context, isMobile: isMobile),
        ];

        return isMobile
            ? Stack(children: items)
            : Row(children: items.map((e) => Expanded(child: e)).toList());
      },
    );
  }

  Widget _buildTopItem() {
    return CustomImage(
      imageUrl: AppImages.securityScreen,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildMainItem(BuildContext context, {bool isMobile = true}) {
    final height = context.screenHeight;
    final bottomPadding = context.viewInsets.bottom;
    final onboardingState = ref.watch(onboardingProvider);
    final authState = ref.watch(authProvider);

    final child = SafeArea(
      top: !isMobile,
      left: isMobile,
      child: Column(
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(height: 20.spMin),
          CustomTypography(typos: authState.step.header),
          CustomTypography(
            text: authState.step.description,
            fontType: FontType.label1Regular,
            align: TextAlign.center,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(height: 20.spMin),
          _buildSecurityDetails(context),
          SizedBox(height: 20.spMin),
          buildPageIndicator(context, onboardingState),
          SizedBox(height: 20.spMin),
          CustomButton(
            buttonType: ButtonType.inherit,
            buttonState: ButtonState.enabled,
            label: "I'll do it later",
            onTap: () => context.go(AppRoutesPath.home.path),
          ),
          SizedBox(height: 20.spMin),
          Row(
            spacing: 8.spMin,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.lock,
                height: 24.spMin,
                color: context.colors.primary,
              ),
              Flexible(
                child: CustomTypography(
                  text:
                      "Your PIN is stored securely on this device only. We never upload it to any server.",
                  fontType: FontType.label1Regular,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 40.spMin),
        ],
      ),
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomContainer(
        height: isMobile ? null : height,
        backgroundColor: context.colors.surface,
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        borderRadius:
            isMobile
                ? BorderRadius.vertical(top: Radius.circular(24.r))
                : BorderRadius.zero,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSecurityDetails(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authProv = ref.read(authProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20.spMin,
      children: [
        PinDotsIndicator(
          length: authProv.pinLength,
          pin: authState.confirmPin,
          hasError: authState.toastType == ToastType.error,
        ),
        PinKeypad(
          onChanged: (digit) => authProv.onChanged(digit),
          onBackspace: authProv.onBackspace,
          onClear:
              authState.isBiometricEnabled
                  ? () => authProv.authenticateWithBiometric()
                  : authProv.onClear,
          isBiometricEnabled: authState.isBiometricEnabled,
        ).padding(horizontal: AppConstants.sidePadding),
      ],
    );
  }
}
