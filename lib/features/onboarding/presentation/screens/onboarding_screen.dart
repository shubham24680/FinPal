import 'package:finpal/app/app.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView.builder(
        controller: onboardingState.pageController,
        itemCount: OnboardingContent.values.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => OnboardingContent.values[index].screen,
        // itemBuilder: (_, index) {
        //   return _onboardingBuilder(
        //     context,
        //     ref,
        //     OnboardingContent.values[index],
        //   );
        // },
      ),
    );
  }

  // Widget _onboardingBuilder(
  //   BuildContext context,
  //   WidgetRef ref,
  //   OnboardingContent content,
  // ) {
  //   return ResponsiveBuilder(
  //     builder: (context, screenType) {
  //       final isMobile = screenType.isMobile;
  //       final items = [
  //         GestureDetector(
  //           onTap: () => FocusScope.of(context).unfocus(),
  //           child: CustomImage(
  //             imageUrl: content.data.image,
  //             fit: BoxFit.fitWidth,
  //           ),
  //         ),
  //         _buildOnboardingItem(ref, context, content, isMobile: isMobile),
  //       ];

  //       return isMobile
  //           ? Stack(children: items)
  //           : Row(children: items.map((e) => Expanded(child: e)).toList());
  //     },
  //   );
  // }

  // Widget _buildOnboardingItem(
  //   WidgetRef ref,
  //   BuildContext context,
  //   OnboardingContent type, {
  //   bool isMobile = true,
  // }) {
  //   final height = MediaQuery.of(context).size.height;
  //   final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
  //   final onboardingState = ref.watch(onboardingProvider);
  //   final onboardingNotifier = ref.read(onboardingProvider.notifier);
  //   final onboarding = type.data;
  //   final isOnboarding = type == OnboardingContent.onboarding;
  //   final button = onboarding.button;

  //   final child = SafeArea(
  //     top: !isMobile,
  //     left: isMobile,
  //     child: Column(
  //       mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
  //       children: [
  //         SizedBox(height: 20.spMin),
  //         _buildOnboardingContent(context, ref, type),
  //         (!isMobile && isOnboarding)
  //             ? const Spacer()
  //             : SizedBox(height: 32.spMin),
  //         buildPageIndicator(context, onboardingState),
  //         SizedBox(height: 24.spMin),
  //         CustomButton(
  //           buttonState: onboardingState.buttonState,
  //           label: button.label,
  //           prefixIcon: button.prefixIcon,
  //           suffixIcon: button.suffixIcon,
  //           onTap: () => onboardingNotifier.next(type),
  //         ),
  //         SizedBox(height: 40.spMin),
  //       ],
  //     ),
  //   );

  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: CustomContainer(
  //       height: isMobile ? null : height,
  //       backgroundColor: Theme.of(context).colorScheme.surface,
  //       padding: EdgeInsets.symmetric(horizontal: 16.r),
  //       borderRadius:
  //           isMobile
  //               ? BorderRadius.vertical(top: Radius.circular(24.r))
  //               : BorderRadius.zero,
  //       child:
  //           type == OnboardingContent.onboarding
  //               ? child
  //               : SingleChildScrollView(
  //                 padding: EdgeInsets.only(bottom: bottomPadding),
  //                 child: child,
  //               ),
  //     ),
  //   );
  // }

  // Widget _buildOnboardingContent(
  //   BuildContext context,
  //   WidgetRef ref,
  //   OnboardingContent type,
  // ) {
  //   final onboarding = type.data;
  //   final subtitle = onboarding.subtitle?.text;
  //   final child = switch (type) {
  //     OnboardingContent.personalDetails => _buildPersonalDetails(context, ref),
  //     OnboardingContent.security => _buildSecurity(context, ref),
  //     _ => SizedBox.shrink(),
  //   };

  //   return Column(
  //     children: [
  //       onboardingTypo(context, onboarding.title),
  //       CustomTypography(
  //         text: subtitle,
  //         fontType: FontType.label1Regular,
  //         align: TextAlign.center,
  //         color: Theme.of(context).colorScheme.onSurface,
  //       ),
  //       child,
  //     ],
  //   );
  // }

  // Widget _buildPersonalDetails(BuildContext context, WidgetRef ref) {
  //   final onboardingState = ref.watch(onboardingProvider);
  //   final onboardingNotifier = ref.read(onboardingProvider.notifier);
  //   final gender = [
  //     ["Male", AppSvgs.male],
  //     ["Female", AppSvgs.female],
  //     ["Other", AppSvgs.user],
  //   ];

  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     spacing: 16.spMin,
  //     children: [
  //       SizedBox(height: 16.spMin),
  //       CustomTextField(
  //         controller: onboardingState.nameController,
  //         onChanged: (value) => onboardingNotifier.setName(value ?? ""),
  //         header: "FULL NAME",
  //         hintText: "Shubham Patel",
  //         perfixIcon: CustomImage(
  //           imageType: ImageType.svgLocal,
  //           imageUrl: AppSvgs.user,
  //           color: Theme.of(context).colorScheme.primary,
  //         ),
  //       ),
  //       CustomTextField(
  //         controller: onboardingState.dateOfBirthController,
  //         inputType: InputType.date,
  //         header: "DATE OF BIRTH",
  //         onChanged: (value) => onboardingNotifier.setDob(value ?? ""),
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           CustomTypography(
  //             text: "GENDER",
  //             fontType: FontType.body2Medium,
  //             color: Theme.of(context).colorScheme.onSurface,
  //           ).padding(left: 4.r, bottom: 2.r),
  //           Wrap(
  //             spacing: 8.spMin,
  //             runSpacing: 8.spMin,
  //             children:
  //                 gender.map((e) {
  //                   final selected = e[0] == onboardingState.gender;
  //                   return CustomChip(
  //                     variant:
  //                         selected ? ChipVariant.primary : ChipVariant.inactive,
  //                     outlined: true,
  //                     label: e[0],
  //                     imageUrl: e[1],
  //                     selected: selected,
  //                     onTap: () => onboardingNotifier.setGender(e[0]),
  //                   );
  //                 }).toList(),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildSecurity(BuildContext context, WidgetRef ref) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [SizedBox(height: 16.spMin)],
  //   );
  // }
}
