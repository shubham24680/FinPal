import 'dart:developer';

import 'package:finpal/app/app.dart';

class OptionsScreen extends ConsumerWidget {
  const OptionsScreen({super.key, this.extra});

  final ExtraModel? extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionState = ref.watch(optionProvider);

    return Scaffold(
      appBar: customAppBar(context, title: extra?.title),
      body: optionState.when(
        data: (data) {
          final options = data.byType(extra?.type ?? '');

          return GridView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            padding: EdgeInsets.symmetric(
              vertical: 8.w,
              horizontal: AppConstants.sidePadding,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16.w,
              crossAxisSpacing: 8.w,
            ),
            itemBuilder: (context, index) {
              final item = options[index];
              log("Option: ${item.name}, ${item.id}");

              return CustomContainer(
                backgroundColor: BGColors.shade500,
                padding: EdgeInsets.all(12.w),
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
              );
            },
          );
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
