import 'package:finpal/app/app.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  final List<ThemeMode> _themeModes = ThemeMode.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedThemeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: customAppBar(context, title: "Theme"),
      body: CustomContainer(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(AppConstants.sidePadding),
        child: ListView.separated(
          itemCount: _themeModes.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final themeMode = _themeModes[index];
            final name =
                themeMode.name.substring(0, 1).toUpperCase() +
                themeMode.name.substring(1).toLowerCase();
            final isSelected = selectedThemeMode == themeMode;
            final borderColor =
                isSelected
                    ? context.colors.primary
                    : context.colors.onSurfaceVariant;
            final borderWidth = isSelected ? 3.spMin : 1.spMin;
            final backgroundColor =
                isSelected
                    ? context.colors.surface
                    : context.colors.onSurfaceVariant.withAlpha(50);

            return CustomContainer(
              onTap:
                  () => ref
                      .read(settingsNotifier.notifier)
                      .save(themeMode: themeMode.name),
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTypography(text: name, fontType: FontType.body2Medium),
                  CustomContainer(
                    height: 20.spMin,
                    width: 20.spMin,
                    backgroundColor: backgroundColor,
                    border: Border.all(color: borderColor, width: borderWidth),
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
