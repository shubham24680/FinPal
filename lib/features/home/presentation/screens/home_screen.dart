import 'package:finpal/app/app.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<HomeScreen> {
  static const _topWidgetHeight = 266.0;

  final ValueNotifier<bool> _isSheetExpanded = ValueNotifier(false);

  @override
  void dispose() {
    _isSheetExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifier).value;
    final transactions = ref.watch(transactionProvider);

    final availableBalance = transactions.value?.availableBalance ?? 0;
    final hideBalance = settings?.hideBalanceOnHome ?? false;

    return Stack(
      children: [
        _buildTopWidget(context, availableBalance, hideBalance),
        _buildMainWidget(context, transactions, hideBalance),
        _buildAppBar(context, availableBalance, hideBalance),
      ],
    );
  }

  Widget _buildTopWidget(
    BuildContext context,
    double availableBalance,
    bool hideBalance,
  ) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;
    final profile = ref.watch(profileNotifier).value;
    final firstName = profile?.name.split(' ').first;
    final name =
        (firstName != null && firstName.isNotEmpty) ? firstName : "\u{1F44B}";
    final title = [
      TypographyModel(text: "Hello ", fontType: FontType.h1Medium),
      TypographyModel(text: name, color: AppColors.primary500),
    ];

    return CustomContainer(
      height: _topWidgetHeight.spMin,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding,
        left: AppConstants.sidePadding,
        right: AppConstants.sidePadding,
        bottom: 32.spMin,
      ),
      borderRadius: BorderRadius.zero,
      image: context.isDarkMode ? AppImages.bannerDark : AppImages.banner,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8.spMin,
            children: [
              Expanded(
                child: CustomTypography(
                  typos: title,
                  maxLines: 1,
                  align: TextAlign.start,
                ),
              ),
              _buildProfileActionButtons(context),
            ],
          ),
          SizedBox(height: 8.spMin),
          CustomTypography(
            text: "Let's make today\nfinancially rewarding.",
            fontType: FontType.body2Medium,
            color: context.colors.onSurface,
          ),
          Spacer(),
          _buildTotalBalance(context, availableBalance, hideBalance),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    double availableBalance,
    bool hideBalance,
  ) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;
    return ValueListenableBuilder<bool>(
      valueListenable: _isSheetExpanded,
      builder: (context, isExpanded, _) {
        return IgnorePointer(
          ignoring: !isExpanded,
          child: AnimatedOpacity(
            opacity: isExpanded ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: CustomContainer(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.r),
              ),
              showShadow: true,
              padding: EdgeInsets.only(
                top: topPadding,
                left: AppConstants.sidePadding,
                right: AppConstants.sidePadding,
                bottom: 8.spMin,
              ),
              child: Row(
                spacing: 8.spMin,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildTotalBalance(
                      context,
                      availableBalance,
                      hideBalance,
                      smallFont: true,
                    ),
                  ),
                  _buildProfileActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalBalance(
    BuildContext context,
    double availableBalance,
    bool hideBalance, {
    bool smallFont = false,
  }) {
    final toggleBalance = ref.watch(hideBalanceProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.spMin,
          crossAxisAlignment:
              hideBalance ? CrossAxisAlignment.center : CrossAxisAlignment.end,
          children: [
            CustomTypography(
              text: "Available Balance",
              fontType:
                  smallFont ? FontType.label2Medium : FontType.body2Medium,
            ),
            if (hideBalance)
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: toggleBalance ? AppSvgs.eyeOpen : AppSvgs.eyeClosed,
                width: smallFont ? 12.spMin : 16.spMin,
                height: smallFont ? 12.spMin : 16.spMin,
              ),
          ],
        ),
        SizedBox(height: smallFont ? 2.spMin : 4.spMin),
        (!hideBalance || toggleBalance)
            ? CustomTypography(
              text: ref.formatCurrency(availableBalance),
              fontType: smallFont ? FontType.h4Bold : FontType.h1Bold,
            )
            : Row(
              spacing: smallFont ? 4.spMin : 8.spMin,
              children: List.generate(
                4,
                (index) => CustomContainer(
                  padding: EdgeInsets.all(smallFont ? 4.spMin : 8.spMin),
                  borderRadius: BorderRadius.circular(1000.r),
                  backgroundColor: context.colors.inverseSurface,
                ),
              ),
            ),
      ],
    ).onTap(
      event: () => ref.read(hideBalanceProvider.notifier).state = !toggleBalance,
    );
  }

  Widget _buildProfileActionButtons(BuildContext context) {
    final profile = ref.watch(profileNotifier).value;
    // final toggleBalance = ref.watch(hideBalanceProvider);

    return Row(
      spacing: 8.spMin,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // CustomContainer(
        //   showShadow: true,
        //   borderRadius: BorderRadius.circular(1000.r),
        //   border: Border.all(color: context.colors.outline),
        //   padding: EdgeInsets.all(10.spMin),
        //   onTap: () => ref.read(hideBalanceProvider.notifier).state = !toggleBalance,
        //   child: CustomImage(
        //     imageType: ImageType.svgLocal,
        //     imageUrl: toggleBalance ? AppSvgs.eyeOpen : AppSvgs.eyeClosed,
        //     width: 20.spMin,
        //     height: 20.spMin,
        //   ),
        // ),
        buildAvatar(
          context,
          showShadow: true,
          image: profile?.profileImage ?? "",
          size: 40.spMin,
          enableBorder: true,
          onTap: () => context.push(AppRoutesPath.profile.path),
        ),
      ],
    );
  }

  Widget _buildMainWidget(
    BuildContext context,
    AsyncValue<TransactionService> transactions,
    bool hideBalance,
  ) {
    final isLandscape = context.isLandscape;
    final screenHeight = context.screenHeight;
    final fullSheetThreshold = isLandscape ? 0.75 : 0.85;
    final collapsedSize = ((screenHeight - _topWidgetHeight.spMin + 24.spMin) /
            screenHeight)
        .clamp(0.35, fullSheetThreshold);
    final toggleBalance = ref.watch(hideBalanceProvider);

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        final isExpanded = notification.extent >= fullSheetThreshold;
        if (_isSheetExpanded.value != isExpanded) {
          _isSheetExpanded.value = isExpanded;
        }
        return false;
      },
      child: DraggableScrollableSheet(
        initialChildSize: collapsedSize,
        minChildSize: collapsedSize,
        maxChildSize: isLandscape ? 0.8 : 0.9,
        snap: true,
        snapSizes: [collapsedSize],
        builder: (context, scrollController) {
          return ValueListenableBuilder<bool>(
            valueListenable: _isSheetExpanded,
            builder: (context, isExpanded, child) {
              return CustomContainer(
                padding: EdgeInsets.zero,
                backgroundColor: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isExpanded ? 0 : 24.r),
                ),
                child: child,
              );
            },
            child: ListView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 8.spMin, bottom: 180.spMin),
              children: [
                Center(
                  child: CustomContainer(
                    width: 48.spMin,
                    height: 4.spMin,
                    borderRadius: BorderRadius.circular(1000.r),
                    backgroundColor: context.colors.onSurface.withAlpha(40),
                  ),
                ),
                SizedBox(height: 16.spMin),
                transactions.when(
                  data: (data) {
                    final analysis = AnalysisCalculator.getAnalysis(
                      data.totalIncome,
                      data.totalExpense,
                      data.availableBalance,
                    );
                    final recentTransactions = data.getRecentTransactions();
                    final children = [
                      AnimatedTap(
                        onTap: () => ref.read(navProvider.notifier).state = 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: CustomImage(imageUrl: AppImages.reportPoster),
                        ),
                      ).padding(horizontal: 16.spMin),
                      TransactionList(
                        payments: recentTransactions,
                        label: "Recent Transactions",
                        labelColor: context.colors.onSurface,
                        moreButtonLabel: "View All",
                        showDate: true,
                        onMoreButtonPressed:
                            () => ref.read(navProvider.notifier).state = 1,
                      ),
                    ];
                    final widget =
                        isLandscape
                            ? Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  children
                                      .map((e) => Expanded(child: e))
                                      .toList(),
                            )
                            : Column(
                              spacing: 16.spMin,
                              mainAxisSize: MainAxisSize.min,
                              children: children,
                            );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnalysisCard(
                          analysis,
                          hideBalance: !hideBalance || toggleBalance,
                          title: "Analytics",
                          onTap: () => ref.read(navProvider.notifier).state = 2,
                        ),
                        CategoriesCard(),
                        SizedBox(height: 16.spMin),
                        widget,
                      ],
                    );
                  },
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
                SizedBox(height: 16.spMin),
                const ProfileProgressCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}
