import 'package:finpal/app/app.dart';

class PersonalDetailsScreen extends ConsumerWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        final isMobile = screenType.isMobile;
        final items = [
          _buildTopItem(),
          _buildMainItem(ref, context, isMobile: isMobile),
        ];

        return isMobile
            ? Stack(children: items)
            : Row(children: items.map((e) => Expanded(child: e)).toList());
      },
    );
  }

  Widget _buildTopItem() {
    return CustomImage(
      imageUrl: AppImages.personalDetailsScreen,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildMainItem(
    WidgetRef ref,
    BuildContext context, {
    bool isMobile = true,
  }) {
    final height = context.screenHeight;
    final bottomPadding = context.viewInsets.bottom;
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final title = [
      OnboardingTypographyModel(text: "Tell us a little about"),
      OnboardingTypographyModel(
        text: "\n yourself.",
        color: AppColors.primary500,
      ),
    ];

    final child = SafeArea(
      top: !isMobile,
      left: isMobile,
      child: Column(
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(height: 20.spMin),
          onboardingTypo(context, title),
          CustomTypography(
            text:
                "This will help us personalize your experience.\n All data stays on your device.",
            fontType: FontType.label1Regular,
            align: TextAlign.center,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          _buildPersonalDetails(context, ref),
          SizedBox(height: 32.spMin),
          buildPageIndicator(context, onboardingState),
          SizedBox(height: 24.spMin),
          CustomButton(
            buttonState: onboardingState.buttonState,
            label: "Add Details",
            onTap: () => onboardingNotifier.next(),
          ),
          SizedBox(height: 40.spMin),
        ],
      ),
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomContainer(
        height: isMobile ? null : height,
        backgroundColor: Theme.of(context).colorScheme.surface,
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

  Widget _buildPersonalDetails(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final gender = [
      ["Male", AppSvgs.male],
      ["Female", AppSvgs.female],
      ["Other", AppSvgs.user],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.spMin,
      children: [
        SizedBox(height: 16.spMin),
        CustomTextField(
          controller: onboardingState.nameController,
          onChanged: (value) => onboardingNotifier.setName(value ?? ""),
          header: "FULL NAME",
          hintText: "Shubham Patel",
          perfixIcon: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.user,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        CustomTextField(
          controller: onboardingState.dateOfBirthController,
          inputType: InputType.date,
          header: "DATE OF BIRTH",
          onChanged: (value) => onboardingNotifier.setDob(value ?? ""),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTypography(
              text: "GENDER",
              fontType: FontType.body2Medium,
              color: Theme.of(context).colorScheme.onSurface,
            ).padding(left: 4.r, bottom: 2.r),
            Wrap(
              spacing: 8.spMin,
              runSpacing: 8.spMin,
              children:
                  gender.map((e) {
                    final selected = e[0] == onboardingState.gender;
                    return CustomChip(
                      variant:
                          selected ? ChipVariant.primary : ChipVariant.inactive,
                      outlined: true,
                      label: e[0],
                      imageUrl: e[1],
                      selected: selected,
                      onTap: () => onboardingNotifier.setGender(e[0]),
                    );
                  }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
