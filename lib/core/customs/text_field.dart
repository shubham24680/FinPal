import 'package:finpal/app/app.dart';
import 'package:flutter/services.dart';

enum TextFieldType { input, dropdown }

enum InputType { text, amount, date }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.textFieldType = TextFieldType.input,
    this.inputType = InputType.text,
    this.header,
    this.controller,
    this.focusNode,
    this.fillColor,
    this.hintText,
    this.hintColor,
    this.labelText,
    this.errorText,
    this.floatingHintColor,
    this.errorColor,
    this.keyboardType,
    this.items = const [],
    this.onChanged,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.initialValue,
    this.perfixIcon,
    this.suffixIcon,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.focusedBorderColor,
    this.inputFormatters,
    this.maxLength,
    this.helperText,
    this.helperIcon,
    this.isUnderLineBorder = false,
    this.hintStyle,
    this.style,
  });

  final TextFieldType textFieldType;
  final InputType inputType;
  final String? header;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final TextAlign textAlign;
  final int maxLines;
  final Color? fillColor;
  final String? hintText;
  final Color? hintColor;
  final TextStyle? hintStyle;
  final String? labelText;
  final Color? floatingHintColor;
  final String? errorText;
  final Color? errorColor;
  final TextStyle? style;
  final String? helperText;
  final String? helperIcon;
  final String? initialValue;
  final List<String> items;
  final Widget? perfixIcon;
  final Widget? suffixIcon;
  final Color? focusedBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool isUnderLineBorder;

  @override
  Widget build(BuildContext context) {
    final hintStyle =
        this.hintStyle ?? _buildHint(context, hintColor).getTextStyle(context);
    final decoration = InputDecoration(
      filled: fillColor != null,
      fillColor: fillColor,
      hintText: hintText ?? _buildHintText(),
      hintStyle: hintStyle,
      labelText: labelText,
      labelStyle: hintStyle,
      floatingLabelStyle: _buildHint(
        context,
        floatingHintColor,
      ).getTextStyle(context),
      errorText: errorText,
      errorStyle: _buildHint(
        context,
        AppColors.error500,
        fontType: FontType.label1Regular,
      ).getTextStyle(context),
      helper: _buildHelperText(context, helperText, helperIcon),
      prefixIcon: (perfixIcon ?? _buildPrefixIcon(context))?.padding(
        horizontal: 10.r,
      ),
      suffixIcon: suffixIcon?.padding(all: 10.r),
      border: buildUnderLineBorder(color: context.colors.outline),
      enabledBorder: buildUnderLineBorder(color: context.colors.outline),
      focusedBorder: buildUnderLineBorder(color: context.colors.primary),
      errorBorder: buildUnderLineBorder(color: context.colors.error),
      focusedErrorBorder: buildUnderLineBorder(
        color: context.colors.error,
        width: 2,
      ),
    );
    final textColor = context.colors.onInverseSurface;

    final dropDownMenu =
        items
            .map(
              (value) => DropdownMenuItem(
                value: value,
                child: _buildHint(context, PrimaryColors.shade500, text: value),
              ),
            )
            .toList();

    Widget field = switch (textFieldType) {
      TextFieldType.dropdown => DropdownButtonFormField(
        items: dropDownMenu,
        value: initialValue,
        onChanged: onChanged,
        decoration: decoration.copyWith(suffixIcon: suffixIcon),
        style: _buildHint(
          context,
          PrimaryColors.shade500,
        ).getTextStyle(context),
        hint: _buildHint(context, hintColor, text: hintText),
        dropdownColor: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      TextFieldType.input => TextFormField(
        controller: controller,
        focusNode: focusNode,
        onTap: () => _handleTap(context),
        onChanged: onChanged,
        readOnly: _handleReadOnly(),
        autofocus: autofocus,
        textAlign: textAlign,
        decoration: decoration,
        keyboardType: keyboardType ?? _handleKeyboardType(),
        style: style ?? _buildHint(context, textColor).getTextStyle(context),
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters ?? _buildInputFormatters(),
        cursorColor: AppColors.primary500,
        cursorErrorColor: AppColors.error500,
      ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          CustomTypography(
            text: header,
            fontType: FontType.body2Medium,
            color: Theme.of(context).colorScheme.onSurface,
          ).padding(left: 4.r, bottom: 2.r),
        field,
      ],
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    switch (inputType) {
      case InputType.date:
        final current = controller?.text ?? '';
        final picked = await CustomBottomSheet.chooseDate(
          context,
          date: current.isEmpty ? null : current.parseDate(type: DateFormatType.fullDate),
          firstDate: DateTime(1900),
        );
        final formattedDate = picked != null ? picked.formatDate(type: DateFormatType.fullDate) : '';
        controller?.text = formattedDate;
        onChanged?.call(formattedDate);
        break;
      default:
        onTap?.call();
        break;
    }
  }

  bool _handleReadOnly() {
    return switch (inputType) {
      InputType.date => true,
      _ => readOnly,
    };
  }

  TextInputType _handleKeyboardType() {
    return switch (inputType) {
      InputType.amount => TextInputType.numberWithOptions(decimal: true),
      _ => TextInputType.text,
    };
  }

  CustomTypography _buildHint(
    BuildContext context,
    Color? color, {
    String? text,
    FontType? fontType,
  }) {
    return CustomTypography(
      text: text,
      color: color ?? Theme.of(context).colorScheme.outline,
      fontType: fontType ?? FontType.body1Semibold,
    );
  }

  Widget? _buildHelperText(
    BuildContext context,
    String? helperText,
    String? helperIcon,
  ) {
    if (helperText == null) return null;
    return Row(
      spacing: 8.spMin,
      children: [
        if (helperIcon != null)
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: helperIcon,
            height: 16.spMin,
            color: AppColors.primary500,
          ),
        _buildHint(
          context,
          Theme.of(context).colorScheme.onSurfaceVariant,
          text: helperText,
          fontType: FontType.label1Medium,
        ),
      ],
    );
  }

  String? _buildHintText() {
    return switch (inputType) {
      InputType.amount => CurrencyFormatter.formatInput("1250.00"),
      InputType.date => "July 11, 2001",
      _ => null,
    };
  }

  Widget? _buildPrefixIcon(BuildContext context) {
    final icon = switch (inputType) {
      InputType.amount => AppSvgs.money,
      InputType.date => AppSvgs.calendar,
      _ => null,
    };

    final color = Theme.of(context).colorScheme.primary;
    return icon != null
        ? CustomImage(
          imageType: ImageType.svgLocal,
          imageUrl: icon,
          color: color,
        )
        : null;
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    return switch (inputType) {
      InputType.amount => [AmountInputFormatter()],
      _ => null,
    };
  }

  InputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.5),
      borderRadius: BorderRadius.circular(12.r),
    );
  }

  InputBorder? buildUnderLineBorder({
    Color color = AppColors.primary500,
    double width = 1,
  }) {
    if (!isUnderLineBorder) return null;
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class AmountInputFormatter extends TextInputFormatter {
  AmountInputFormatter({
    this.currency = CurrencyContants.rupee,
    this.decimalDigits = 2,
    this.maxIntegerDigits = 16,
  });

  final CurrencyContants currency;
  final int decimalDigits;
  final int maxIntegerDigits;

  static final _significant = RegExp(r'[0-9.]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    var raw = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final firstDot = raw.indexOf('.');
    if (firstDot != -1) {
      raw =
          raw.substring(0, firstDot + 1) +
          raw.substring(firstDot + 1).replaceAll('.', '');
    }

    final parts = raw.split('.');
    var intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : null;

    if (intPart.length > maxIntegerDigits) return oldValue;
    if (decPart != null && decPart.length > decimalDigits) return oldValue;

    if (intPart.length > 1) {
      intPart = intPart.replaceFirst(RegExp(r'^0+(?=.)'), '');
    }

    raw =
        decPart == null
            ? (raw.endsWith('.') ? '$intPart.' : intPart)
            : '$intPart.$decPart';

    if (raw.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final formatted = CurrencyFormatter.formatInput(
      raw,
      currency: currency,
      decimalDigits: decimalDigits,
    );

    final selection = newValue.selection;
    final base = _offsetForSignificantCount(
      formatted,
      _countSignificant(newValue.text, selection.baseOffset),
    );
    final extent = _offsetForSignificantCount(
      formatted,
      _countSignificant(newValue.text, selection.extentOffset),
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection(baseOffset: base, extentOffset: extent),
    );
  }

  /// Counts digits and `.` before [offset], ignoring grouping separators.
  static int _countSignificant(String text, int offset) {
    final end = offset.clamp(0, text.length);
    var count = 0;
    for (var i = 0; i < end; i++) {
      if (_significant.hasMatch(text[i])) count++;
    }
    return count;
  }

  /// Finds the cursor index in [text] after [count] significant characters.
  static int _offsetForSignificantCount(String text, int count) {
    if (count <= 0) return 0;
    var seen = 0;
    for (var i = 0; i < text.length; i++) {
      if (_significant.hasMatch(text[i])) {
        seen++;
        if (seen >= count) return i + 1;
      }
    }
    return text.length;
  }
}
