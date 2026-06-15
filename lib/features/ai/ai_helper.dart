import 'package:finpal/app/app.dart';
import 'package:flutter/services.dart';

enum ChatMenu {
  copy("Copy", AppSvgs.copy),
  edit("Edit Message", AppSvgs.edit);

  const ChatMenu(this.name, this.icon);
  final String name;
  final String icon;
}

class Message extends ConsumerWidget {
  const Message({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.role == ChatRole.user;
    final hasError = message.status == ChatMessageStatus.error;

    Widget child;
    if (isUser) {
      final content = _buildUserContent(message, context, ref);
      child = wrapContainer(content, isRight: true);
    } else if (hasError) {
      final content = _buildContent(
        message.text,
        textColor: NegativeColors.shade900,
        iconUrl: AppSvgs.info,
        context: context,
      );
      child = wrapContainer(
        content,
        borderColor: NegativeColors.shade300,
        backgroundColor: NegativeColors.shade100,
      );
    } else {
      final options = Row(
        spacing: 16.w,
        children: [
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.copy,
            height: 16.w,
          ).onTap(event: () => _addTextToClipboard(context, message.text)),
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.retry,
            height: 16.w,
          ).onTap(
            event: () {
              ref.read(aiProvider.notifier).retryMessage(message);
            },
          ),
        ],
      );
      child = Column(
        spacing: 8.w,
        children: [
          _buildContent(
            message.text,
            isMarkdown: true,
            textColor: TextColors.shade700,
            context: context,
          ),
          options,
        ],
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: child.padding(bottom: 16.w),
    );
  }

  Widget _buildUserContent(
    ChatMessage message,
    BuildContext context,
    WidgetRef ref,
  ) {
    return GestureDetector(
      onLongPressStart: (details) async {
        final res = await showChatMenu(
          context,
          details.globalPosition,
          message,
        );

        if (!context.mounted) return;

        switch (res) {
          case ChatMenu.copy:
            _addTextToClipboard(context, message.text);
            break;
          case ChatMenu.edit:
            _editUserMessage(context, ref, message);
            break;
          default:
            break;
        }
      },
      child: _buildContent(message.text, context: context),
    );
  }

