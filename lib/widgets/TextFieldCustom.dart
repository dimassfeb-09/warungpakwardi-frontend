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
  final bool? enabled;

  final Function(dynamic value)? onChange;
  final Function(dynamic value)? onSubmitted;

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

  @override
  void initState() {
    super.initState();
    obscureText = widget.textInputType == TextFieldType.password;
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void _handleOnChange(String value) {
    switch (widget.textInputType) {
      case TextFieldType.number:
        if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return; // Mencegah input selain angka
        }
        break;
      case TextFieldType.email:
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          // Bisa tambahkan logika untuk validasi email
        }
        break;
      case TextFieldType.phone:
        if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return; // Mencegah input selain angka
        }
        break;
      default:
        break;
    }

    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  @override
  void didUpdateWidget(covariant TextFieldCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        Container(
          height: 56, // Menentukan tinggi container
          decoration: BoxDecoration(
            color:
                widget.enabled == true ? widget.colorField : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            // Memastikan konten berada di tengah
            child: TextField(
              controller: widget.controller,
              obscureText: obscureText,
              keyboardType: textInputType(),
              enabled: widget.enabled,
              onChanged: _handleOnChange,
              onSubmitted: widget.onSubmitted,
              decoration: InputDecoration(
                prefixIcon:
                    widget.prefix != null
                        ? widget.prefix is Icon
                            ? widget.prefix
                            : Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                                left: 16,
                                right: 8,
                              ),
                              child: widget.prefix,
                            )
                        : null,
                suffixIcon: _buildSuffixIcon(),
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: kGreyDarkColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.textInputType == TextFieldType.password) {
      return GestureDetector(
        onTap: toggleObscureText,
        child: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
      );
    }
    return widget.suffix;
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
