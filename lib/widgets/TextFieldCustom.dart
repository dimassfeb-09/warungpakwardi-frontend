import 'package:flutter/material.dart';

import '../constant/color.dart';

enum TextFieldType { text, number, email, password, phone }

class TextFieldCustom extends StatefulWidget {
  final String? title;
  final TextEditingController? controller;
  final String hintText;
  final TextFieldType textInputType;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final Color? colorField;
  final bool enabled;

  final Function(String value)? onChange;
  final Function(String value)? onSubmitted;

  const TextFieldCustom({
    super.key,
    this.title,
    required this.hintText,
    this.controller,
    this.textInputType = TextFieldType.text,
    this.prefix,
    this.suffix,
    this.errorText,
    this.colorField,
    this.enabled = true,
    this.onChange,
    this.onSubmitted,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool obscureText = false;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.textInputType == TextFieldType.password;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void _handleOnChange(String value) {
    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: AppTypography.title(context).copyWith(
              color: _isFocused ? kBluePrimary : AppColors.onSurface(context),
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.enabled
                ? (widget.colorField ?? (isDark ? kBlack2Color : kLightGreyColor))
                : (isDark ? Colors.white10 : kGreyColor),
            borderRadius: BorderRadius.circular(kInputRadius),
            border: Border.all(
              color: widget.errorText != null
                  ? kRedColor
                  : (_isFocused ? kBluePrimary : Colors.transparent),
              width: 1.5,
            ),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: obscureText,
              keyboardType: textInputType(),
              enabled: widget.enabled,
              onChanged: _handleOnChange,
              onSubmitted: widget.onSubmitted,
              style: AppTypography.body(context),
              decoration: InputDecoration(
                prefixIcon: widget.prefix != null
                    ? IconTheme(
                        data: IconThemeData(
                          color: _isFocused ? kBluePrimary : kGreyDarkColor,
                        ),
                        child: widget.prefix!,
                      )
                    : null,
                suffixIcon: _buildSuffixIcon(isDark),
                hintText: widget.hintText,
                hintStyle: AppTypography.body(context).copyWith(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.errorText!,
              style: AppTypography.caption(context).copyWith(color: kRedColor),
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon(bool isDark) {
    if (widget.textInputType == TextFieldType.password) {
      return GestureDetector(
        onTap: toggleObscureText,
        child: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: _isFocused ? kBluePrimary : kGreyDarkColor,
        ),
      );
    }
    return widget.suffix != null
        ? IconTheme(
            data: IconThemeData(
              color: _isFocused ? kBluePrimary : kGreyDarkColor,
            ),
            child: widget.suffix!,
          )
        : null;
  }

  TextInputType textInputType() {
    final textFieldType = widget.textInputType;
    switch (textFieldType) {
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      case TextFieldType.email:
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}
