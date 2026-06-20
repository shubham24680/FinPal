import 'package:finpal/app/app.dart';

class FingerprintWidget extends ConsumerWidget {
  const FingerprintWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsNotifier).value;
    final isPasscodeEnabled = settingsState?.isPasscodeEnabled ?? false;
    final isFingerprintEnabled = settingsState?.isFingerprintEnabled ?? false;
    final fingerprint = ref.read(settingsNotifier.notifier);

    return Switch(
      value: isFingerprintEnabled,
      onChanged: (value) async {
        if (value) {
          await customBottomSheet(
            context,
            "Terms and Conditions",
            widget: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              child: Column(
                spacing: 32.w,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(
                    imageType: ImageType.svgLocal,
                    imageUrl: AppSvgs.fingerprint,
                    color: BGColors.shade700,
                    height: 100.w,
                  ),
                  _fingerprintTermsAndConditions(),
                  CustomButton(
                    label:
                        isPasscodeEnabled
                            ? "Enable Fingerprint"
                            : "Set Passcode to enable fingerprint",
                    onTap: () async {
                      if (!isPasscodeEnabled) {
                        context.push(AppRoutesPath.pinAuth.path);
                        return;
                      }
                      await _handleEnableFingerprint(context, fingerprint);
                      if (!context.mounted) return;
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          await fingerprint.save(isFingerprintEnabled: false);
          if (!context.mounted) return;
          showToast(context, "Fingerprint authentication disabled");
        }
      },
      inactiveTrackColor: BGColors.shade50,
      padding: EdgeInsets.zero,
    );
  }

  Widget _fingerprintTermsAndConditions() {
    List<String> termsAndConditions = [
      "Activating fingerprint authentication will allow a person whose fingerprint is enrolled on this device, now or in the future, to access your finance app.",
      "Once enabled, you can unlock the app by placing your finger on the fingerprint sensor.",
      "Once enabled, you can add income and expenses by placing your finger on the fingerprint sensor.",
    ];
    return Column(
      spacing: 16.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: termsAndConditions.map((e) => _bulletPoint(e)).toList(),
    );
  }

  Widget _bulletPoint(String text) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.circle,
          size: 8.w,
          color: PrimaryColors.shade300,
        ).padding(top: 4.w),
        Expanded(
          child: CustomTypography(text: text, fontType: FontType.body2Regular),
        ),
      ],
    );
  }

  Future<void> _handleEnableFingerprint(
    BuildContext context,
    SettingsNotifier fingerprint,
  ) async {
    final isCapable = await FingerprintServices.instance.isDeviceSupported();
    if (!isCapable) {
      if (!context.mounted) return;
      showToast(
        context,
        "Fingerprint authentication not supported",
        backgroundColor: NegativeColors.shade500,
      );
      return;
    }

    // final result = await FingerprintServices.instance.authenticate();
    // if (result != AuthResult.success) {
    //   if (!context.mounted) return;
    //   showToast(
    //     context,
    //     "Fingerprint authentication failed",
    //     backgroundColor: NegativeColors.shade500,
    //   );
    //   return;
    // }

    await fingerprint.save(isFingerprintEnabled: true);
    if (!context.mounted) return;
    showToast(context, "Fingerprint authentication enabled");
  }
}
