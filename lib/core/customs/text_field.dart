import 'dart:ui';

import 'package:finpal/app/app.dart';
import 'package:flutter/services.dart';

enum TextFieldType { input, dropdown }

enum InputType { text, amount }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.inputType = InputType.text,
    this.textFieldType = TextFieldType.input,
    this.header,
    this.controller,
    this.fillColor,
    this.labelText,
    this.hintText,
    this.hintColor,
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
  });

  final InputType inputType;
  final TextFieldType textFieldType;
  final String? header;
  final TextEditingController? controller;
  final bool readOnly;
  final bool autofocus;
  final Color? fillColor;
  final Color? hintColor;
  final Color? floatingHintColor;
  final Color? errorColor;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final List<String> items;
  final TextInputType? keyboardType;
  final Widget? perfixIcon;
  final Widget? suffixIcon;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final TextAlign textAlign;
  final int maxLines;
  final Color? focusedBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      fillColor: fillColor,
      labelText: labelText,
      hintText: hintText ?? _buildHintText(),
      errorText: errorText,
      labelStyle: buildHint(context, hintColor).getTextStyle(context),
      floatingLabelStyle: buildHint(
        context,
        floatingHintColor,
      ).getTextStyle(context),
      hintStyle: buildHint(context, hintColor).getTextStyle(context),
      errorStyle: buildHint(
        context,
        Colors.red.shade700,
        fontType: FontType.label1Regular,
      ).getTextStyle(context),
      prefixIcon: (perfixIcon ?? _buildPrefixIcon())?.padding(horizontal: 10.w),
      suffixIcon: suffixIcon?.padding(all: 10.w),
    );

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
        // initialValue: initialValue,
        value: initialValue,
        onChanged: onChanged,
        decoration: decoration.copyWith(suffixIcon: suffixIcon),
        style: buildHint(context, PrimaryColors.shade500).getTextStyle(context),
        hint: buildHint(context, hintColor, text: hintText),
        dropdownColor: PrimaryColors.shade500,
        borderRadius: BorderRadius.circular(0.015.sh),
      ),
      TextFieldType.input => TextFormField(
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        decoration: decoration,
        readOnly: readOnly,
        autofocus: autofocus,
        textAlign: textAlign,
        keyboardType: keyboardType ?? _buildTextInputType(),
        style: buildHint(context, TextColors.shade900).getTextStyle(context),
        cursorColor: focusedBorderColor ?? BGColors.shade700,
        cursorErrorColor: Colors.red.shade700,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters ?? _buildInputFormatters(),
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

  String? _buildHintText() {
    return switch (inputType) {
      InputType.amount => "8124.80",
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
      fontType: fontType ?? FontType.body1Medium,
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
