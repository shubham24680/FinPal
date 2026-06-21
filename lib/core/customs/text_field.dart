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
  });

  final TextFieldType textFieldType;
  final InputType inputType;
  final String? header;
  final TextEditingController? controller;
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
  final String? labelText;
  final Color? floatingHintColor;
  final String? errorText;
  final Color? errorColor;
  final String? helperText;
  final String? helperIcon;
  final String? initialValue;
  final List<String> items;
  final Widget? perfixIcon;
  final Widget? suffixIcon;
  final Color? focusedBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final hintStyle = _buildHint(context, hintColor).getTextStyle(context);
    final decoration = InputDecoration(
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
    );
    final textColor = Theme.of(context).colorScheme.onInverseSurface;

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
        dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      TextFieldType.input => TextFormField(
        controller: controller,
        onTap: () => _handleTap(context),
        onChanged: onChanged,
        readOnly: _handleReadOnly(),
        autofocus: autofocus,
        textAlign: textAlign,
        decoration: decoration,
        keyboardType: keyboardType ?? _handleKeyboardType(),
        style: _buildHint(context, textColor).getTextStyle(context),
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
          current,
          firstDate: DateTime(1900),
        );
        controller?.text = picked;
        onChanged?.call(picked);
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
      spacing: 4.spMin,
      children: [
        CustomImage(
          imageType: ImageType.svgLocal,
          imageUrl: helperIcon ?? AppSvgs.info,
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
      InputType.amount => "8124.80",
      InputType.date => "July 11, 2001",
      _ => null,
    };
  }

  Widget? _buildPrefixIcon(BuildContext context) {
    final icon = switch (inputType) {
      InputType.amount => AppSvgs.rupee,
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
      InputType.amount => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        LengthLimitingTextInputFormatter(10),
        AmountInputFormatter(),
      ],
      _ => null,
    };
  }

  InputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.5),
      borderRadius: BorderRadius.circular(12.r),
    );
  }
}

class AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if ('.'.allMatches(text).length > 1) {
      return oldValue;
    }

    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 1 && parts[1].length > 2) {
        return oldValue;
      }
    }

    return newValue;
  }
}
