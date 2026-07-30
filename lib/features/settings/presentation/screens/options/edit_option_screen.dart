import 'package:finpal/app/app.dart';

class EditOptionScreen extends ConsumerStatefulWidget {
  const EditOptionScreen({super.key});

  @override
  ConsumerState<EditOptionScreen> createState() => _EditOptionScreenState();
}

class _EditOptionScreenState extends ConsumerState<EditOptionScreen> {
  late TextEditingController nameController;
  late TextEditingController typeController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final optionState = ref.read(optionProvider);
    nameController = TextEditingController(text: optionState.name);
    typeController = TextEditingController(text: optionState.type?.name ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        AppConstants.bottomPadding + context.viewInsets.bottom;
    final optionState = ref.watch(optionProvider);
    final optionNotifier = ref.read(optionProvider.notifier);
    final isAdded = optionState.id.isNotEmpty;

    ref.listen(optionProvider, (previous, next) {
      if (next.toastType != ToastType.normal) {
        optionNotifier.resetToast();
        context.showSnackBar(next.message, toastType: next.toastType);
        if (next.toastType == ToastType.success) {
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: customAppBar(
        context,
        title: isAdded ? "Edit Category" : "Add Category",
      ),
      bottomNavigationBar: CustomButton(
        onTap: () => optionNotifier.save(),
        buttonState: optionState.buttonState,
        label: isAdded ? "Update" : "Add",
      ).padding(
        left: AppConstants.sidePadding,
        right: AppConstants.sidePadding,
        bottom: bottomPadding,
      ),
      body: _buildBody(context, optionState, optionNotifier),
    ).onTap(event: () => context.focusNode.unfocus());
  }

  Widget _buildBody(
    BuildContext context,
    OptionState optionState,
    OptionProvider optionNotifier,
  ) {
    final allOptions = ref.watch(optionNotifer).value?.categories ?? [];
    final unselectedOptions =
        OptionsConstant.allOptions
            .where(
              (e) =>
                  !allOptions.any(
                    (o) => o.name.toLowerCase() == e.name.toLowerCase(),
                  ),
            )
            .toList();
    final typeIcon = optionState.type?.icon ?? "";

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.sidePadding),
      child: Column(
        spacing: 24.spMin,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: buildAvatar(
              context,
              size: 100.spMin,
              icon: optionState.icon,
              color: optionState.color,
              onTap: () async {
                final selected =
                    await CustomBottomSheet.show<Map<String, dynamic>>(
                      context,
                      widget: _ImageBS(
                        icon: optionState.icon,
                        color: optionState.color,
                      ),
                    );
                if (context.mounted) {
                  optionNotifier.set(
                    icon: selected?["icon"],
                    color: selected?["color"],
                  );
                }
              },
            ),
          ),
          CustomContainer(
            child: Column(
              spacing: 16.spMin,
              children: [
                CustomTextField(
                  controller: nameController,
                  onChanged: (value) => optionNotifier.set(name: value),
                  header: "NAME",
                  hintText: "Shopping",
                  maxLength: 20,
                  perfixIcon: CustomImage(
                    imageType: ImageType.svgLocal,
                    imageUrl: optionState.icon,
                    color: context.colors.primary,
                  ),
                ),
                CustomTextField(
                  controller: typeController,
                  readOnly: true,
                  onTap: () async {
                    final selectedType =
                        await CustomBottomSheet.show<OptionType>(
                          context,
                          widget: _buildCategoriesBSWidget(),
                        );
                    optionNotifier.set(type: selectedType);
                    typeController.text =
                        selectedType?.name ?? optionState.type?.name ?? "";
                  },
                  header: "CATEGORY TYPE",
                  hintText: "Select Category Type",
                  perfixIcon:
                      typeIcon.isNotEmpty
                          ? CustomImage(
                            imageType: ImageType.svgLocal,
                            imageUrl: typeIcon,
                            color: context.colors.primary,
                          )
                          : null,
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8.spMin,
            runSpacing: 8.spMin,
            children:
                unselectedOptions.map((e) {
                  return CustomChip(
                    variant: ChipVariant.inactive,
                    outlined: true,
                    label: e.name,
                    imageUrl: e.icon,
                    // selected: selected,
                    onTap: () {
                      ref
                          .read(optionProvider.notifier)
                          .set(
                            icon: e.icon,
                            color: e.color.colorSet,
                            name: e.name,
                            type: e.type.byId,
                          );
                      _init();
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesBSWidget() {
    final values = OptionType.values;
    return ListView.separated(
      shrinkWrap: true,
      itemCount: values.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return CustomContainer(
          onTap: () => context.pop(values[index]),
          padding: EdgeInsets.symmetric(vertical: 16.r),
          child: Row(
            spacing: 12.spMin,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: values[index].icon,
                color: AppColors.info500,
              ),
              CustomTypography(
                text: values[index].name,
                fontType: FontType.body2Medium,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }
}

class _ImageBS extends StatefulWidget {
  const _ImageBS({this.icon = AppSvgs.add1, this.color = ColorSet.primary});

  final String icon;
  final ColorSet color;

  @override
  State<_ImageBS> createState() => _ImageBSSState();
}

class _ImageBSSState extends State<_ImageBS> {
  late String selectedIcon;
  late ColorSet selectedColor;

  @override
  void initState() {
    super.initState();
    selectedIcon = widget.icon;
    selectedColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAvatar(
          context,
          size: 100.spMin,
          icon: selectedIcon,
          color: selectedColor,
        ),
        SizedBox(height: 24.spMin),
        _buildColorPicker(),
        SizedBox(height: 16.spMin),
        _buildIconPicker(context),
        SizedBox(height: 48.spMin),
        CustomButton(
          onTap:
              () => context.pop({"icon": selectedIcon, "color": selectedColor}),
          buttonState: ButtonState.enabled,
          label: "Save",
        ),
        SizedBox(height: 24.spMin),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Row(
      spacing: 16.spMin,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(ColorSet.values.length, (index) {
        final colorSet = ColorSet.values[index];
        final isSelected = colorSet == selectedColor;

        return CustomContainer(
          onTap:
              () => setState(() {
                selectedColor = colorSet;
              }),
          backgroundColor: colorSet.normal,
          height: 52.spMin,
          width: 52.spMin,
          padding: EdgeInsets.all(8.r),
          child:
              isSelected
                  ? CustomImage(
                    imageType: ImageType.svgLocal,
                    imageUrl: AppSvgs.checkSquare,
                    color: context.colors.surface,
                  )
                  : null,
        );
      }),
    );
  }

  Widget _buildIconPicker(BuildContext context) {
    final isLandscape = context.isLandscape;
    final crossAxisCount = isLandscape ? 10 : 7;

    return GridView.builder(
      itemCount: AppSvgs.icons.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final isSelected = AppSvgs.icons[index] == selectedIcon;

        return CustomContainer(
          onTap:
              () => setState(() {
                selectedIcon = AppSvgs.icons[index];
              }),
          padding: EdgeInsets.all(12.r),
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.icons[index],
            color:
                isSelected
                    ? context.colors.inverseSurface
                    : context.colors.onSurface,
          ),
        );
      },
    );
  }
}
