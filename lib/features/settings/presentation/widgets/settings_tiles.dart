import 'package:finpal/app/app.dart';

class SettingsTiles extends ConsumerWidget {
  const SettingsTiles({super.key, required this.contents, this.title});

  final List<SettingsContentModel> contents;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = handleContents(ref, contents);
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          CustomTypography(
            text: title,
            fontType: FontType.body2Medium,
            color: context.colors.onSurface,
          ).padding(left: 8.r, bottom: 4.r),
        CustomContainer(
          backgroundColor: context.colors.surface,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListView.separated(
                itemCount: items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  return _settingsTile(context, items[index], ref);
                },
                separatorBuilder:
                    (_, index) =>
                        Divider(color: context.colors.outline, height: 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsTile(
    BuildContext context,
    SettingsContentModel items,
    WidgetRef ref,
  ) {
    final isDark = context.isDarkMode;
    final iconDarkColor = items.iconBgDarkColor ?? items.iconBgColor;

    return CustomContainer(
      animateOnTap: items.path.isNotEmpty,
      onTap: () => handleTap(context, items, ref),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Row(
        spacing: 12.spMin,
        children: [
          CustomContainer(
            padding: EdgeInsets.all(12.r),
            backgroundColor: isDark ? iconDarkColor : items.iconBgColor,
            child: CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: items.icon,
              color: items.iconColor,
              height: 16.spMin,
              width: 16.spMin,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.spMin,
              children: [
                CustomTypography(
                  text: items.title,
                  fontType: FontType.body2Medium,
                  maxLines: 1,
                ),
                if (items.subtitle.isNotEmpty)
                  CustomTypography(
                    text: items.subtitle,
                    fontType: FontType.label1Regular,
                    color: context.colors.onSurfaceVariant,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          if (items.actionText.isNotEmpty)
            CustomTypography(
              text: items.actionText,
              fontType: FontType.body2Medium,
              color: context.colors.onSurface,
            ),
          buildTrailingIcon(context, items, ref),
        ],
      ),
    );
  }

  Future<void> handleTap(
    BuildContext context,
    SettingsContentModel contents,
    WidgetRef ref,
  ) async {
    final isDark = context.isDarkMode;
    switch (contents.actionType) {
      case ActionType.navigate:
        if (contents.path.isNotEmpty) context.push(contents.path);
        break;
      case ActionType.launchUrl:
        if (contents.path.isEmpty) return;
        final launched = await hitUrl(contents.path);
        if (!launched && context.mounted) {
          context.showSnackBar(
            "Unable to open link",
            toastType: ToastType.error,
          );
        }
        break;
      case ActionType.toggle:
        if (contents.id == "hide_balance") {
          final newValue = !contents.value;
          ref.read(settingsNotifier.notifier).save(hideBalanceOnHome: newValue);
        }
        break;
      case ActionType.dialog:
        if (contents.id == "clear_data") {
          CustomDialog.show(
            context,
            icon: AppSvgs.bin,
            iconColor: AppColors.error500,
            iconBgColor:
                isDark ? AppColors.error700.withAlpha(50) : AppColors.error50,
            title: "Are you sure?",
            message:
                "This will permanently delete all your data including profile, transactions, categories and settings from Finpal. This action cannot be undone.",
            buttonText: "Clear All Data",
            buttonColor: AppColors.error500,
            onPressed: () => _clearData(context, ref),
          );
        }
        break;
      default:
        break;
    }
  }

  Future<void> _clearData(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(profileNotifier.notifier).clearData();
      await ref.read(transactionProvider.notifier).clearData();
      final options = ref.read(optionNotifer.notifier);
      await options.clearData();
      await options.saveAllOptions(OptionsConstant.allOptions);
      await ref
          .read(settingsNotifier.notifier)
          .save(
            isFirstVisit: false,
            isFingerprintEnabled: false,
            isPasscodeEnabled: false,
            currency: CurrencyContants.rupee,
            themeMode: ThemeMode.system,
            hideBalanceOnHome: false,
            dailyReminderEnabled: false,
            monthlyBudget: 0,
            aiInsightsEnabled: false,
          );
      if (context.mounted) {
        context.showSnackBar("Data cleared successfully");
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          "Failed to clear data",
          toastType: ToastType.error,
        );
      }
    }
  }

  Widget buildTrailingIcon(
    BuildContext context,
    SettingsContentModel items,
    WidgetRef ref,
  ) {
    if (items.actionType == ActionType.toggle) {
      return Switch(
        value: items.value,
        onChanged: (value) {
          if (items.id == "hide_balance") {
            ref.read(settingsNotifier.notifier).save(hideBalanceOnHome: value);
          }
        },
      );
    }
    if (items.actionType == ActionType.none) {
      return const SizedBox.shrink();
    }
    return CustomImage(
      imageType: ImageType.svgLocal,
      imageUrl: AppSvgs.arrowRight1,
      color: context.colors.onSurfaceVariant,
      height: 16.spMin,
    );
  }

  List<SettingsContentModel> handleContents(
    WidgetRef ref,
    List<SettingsContentModel> contents,
  ) {
    return contents.map((e) {
      if (e.id == "theme") {
        final themeMode = ref.watch(themeProvider);
        return e.copyWith(actionText: _titleCase(themeMode.name));
      }
      if (e.id == "currency") {
        final currency = ref.watch(currencyProvider);
        return e.copyWith(actionText: currency.currency);
      }
      if (e.id == "hide_balance") {
        final value =
            ref.watch(settingsNotifier).value?.hideBalanceOnHome ?? false;
        return e.copyWith(value: value);
      }

      return e;
    }).toList();
  }

  String _titleCase(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
