import 'package:finpal/app/app.dart';
import 'package:finpal/core/theme/app_colors.dart';
import 'package:flutter/services.dart';

enum TextFieldType { input, dropdown }

enum InputType { text, amount, dob }

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
    final hintStyle = buildHint(context, hintColor).getTextStyle(context);
    final decoration = InputDecoration(
      fillColor: fillColor,
      hintText: hintText ?? _buildHintText(),
      hintStyle: hintStyle,
      labelText: labelText,
      labelStyle: hintStyle,
      floatingLabelStyle: buildHint(
        context,
        floatingHintColor,
      ).getTextStyle(context),
      errorText: errorText,
      errorStyle: buildHint(
        context,
        AppColors.error500,
        fontType: FontType.label1Regular,
      ).getTextStyle(context),
      helper: _buildHelperText(context, helperText, helperIcon),
      prefixIcon: (perfixIcon ?? _buildPrefixIcon())?.padding(horizontal: 10.r),
      suffixIcon: suffixIcon?.padding(all: 10.r),
    );
    final textColor = Theme.of(context).colorScheme.onInverseSurface;

    final dropDownMenu =
        items
            .map(
              (value) => DropdownMenuItem(
                value: value,
                child: buildHint(context, PrimaryColors.shade500, text: value),
              ),
            )
            .toList();

    Widget field = switch (textFieldType) {
      TextFieldType.dropdown => DropdownButtonFormField(
        items: dropDownMenu,
        value: initialValue,
        onChanged: onChanged,
        decoration: decoration.copyWith(suffixIcon: suffixIcon),
        style: buildHint(context, PrimaryColors.shade500).getTextStyle(context),
        hint: buildHint(context, hintColor, text: hintText),
        dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      TextFieldType.input => TextFormField(
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        readOnly: readOnly,
        autofocus: autofocus,
        textAlign: textAlign,
        decoration: decoration,
        keyboardType: keyboardType ?? _buildTextInputType(),
        style: buildHint(context, textColor).getTextStyle(context),
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
            fontType: FontType.body1Medium,
            color: Theme.of(context).colorScheme.onSurface,
          ).padding(left: 4.r, bottom: 2.r),
        field,
      ],
    );
  }

  void _buildOnTap() {}

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
        buildHint(
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
      InputType.dob => "02/08/1989",
      _ => null,
    };
  }

  // String? _buildErrorText() {
  //   return switch (inputType) {
  //     InputType.amount => "Amount should be greater than 0",
  //     _ => null,
  //   };
  // }

  Widget? _buildPrefixIcon() {
    final icon = switch (inputType) {
      InputType.amount => AppSvgs.rupee,
      _ => null,
    };

    return icon != null
        ? CustomImage(imageType: ImageType.svgLocal, imageUrl: icon)
        : null;
  }

  TextInputType _buildTextInputType() {
    return switch (inputType) {
      InputType.amount => TextInputType.numberWithOptions(decimal: true),
      _ => TextInputType.text,
    };
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

  CustomTypography buildHint(
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
