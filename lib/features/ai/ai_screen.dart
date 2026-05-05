import 'package:finpal/app/app.dart';

const String kDummyAiApiKey = 'sk-dummy-finpal-7a2f9c0e1b3d4a56';

class AIScreen extends ConsumerWidget {
  const AIScreen({super.key});

  String get _maskedKey {
    if (kDummyAiApiKey.length < 12) {
      return '••••';
    }
    return '${kDummyAiApiKey.substring(0, 7)}…${kDummyAiApiKey.substring(kDummyAiApiKey.length - 4)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiProvider);
    final aiNotifier = ref.read(aiProvider.notifier);
    final canSend = aiState.inputText.trim().isNotEmpty && !aiState.waiting;

    return Scaffold(
      appBar: customAppBar(context, title: 'FinPal AI'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomContainer(
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
                onChanged: (value) => aiNotifier.setInputText(value),
              ),
            ),
            CustomContainer(
              onTap: canSend ? () => aiNotifier.send() : null,
              backgroundColor:
                  canSend ? CardColors.shade1000 : BGColors.shade600,
              padding: EdgeInsets.all(12.w),
              child: CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.arrowRight,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: _buildMessages(aiState),
    );
  }

  Widget _buildMessages(AiState aiState) {
    if (aiState.messages.isEmpty && !aiState.waiting) {
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

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: aiState.scrollController,
            padding: EdgeInsets.only(
              left: AppConstants.sidePadding,
              right: AppConstants.sidePadding,
              top: 12.w,
              bottom: 84.w,
            ),
            itemCount: aiState.messages.length + (aiState.waiting ? 1 : 0),
            itemBuilder: (context, index) {
              if (aiState.waiting && index == aiState.messages.length) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.w, bottom: 16.w),
                  child: Row(
                    children: [
                      _Bubble(
                        isUser: false,
                        child: Row(
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
                              text: 'Thinking…',
                              fontType: FontType.label1Regular,
                              color: TextColors.shade300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              final message = aiState.messages[index];
              return _MessageRow(message: message);
            },
          ),
        ),
      ],
    );
  }
}

// class _DevKeyBanner extends StatelessWidget {
//   const _DevKeyBanner({required this.maskedKey});

//   final String maskedKey;

//   @override
//   Widget build(BuildContext context) {
//     return CustomContainer(
//       margin: EdgeInsets.fromLTRB(
//         AppConstants.sidePadding,
//         8.w,
//         AppConstants.sidePadding,
//         0,
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
//       backgroundColor: PrimaryColors.shade100,
//       border: Border.all(color: PrimaryColors.shade300),
//       child: Row(
//         children: [
//           CustomImage(
//             imageType: ImageType.svgLocal,
//             imageUrl: AppSvgs.edit,
//             height: 14.w,
//             color: PrimaryColors.shade700,
//           ),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: CustomTypography(
//               text: 'Dev API key: $maskedKey',
//               fontType: FontType.label1Regular,
//               color: TextColors.shade400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.message});

  final AiModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: _Bubble(
              isUser: message.isUser,
              child: CustomTypography(
                text: message.text,
                fontType: FontType.body2Regular,
                color:
                    message.isUser ? CardColors.shade100 : TextColors.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.isUser, required this.child});

  final bool isUser;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backgroundColor: isUser ? TextColors.shade500 : BGColors.shade200,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
        bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
        bottomRight: Radius.circular(isUser ? 4.r : 16.r),
      ),
      child: child,
    );
  }
}
