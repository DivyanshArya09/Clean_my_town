import 'dart:async';

import 'package:app/route/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';

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
  });

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
  final bool? isPasswordField;
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
  final StreamController<bool> _passwordVisibilityStream =
      StreamController<bool>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _passwordVisibilityStream.add(widget.obscureText);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPrimaryTextField();
  }

  OutlineInputBorder _buildPrimaryBorder(
      [Color color = AppColors.black, double borderWidth = 0.5]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color, width: borderWidth),
    );
  }

  Widget _buildPrimaryTextField() => Column(
        children: [
          StreamBuilder<bool>(
            stream: _passwordVisibilityStream.stream,
            builder: (context, snapshot) {
              final bool isPassword = widget.isPasswordField ?? false;

              if (snapshot.hasData)
                return TextFormField(
                  maxLines: isPassword ? 1 : widget.maxLines,
                  scrollPadding: widget.scrollPadding ??
                      const EdgeInsets.only(bottom: 110),
                  minLines: widget.minLines,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  textInputAction: widget.textInputAction,
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
                  obscureText: isPassword ? snapshot.data ?? false : false,
                  obscuringCharacter: widget.obscuringCharacter,
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: widget.fillColor,
                    errorStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    counterText: "",
                    isDense: true,
                    border: _buildPrimaryBorder(),
                    enabledBorder: _buildPrimaryBorder(),
                    disabledBorder: _buildPrimaryBorder(),
                    focusedBorder: _buildPrimaryBorder(AppColors.primary, 1.3),
                    errorBorder: _buildPrimaryBorder(
                      Theme.of(kNavigatorKey.currentContext!).colorScheme.error,
                      1.3,
                    ),
                    focusedErrorBorder: _buildPrimaryBorder(
                      Theme.of(kNavigatorKey.currentContext!).colorScheme.error,
                      1.3,
                    ),
                    hintText: widget.hint,
                    errorText: widget.errorText,
                    contentPadding: EdgeInsets.all(14.w),
                    prefixIcon: widget.prefix,
                    suffixIcon: isPassword
                        ? GestureDetector(
                            onTap: () => _passwordVisibilityStream.add(
                              !(snapshot.data ?? false),
                            ),
                            child: Icon((snapshot.data ?? false)
                                ? Icons.visibility_off
                                : Icons.visibility),
                          )
                        : widget.suffix,
                  ),
                );
              return SizedBox();
            },
          ),
        ],
      );
}
