import 'dart:developer';

import 'package:finpal/app/app.dart';

const List<String> _categoryIconChoices = [
  AppSvgs.food,
  AppSvgs.rent,
  AppSvgs.entertainment,
  AppSvgs.bills,
  AppSvgs.salary,
  AppSvgs.wadOfMoney,
  AppSvgs.gift,
  AppSvgs.cash,
  AppSvgs.wallet,
  AppSvgs.upi,
  AppSvgs.card,
  AppSvgs.netBanking,
  AppSvgs.income,
  AppSvgs.expense,
  AppSvgs.money,
  AppSvgs.rupee,
  AppSvgs.calendar,
  AppSvgs.edit,
  AppSvgs.add,
];

class OptionsScreen extends ConsumerWidget {
  const OptionsScreen({super.key, this.extra});
  final ExtraModel? extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = extra?.type ?? '';
    final optionState = ref.watch(optionNotifer);

    return Scaffold(
      appBar: customAppBar(context, title: extra?.title),
      body: optionState.when(
        data: (data) {
          final options = data.byType(type);

          if (options.isEmpty) {
            return Center(
              child: CustomTypography(
                text: "No Options found",
                fontType: FontType.body1Medium,
                color: BGColors.shade700,
              ),
            );
          }

          return GridView.builder(
            itemCount: options.length,
            padding: EdgeInsets.symmetric(
              vertical: 8.w,
              horizontal: AppConstants.sidePadding,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16.w,
              crossAxisSpacing: 8.w,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final item = options[index];
              log("Option: ${item.name}, ${item.id}");

              return CustomContainer(
                backgroundColor: BGColors.shade500,
                padding: EdgeInsets.only(top: 12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8.w,
                        children: [
                          CustomImage(
                            imageType: ImageType.svgLocal,
                            imageUrl: item.icon,
                            height: 24.w,
                          ),
                          CustomTypography(
                            text: item.name,
                            fontType: FontType.body2Regular,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildOptionItem(
                          AppSvgs.edit,
                          isLeft: true,
                          onTap:
                              () => ref
                                  .read(optionProvider(type).notifier)
                                  .loadData(item.id),
                        ),
                        _buildOptionItem(
                          AppSvgs.delete,
                          color: NegativeColors.shade500,
                          onTap:
                              () => ref
                                  .read(optionNotifer.notifier)
                                  .deleteOption(item.id),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ).onTap(event: () => FocusScope.of(context).unfocus());
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      bottomSheet: AddCategoryBar(
        type: type,
      ).onTap(event: () => FocusScope.of(context).unfocus()),
    );
  }

  Widget _buildOptionItem(
    String icon, {
    Color? color,
    bool isLeft = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: CustomContainer(
        onTap: onTap,
        backgroundColor: BGColors.shade500,
        padding: EdgeInsets.all(12.w),
        border: Border(
          top: BorderSide(color: BGColors.shade600, width: 2.w),
          right:
              isLeft
                  ? BorderSide(color: BGColors.shade600, width: 1.w)
                  : BorderSide.none,
          left:
              isLeft
                  ? BorderSide.none
                  : BorderSide(color: BGColors.shade600, width: 1.w),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: isLeft ? Radius.circular(16.r) : Radius.zero,
          bottomRight: isLeft ? Radius.zero : Radius.circular(16.r),
        ),
        child: CustomImage(imageType: ImageType.svgLocal, imageUrl: icon),
      ),
    );
  }
}

class AddCategoryBar extends ConsumerWidget {
  const AddCategoryBar({super.key, required this.type, this.id});
  final String? id;
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionState = ref.watch(optionProvider(type));
    final optionNotifier = ref.read(optionProvider(type).notifier);

    ref.listen(optionProvider(type), (prev, next) {
      if (next.isSaved && !(prev?.isSaved ?? false)) {
        _showSnackBar(context, 'Option saved!');
      } else if (next.hasError && !(prev?.hasError ?? false)) {
        _showSnackBar(
          context,
          'Option already exists!',
          color: NegativeColors.shade500,
        );
      }
    });

    return CustomContainer(
      backgroundColor: BGColors.shade200,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      padding: EdgeInsets.symmetric(vertical: 16.w),
      showShadow: true,
      shadow: [
        BoxShadow(
          color: TextColors.shade500.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: Offset(0, -4),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTypography(
            text: "Add New Option",
            fontType: FontType.body1Medium,
            color: TextColors.shade900,
          ),
          Divider(
            color: BGColors.shade600,
          ).padding(horizontal: AppConstants.sidePadding),
          SizedBox(height: 8.w),
          CustomTextField(
            controller: optionState.nameController,
            hintText: 'Name',
            onChanged: (value) => optionNotifier.setName(value ?? ''),
          ).padding(horizontal: AppConstants.sidePadding),
          SizedBox(height: 16.w),
          SizedBox(
            height: 48.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categoryIconChoices.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.sidePadding,
              ),
              itemBuilder: (context, i) {
                final path = _categoryIconChoices[i];
                final selected = path == optionState.icon;
                return CustomContainer(
                  onTap: () => optionNotifier.setIcon(path),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  backgroundColor:
                      selected ? PrimaryColors.shade200 : BGColors.shade200,
                  border: Border.all(
                    color:
                        selected ? PrimaryColors.shade700 : TextColors.shade200,
                    width: selected ? 2 : 1,
                  ),
                  child: CustomImage(
                    imageType: ImageType.svgLocal,
                    imageUrl: path,
                    height: 24.w,
                    color: TextColors.shade500,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.w),
          CustomButton(
            label: 'Save Option',
            buttonState:
                (optionState.icon.isEmpty || optionState.name.isEmpty)
                    ? ButtonState.disabled
                    : ButtonState.enabled,
            onTap: () => optionNotifier.save(),
            margin: EdgeInsets.symmetric(horizontal: AppConstants.sidePadding),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color ?? CardColors.shade1000,
        content: CustomTypography(
          text: message,
          color: Colors.white,
          fontType: FontType.body2Regular,
        ),
      ),
    );
  }
}