  Future<ChatMenu?> showChatMenu(
    BuildContext context,
    Offset tapPosition,
    ChatMessage message,
  ) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    return showMenu<ChatMenu>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      color: Colors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      menuPadding: EdgeInsets.all(8.w),
      items: [
        PopupMenuItem(
          enabled: false,
          child: CustomTypography(
            text: message.createdAt.formatDate(
              type: DateFormatType.shortDateWithTime,
            ),
            align: TextAlign.center,
            fontType: FontType.body2Regular,
            color: BGColors.shade700,
          ),
        ),
        ...ChatMenu.values.map((e) => _menuItem(e.name, e, iconUrl: e.icon)),
      ],
    );
  }

  PopupMenuItem<ChatMenu> _menuItem(
    String text,
    ChatMenu value, {
    String? iconUrl,
    Color textColor = TextColors.shade700,
  }) {
    return PopupMenuItem<ChatMenu>(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.w,
        children: [
          if (iconUrl != null)
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: iconUrl,
              color: textColor,
              height: 18.w,
            ),
          Flexible(
            child: CustomTypography(
              text: text,
              fontType: FontType.body2Semibold,
              color: textColor,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  void _addTextToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    showToast(context, "Copied to clipboard");
  }

  void _editUserMessage(
    BuildContext context,
    WidgetRef ref,
    ChatMessage message,
  ) {
    ref.read(aiProvider.notifier).update(message);
  }

  Widget wrapContainer(
    Widget content, {
    Color backgroundColor = TextColors.shade500,
    Color borderColor = TextColors.shade500,
    bool isRight = false,
  }) {
    return CustomContainer(
      backgroundColor: backgroundColor,
      border: Border.all(color: borderColor),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
        bottomLeft: isRight ? Radius.circular(16.r) : Radius.circular(4.r),
        bottomRight: isRight ? Radius.circular(4.r) : Radius.circular(16.r),
      ),
      child: content,
    );
  }

  Widget _buildContent(
    String text, {
    bool isMarkdown = false,
    Color textColor = Colors.white,
    String? iconUrl,
    required BuildContext context,
  }) {
    final textWidget =
        isMarkdown
            ? MarkdownBody(
              data: text,
              selectable: true,
              softLineBreak: true,
              styleSheet: _markdownStyleSheetFor(textColor, context),
            )
            : CustomTypography(
              text: text,
              fontType: FontType.body2Regular,
              color: textColor,
              height: 1.45,
            );

    return (iconUrl != null)
        ? Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.w,
          children: [
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: iconUrl,
              color: textColor,
              height: 18.w,
            ),
            Flexible(child: textWidget),
          ],
        )
        : textWidget;
  }

  TextStyle _baseStyle(
    FontType fontType, {
    FontStyle? fontStyle,
    TextDecoration? decoration,
    Color? textColor,
    required BuildContext context,
  }) {
    return CustomTypography(
      fontType: fontType,
      fontStyle: fontStyle,
      decoration: decoration,
      color: textColor,
      height: 2,
      letterSpacing: 0.5,
    ).getTextStyle(context);
  }

  // Cache per textColor so every Message rebuild doesn't reallocate ~25
  // TextStyle objects and BoxDecorations. The screen only uses a couple of
  // distinct colors, so this stays tiny.
  static final Map<Color, MarkdownStyleSheet> _markdownStyleCache = {};

  MarkdownStyleSheet _markdownStyleSheetFor(
    Color textColor,
    BuildContext context,
  ) {
    return _markdownStyleCache.putIfAbsent(
      textColor,
      () => MarkdownStyleSheet(
        p: _baseStyle(
          FontType.body2Regular,
          textColor: textColor,
          context: context,
        ),
        pPadding: EdgeInsets.zero,
        h1: _baseStyle(
          FontType.h1Semibold,
          textColor: textColor,
          context: context,
        ),
        h1Padding: EdgeInsets.only(top: 8.w, bottom: 4.w),
        h2: _baseStyle(
          FontType.h2Semibold,
          textColor: textColor,
          context: context,
        ),
        h2Padding: EdgeInsets.only(top: 8.w, bottom: 4.w),
        h3: _baseStyle(
          FontType.body1Semibold,
          textColor: textColor,
          context: context,
        ),
        h3Padding: EdgeInsets.only(top: 6.w, bottom: 2.w),
        h4: _baseStyle(
          FontType.body1Semibold,
          textColor: textColor,
          context: context,
        ),
        h5: _baseStyle(
          FontType.body1Medium,
          textColor: textColor,
          context: context,
        ),
        h6: _baseStyle(
          FontType.body1Medium,
          context: context,
          textColor: textColor,
        ),
        strong: _baseStyle(
          FontType.body2Semibold,
          context: context,
          textColor: textColor,
        ),
        em: _baseStyle(
          FontType.body2Regular,
          fontStyle: FontStyle.italic,
          textColor: textColor,
          context: context,
        ),
        a: _baseStyle(
          FontType.body2Regular,
          decoration: TextDecoration.underline,
          textColor: textColor,
          context: context,
        ),
        listBullet: _baseStyle(
          FontType.body2Regular,
          textColor: textColor,
          context: context,
        ),
        listIndent: 20.w,
        blockSpacing: 10.w,
        blockquote: _baseStyle(
          FontType.body2Regular,
          fontStyle: FontStyle.italic,
          textColor: textColor,
          context: context,
        ),
        blockquotePadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 8.w,
        ),
        blockquoteDecoration: BoxDecoration(
          color: BGColors.shade200,
          borderRadius: BorderRadius.circular(8.r),
          border: Border(
            left: BorderSide(color: PrimaryColors.shade500, width: 3.w),
          ),
        ),
        code: _baseStyle(FontType.body2Regular, context: context),
        codeblockPadding: EdgeInsets.all(12.w),
        codeblockDecoration: BoxDecoration(color: BGColors.shade300),
      ),
    );
  }
}
