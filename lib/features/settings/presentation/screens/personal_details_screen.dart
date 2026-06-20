import 'package:finpal/app/app.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController dateOfBirthController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dateOfBirthController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    if (onboardingState.buttonState == ButtonState.loading) {
      return SplashScreen();
    }

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
    return Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.passthrough,
      children: [
        CustomImage(
          imageUrl: AppImages.personalDetailsScreen,
          fit: BoxFit.fitWidth,
        ),
        Align(
          alignment: Alignment.topRight,
          child: CustomChip(
            label: "Skip",
            onTap: () async {
              await ref.read(onboardingProvider.notifier).setupDefaultData();
            },
          ),
        ).padding(top: context.viewPadding.top, right: 16.r),
      ],
    );
  }

  Widget _buildMainItem(BuildContext context, {bool isMobile = true}) {
    final height = context.screenHeight;
    final bottomPadding = context.viewInsets.bottom;
    final onboardingState = ref.watch(onboardingProvider);
    final personalDetailsState = ref.watch(profileProvider);
    final title = [
      TypographyModel(text: "Tell us a little about"),
      TypographyModel(
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
          CustomTypography(typos: title),
          CustomTypography(
            text:
                "This will help us personalize your experience.\n All data stays on your device.",
            fontType: FontType.label1Regular,
            align: TextAlign.center,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          _buildPersonalDetails(context),
          SizedBox(height: 32.spMin),
          buildPageIndicator(context, onboardingState),
          SizedBox(height: 24.spMin),
          CustomButton(
            buttonState: personalDetailsState.buttonState,
            label: "Add Details",
            onTap: () async {
              final hasSubmitted = await ref.read(profileProvider.notifier).onSubmit();
              if (hasSubmitted) {
                await ref.read(onboardingProvider.notifier).setupDefaultData();
              }
            },
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
        shadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
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

  Widget _buildPersonalDetails(BuildContext context) {
    final personalDetailsState = ref.watch(profileProvider);
    final personalDetailsNotifier = ref.read(profileProvider.notifier);
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
          controller: nameController,
          onChanged: (value) => personalDetailsNotifier.setName(value ?? ""),
          header: "FULL NAME",
          hintText: "Shubham Patel",
          perfixIcon: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.user,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        CustomTextField(
          controller: dateOfBirthController,
          inputType: InputType.date,
          header: "DATE OF BIRTH",
          onChanged: (value) => personalDetailsNotifier.setDob(value ?? ""),
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
                    final selected = e[0] == personalDetailsState.gender;
                    return CustomChip(
                      variant:
                          selected ? ChipVariant.primary : ChipVariant.inactive,
                      outlined: true,
                      label: e[0],
                      imageUrl: e[1],
                      selected: selected,
                      onTap: () => personalDetailsNotifier.setGender(e[0]),
                    );
                  }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
