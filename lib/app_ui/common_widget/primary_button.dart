import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? color;
  final Color? disabledColor;
  final Color? textColor;
  final Color? loadingColor;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final double? elevation;
  final TextStyle? textStyle;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 60.0,
    this.borderRadius = 8.0,
    this.color,
    this.disabledColor,
    this.textColor,
    this.loadingColor,
    this.padding,
    this.icon,
    this.elevation,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;
    final disabledBtnColor = disabledColor ?? theme.disabledColor;
    final btnTextColor = textColor ?? Colors.white;
    final btnLoadingColor = loadingColor ?? Colors.white;

    return Container(
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: (isDisabled || isLoading) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? disabledBtnColor : buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: elevation,
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: isLoading
              ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: btnLoadingColor,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: (textStyle ?? theme.textTheme.labelLarge)?.copyWith(
                  color: btnTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}