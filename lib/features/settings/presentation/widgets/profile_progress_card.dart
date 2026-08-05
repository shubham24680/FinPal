import 'package:finpal/app/app.dart';

class ProfileProgressCard extends ConsumerStatefulWidget {
  const ProfileProgressCard({super.key});

  @override
  ConsumerState<ProfileProgressCard> createState() =>
      _ProfileProgressCardState();
}

class _ProfileProgressCardState extends ConsumerState<ProfileProgressCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileNotifier).value ?? ProfileModel();
    final isFirstVisit =
        ref.watch(settingsNotifier).value?.isFirstVisit ?? false;
    final steps = ProfileConstants.buildProgressSteps(profile, isFirstVisit);
    final progress = ProfileProgress(steps: steps);
    final isDark = context.isDarkMode;

    if (progress.isComplete) return const SizedBox.shrink();

    final status = ProfileConstants.statusLabel(progress.percent);
    final footer = ProfileConstants.message(progress.percent, profile.name);

    return CustomContainer(
      showShadow: true,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.sidePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, steps, progress, isDark),
              SizedBox(height: 16.spMin),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTypography(
                    text: "${progress.percent}%",
                    fontType: FontType.h1Bold,
                  ),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
                    backgroundColor: isDark ? status.color.dimDark : status.color.light,
                    child: CustomTypography(
                      text: status.title,
                      fontType: FontType.label2SemiBold,
                      color: status.color.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.spMin),
              _buildSegmentedBar(context, progress, steps[progress.completed - 1]),
              SizedBox(height: 12.spMin),
              CustomTypography(
                text: footer,
                fontType: FontType.label1Medium,
                color: context.colors.onSurfaceVariant,
              ),
            ],
          ).onTap(event: () => setState(() => _isExpanded = !_isExpanded)),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child:
                _isExpanded
                    ? _buildChecklist(context, progress.steps, isDark)
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List<ProfileContentModel> steps,
    ProfileProgress progress,
    bool isDark,
  ) {
    final step = steps[progress.current];
    final color = steps[progress.completed - 1].color;
    return Row(
      spacing: 12.spMin,
      children: [
        CustomContainer(
          padding: EdgeInsets.all(10.r),
          backgroundColor: isDark ? color.dimDark : color.light,
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: step.icon,
            color: color.normal,
            height: 16.spMin,
            width: 16.spMin,
          ),
        ),
        Expanded(
          child: CustomTypography(
            text: step.title,
            fontType: FontType.body2Semibold,
          ),
        ),
        AnimatedRotation(
          turns: _isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 250),
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.arrowDownSmall,
            color: context.colors.onSurfaceVariant,
            height: 20.spMin,
            width: 20.spMin,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedBar(
    BuildContext context,
    ProfileProgress progress,
    ProfileContentModel steps,
  ) {
    return Row(
      spacing: 6.spMin,
      children: List.generate(progress.total, (index) {
        final filled = index < progress.completed;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 8.spMin,
            decoration: BoxDecoration(
              color:
                  filled
                      ? steps.color.normal
                      : context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(1000.r),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildChecklist(
    BuildContext context,
    List<ProfileContentModel> steps,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: context.colors.outline, height: 24.spMin),
        ...steps.map((step) => _buildStepRow(context, step, isDark)),
      ],
    );
  }

  Widget _buildStepRow(
    BuildContext context,
    ProfileContentModel step,
    bool isDark,
  ) {
    final canNavigate = !step.isCompleted && step.value.isNotEmpty;

    return AnimatedTap(
      onTap: canNavigate ? () => context.push(step.value) : null,
      child: Row(
        spacing: 12.spMin,
        children: [
          CustomContainer(
            padding: EdgeInsets.all(10.r),
            backgroundColor:
                step.isCompleted
                    ? (isDark
                        ? ColorSet.primary.dimDark
                        : ColorSet.primary.light)
                    : (isDark
                        ? ColorSet.neutral.dimDark
                        : ColorSet.neutral.light),
            child: CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: step.isCompleted ? AppSvgs.checkCircle : step.icon,
              color:
                  step.isCompleted
                      ? ColorSet.primary.normal
                      : context.colors.onSurfaceVariant,
              height: 16.spMin,
              width: 16.spMin,
            ),
          ),
          Expanded(
            child: CustomTypography(
              text: step.title,
              fontType: FontType.body2Medium,
              color: step.isCompleted ? context.colors.onSurfaceVariant : null,
              decoration: step.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          if (canNavigate)
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.arrowRight1,
              color: context.colors.onSurfaceVariant,
              height: 16.spMin,
              width: 16.spMin,
            ),
        ],
      ).padding(vertical: 6.spMin),
    );
  }
}
