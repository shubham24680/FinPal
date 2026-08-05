import 'package:finpal/app/app.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController monthlyIncomeController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final profileState = ref.read(profileProvider);
    final monthlyIncome = profileState.monthlyIncome;
    monthlyIncomeController = TextEditingController(
      text:
          monthlyIncome == null
              ? null
              : CurrencyFormatter.formatAmountForInput(monthlyIncome),
    );
  }

  @override
  void dispose() {
    monthlyIncomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    return Scaffold(
      extendBody: true,
      appBar: customAppBar(context, title: "Edit Profile"),
      bottomNavigationBar: SafeArea(
        child: CustomButton(
          buttonState: profileState.buttonState,
          label: "Save Changes",
          onTap: () async {
            final hasSubmitted = await profileNotifier.onSubmit();
            if (hasSubmitted && context.mounted) {
              context.pop();
            }
          },
        ).padding(
          horizontal: AppConstants.sidePadding,
          top: 8.spMin,
          bottom: context.buttonBottomPadding,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppConstants.sidePadding,
          right: AppConstants.sidePadding,
          top: AppConstants.sidePadding,
          bottom: 180.spMin + context.viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePicture(context, profileState, profileNotifier),
            SizedBox(height: 32.spMin),
            CustomTypography(
              text: "Personal Information",
              fontType: FontType.body2Medium,
              color: context.colors.onSurface,
            ).padding(left: 8.r, bottom: 4.r),
            CustomContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.spMin,
                children: [
                  PersonalDetailsForm(),
                  CustomTextField(
                    controller: monthlyIncomeController,
                    onChanged:
                        (value) => profileNotifier.setMonthlyIncome(value),
                    inputType: InputType.amount,
                    header: "MONTHLY INCOME",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).onTap(event: () => FocusScope.of(context).unfocus());
  }

  Widget _buildProfilePicture(
    BuildContext context,
    ProfileState profileState,
    ProfileProvider profileNotifier,
  ) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          buildAvatar(
            context,
            size: 100.spMin,
            image: profileState.profileImage,
            enableBorder: true,
          ),
          CustomContainer(
            onTap: () async {
              final image = await selectImageBottomSheet(context);
              if (image == null) return;
              profileNotifier.setProfileImage(image);
            },
            backgroundColor: AppColors.primary500,
            padding: EdgeInsets.all(8.r),
            child: CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.camera,
              color: context.colors.surface,
              height: 16.spMin,
              width: 16.spMin,
            ),
          ),
        ],
      ),
    );
  }
}
