import 'package:finpal/app/app.dart';

class OptionsBottomSheet extends ConsumerStatefulWidget {
  const OptionsBottomSheet({
    super.key,
    this.type,
    this.categories = const [],
    this.title,
    this.selectedOption,
  });

  final String? type;
  final List<OptionModel> categories;
  final OptionModel? selectedOption;
  final String? title;

  @override
  ConsumerState<OptionsBottomSheet> createState() => _OptionsBottomSheetState();
}

class _OptionsBottomSheetState extends ConsumerState<OptionsBottomSheet> {
  late final TextEditingController controller;
  late List<OptionModel> _options;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _options = List<OptionModel>.of(widget.categories);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String? get _typeId =>
      widget.type ?? (_options.isNotEmpty ? _options.first.type : null);
  void _refreshOptions() {
    final typeId = _typeId;
    if (typeId == null) return;
    setState(() {
      _options =
          ref.read(optionNotifer).value?.byType(typeId) ?? widget.categories;
    });
  }

  Future<void> _openAddOption() async {
    ref.read(selectedOptionProvider.notifier).state = null;
    await context.push(AppRoutesPath.editOption.path);
    if (!mounted) return;
    _refreshOptions();
  }

  List<OptionModel> get filteredOptions {
    final searchedText = controller.text.trim();
    if (searchedText.isEmpty) {
      return _options;
    }

    return _options
        .where(
          (option) =>
              option.name.toLowerCase().contains(searchedText.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isPaymentMethod = _typeId == OptionType.paymentMethod.id;
    final method = isPaymentMethod ? "payment method" : "category";
    final values = filteredOptions;
    final items = [
      ...values,
      OptionsConstant.otherCategory,
      OptionModel(
        type: "add_category",
        name: "Add Category",
        icon: AppSvgs.add1,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.spMin),
        CustomTextField(
          controller: controller,
          hintText: "Search",
          onChanged: (_) => setState(() {}),
          perfixIcon: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.search,
            color: context.colors.outline,
            height: 24.spMin,
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            padding: EdgeInsets.only(bottom: 60.spMin),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return (items[index].type == "add_category")
                  ? CustomButton(
                    buttonSize: ButtonSize.small,
                    buttonVariant: ButtonVariant.tertiary,
                    label: "Add a $method",
                    prefixIcon: AppSvgs.add1,
                    onTap: _openAddOption,
                  ).padding(top: 8.spMin)
                  : optionTile(context, items[index]);
            },
            separatorBuilder: (_, _) => const Divider(),
          ),
        ),
      ],
    ).onTap(event: () => context.focusNode.unfocus());
  }

  Widget optionTile(BuildContext context, OptionModel option) {
    final color = option.color.colorSet;
    final isSelected = option.id == widget.selectedOption?.id;

    return CustomContainer(
      onTap: () => context.pop(option),
      padding: EdgeInsets.symmetric(vertical: 16.r),
      child: Row(
        spacing: 12.spMin,
        children: [
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: option.icon,
            color: color.normal,
          ),
          Expanded(
            child: CustomTypography(
              text: option.name,
              fontType: FontType.body2Medium,
            ),
          ),
          if (isSelected)
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.checkSquare,
              color: color.normal,
            ),
        ],
      ),
    );
  }
}
