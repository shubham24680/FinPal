import 'package:finpal/app/app.dart';

class PersonalDetailsForm extends ConsumerStatefulWidget {
  const PersonalDetailsForm({super.key});

  @override
  ConsumerState<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends ConsumerState<PersonalDetailsForm> {
  late TextEditingController nameController;
  late TextEditingController dateOfBirthController;

  @override
  void initState() {
    super.initState();
    final personalDetailsState = ref.read(profileProvider);
    nameController = TextEditingController(text: personalDetailsState.name);
    dateOfBirthController = TextEditingController(text: personalDetailsState.dob);
  }

  @override
  void dispose() {
    nameController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
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
        CustomTextField(
          controller: nameController,
          onChanged: (value) => personalDetailsNotifier.setName(value ?? ""),
          header: "FULL NAME",
          hintText: "Shubham Patel",
          perfixIcon: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.user,
            color: context.colors.primary,
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

// Widget personalDetailsForm(BuildContext context) {
//     final personalDetailsState = ref.watch(profileProvider);
//     final personalDetailsNotifier = ref.read(profileProvider.notifier);
//     final gender = [
//       ["Male", AppSvgs.male],
//       ["Female", AppSvgs.female],
//       ["Other", AppSvgs.user],
//     ];

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 16.spMin,
//       children: [
//         SizedBox(height: 16.spMin),
//         CustomTextField(
//           controller: nameController,
//           onChanged: (value) => personalDetailsNotifier.setName(value ?? ""),
//           header: "FULL NAME",
//           hintText: "Shubham Patel",
//           perfixIcon: CustomImage(
//             imageType: ImageType.svgLocal,
//             imageUrl: AppSvgs.user,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//         CustomTextField(
//           controller: dateOfBirthController,
//           inputType: InputType.date,
//           header: "DATE OF BIRTH",
//           onChanged: (value) => personalDetailsNotifier.setDob(value ?? ""),
//         ),
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomTypography(
//               text: "GENDER",
//               fontType: FontType.body2Medium,
//               color: Theme.of(context).colorScheme.onSurface,
//             ).padding(left: 4.r, bottom: 2.r),
//             Wrap(
//               spacing: 8.spMin,
//               runSpacing: 8.spMin,
//               children:
//                   gender.map((e) {
//                     final selected = e[0] == personalDetailsState.gender;
//                     return CustomChip(
//                       variant:
//                           selected ? ChipVariant.primary : ChipVariant.inactive,
//                       outlined: true,
//                       label: e[0],
//                       imageUrl: e[1],
//                       selected: selected,
//                       onTap: () => personalDetailsNotifier.setGender(e[0]),
//                     );
//                   }).toList(),
//             ),
//           ],
//         ),
//       ],
//     );
//   }