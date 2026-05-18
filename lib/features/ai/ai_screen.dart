import 'package:finpal/app/app.dart';

class AIScreen extends ConsumerWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiProvider);
    final aiNotifier = ref.read(aiProvider.notifier);

    return Scaffold(
      appBar: customAppBar(context, title: 'FinPal AI'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildTextArea(aiState, aiNotifier),
      body: _buildChat(aiState),
    );
  }

  Widget _buildTextArea(AiState aiState, AiNotifier aiNotifier) {
    final canSend =
        aiState.inputText.trim().isNotEmpty && aiState.mode != AiMode.waiting;
    return CustomContainer(
      showShadow: true,
      shadow: [
        BoxShadow(
          color: Colors.black.withAlpha(100),
          blurRadius: 20.r,
          offset: Offset(0, 10.r),
        ),
      ],
      backgroundColor: BGColors.shade500,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.all(8.w),
      border: Border.all(color: BGColors.shade600),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 8.w,
        children: [
          Expanded(
            child: CustomTextField(
              controller: aiState.inputController,
              hintText: 'Ask something…',
              inputBorderType: InputBorderType.outline,
              onChanged: (value) => aiNotifier.setInputText(value ?? ''),
            ),
          ),
          CustomContainer(
            onTap: canSend ? () => aiNotifier.send() : null,
            backgroundColor: canSend ? CardColors.shade1000 : BGColors.shade600,
            padding: EdgeInsets.all(12.w),
            child: CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.arrowRight,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChat(AiState aiState) {
    if (aiState.messages.isEmpty && aiState.mode == AiMode.normal) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.bot,
              color: BGColors.shade700,
            ),
            SizedBox(height: 16.w),
            CustomTypography(
              align: TextAlign.center,
              text:
                  'Hi — I’m your FinPal assistant. Ask about spending, categories, savings tips, etc.',
              fontType: FontType.label1SemiBold,
              color: BGColors.shade700,
            ),
          ],
        ).padding(horizontal: 32.w, bottom: 64.w),
      );
    }

    final isWaiting = aiState.mode == AiMode.waiting;
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.only(
        left: AppConstants.sidePadding,
        right: AppConstants.sidePadding,
        top: 12.w,
        bottom: 90.w,
      ),
      itemCount: aiState.messages.length + (isWaiting ? 1 : 0),
      itemBuilder: (context, index) {
        if (isWaiting && index == 0) return _buildLoading();
        final message = aiState.messages[isWaiting ? index - 1 : index];
        return Message(key: ValueKey(message.id), message: message);
      },
    );
  }

  Widget _buildLoading({String text = 'Thinking…'}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16.w,
          height: 16.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: PrimaryColors.shade500,
          ),
        ),
        SizedBox(width: 8.w),
        CustomTypography(
          text: text,
          fontType: FontType.body2Regular,
          color: TextColors.shade300,
        ),
      ],
    );
  }
}
