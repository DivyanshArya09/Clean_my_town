import 'dart:async';

import 'package:app/route/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';

enum TextFieldMode {
  primary,
  secondary,
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.focusNode,
    this.prefix,
    this.suffix,
    this.textInputAction,
    this.maxLength,
    this.inputFormatters,
    this.isPasswordField = false,
    this.keyboardType,
    this.hint,
    this.label,
    this.maxLines,
    this.minLines,
    this.errorText,
    this.onChanged,
    this.autoFocus = false,
    this.isRequired = false,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.disabled = false,
    this.fillColor = AppColors.black,
    this.leftPadding = 19.0,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding,
    this.onSubmitted,
    this.borderRadius = 10.0,
    this.title,
    this.prefixText,
    this.prefixIcon,
    this.textInputFormatter,
  }) : textFieldMode = TextFieldMode.primary;

  final TextFieldMode textFieldMode;
  final String? errorText;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? hint;
  final String? label;
  final bool autoFocus;
  final bool isRequired;
  final bool obscureText;
  final String obscuringCharacter;
  final ValueChanged<String>? onChanged;
  final bool isPasswordField;
  final bool disabled;
  final Color fillColor;
  final EdgeInsets? scrollPadding;
  final double leftPadding;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;
  final void Function(String)? onSubmitted;
  final double borderRadius;
  final String? title;
  final String? prefixText;
  final IconData? prefixIcon;
  final TextInputFormatter? textInputFormatter;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final StreamController<bool> _focusChangeStream = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return _mapModeToTextField();
  }

  OutlineInputBorder _buildPrimaryBorder(
      [Color color = AppColors.black, double borderWidth = 0.5]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color, width: borderWidth),
    );
  }

  UnderlineInputBorder _buildSecondaryBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 1,
      ),
    );
  }

  Widget _mapModeToTextField() {
    switch (widget.textFieldMode) {
      case TextFieldMode.primary:
        return _buildPrimaryTextField();
      case TextFieldMode.secondary:
        return _buildSecondaryTextField();
    }
  }

  Widget _buildPrimaryTextField() => SizedBox(
        // height: widget.errorText != null && widget.errorText!.isNotEmpty
        //     ? 80.h
        //     : 70.h,
        child: Column(
          children: [
            StreamBuilder<bool>(
                stream: _focusChangeStream.stream,
                initialData: false,
                builder: (context, snapshot) {
                  bool focused = snapshot.data!;
                  return Container(
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        _focusChangeStream.add(hasFocus);
                      },
                      child: TextFormField(
                        maxLines: widget.maxLines,
                        scrollPadding: widget.scrollPadding ??
                            const EdgeInsets.only(bottom: 110),
                        minLines: widget.minLines,
                        onChanged: widget.onChanged,
                        onFieldSubmitted: widget.onSubmitted,
                        textInputAction: widget.textInputAction,
                        // onSubmitted: widget.onSubmitted,
                        controller: widget.controller,
                        validator: widget.validator,
                        enabled: !widget.disabled,
                        cursorColor: AppColors.primary,
                        autofocus: widget.autoFocus,
                        focusNode: widget.focusNode,
                        inputFormatters: widget.inputFormatters,
                        keyboardType: widget.keyboardType,
                        textCapitalization: widget.textCapitalization,
                        maxLength: widget.maxLength,
                        obscureText: widget.obscureText,
                        obscuringCharacter: widget.obscuringCharacter,

                        decoration: InputDecoration(
                          filled: false,
                          fillColor: focused ? null : widget.fillColor,
                          // hintStyle: AppTextStyles
                          //     .textStyles_PTSans_16_400_Secondary
                          //     .copyWith(fontSize: 14),
                          errorStyle: const TextStyle(
                            fontSize: 14,
                          ),
                          counterText: "",
                          isDense: true,
                          border: _buildPrimaryBorder(),
                          enabledBorder: _buildPrimaryBorder(),
                          disabledBorder: _buildPrimaryBorder(),
                          focusedBorder:
                              _buildPrimaryBorder(AppColors.primary, 1.3),
                          errorBorder: _buildPrimaryBorder(
                            Theme.of(kNavigatorKey.currentContext!)
                                .colorScheme
                                .error,
                            1.3,
                          ),
                          focusedErrorBorder: _buildPrimaryBorder(
                            Theme.of(kNavigatorKey.currentContext!)
                                .colorScheme
                                .error,
                            1.3,
                          ),
                          hintText: widget.hint,
                          errorText: widget.errorText,
                          // labelText: widget.label,

                          contentPadding: EdgeInsets.all(14.w),
                          prefixIcon: widget.prefix,
                          suffixIcon: widget.isPasswordField
                              ? Icon(focused
                                  ? Icons.visibility
                                  : Icons.remove_red_eye)
                              : widget.suffix,
                          // suffixIconColor: AppColors.grey,
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      );

  Widget _buildSecondaryTextField() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                widget.title!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0x80000000),
                  // fontFamily: AppFontFamily.maisonNeue,
                ),
              ),
            ),
          TextFormField(
            cursorColor: AppColors.primary,
            controller: widget.controller,
            validator: widget.validator,
            onChanged: widget.onChanged,
            textCapitalization: widget.textCapitalization,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              border: _buildSecondaryBorder(Color(0x80000000)),
              enabledBorder: _buildSecondaryBorder(Color(0x80000000)),
              disabledBorder: _buildSecondaryBorder(Color(0x80000000)),
              focusedBorder: _buildSecondaryBorder(AppColors.black),
              errorBorder:
                  _buildSecondaryBorder(Theme.of(context).colorScheme.error),
              focusedErrorBorder:
                  _buildSecondaryBorder(Theme.of(context).colorScheme.error),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0x80000000),
                // fontFamily: AppFontFamily.maisonNeue,
              ),
              counterStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0x80000000),
                // fontFamily: AppFontFamily.maisonNeue,
              ),
              prefixIcon: widget.prefixText != null
                  ? UnconstrainedBox(
                      child: Text(
                        widget.prefixText!,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                          // fontFamily: AppFontFamily.maisonNeue,
                        ),
                      ),
                    )
                  : null,
            ),
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
              // fontFamily: AppFontFamily.maisonNeue,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxLength),
              if (widget.textInputFormatter != null) widget.textInputFormatter!
            ],
          ),
        ],
      );
}
