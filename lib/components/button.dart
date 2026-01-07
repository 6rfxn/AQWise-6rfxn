import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outlined, text }

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;

  const MyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    Color? bgColor;
    Color? txtColor;
    Color? borderColor;
    double? elevation;

    switch (variant) {
      case ButtonVariant.primary:
        bgColor = backgroundColor ?? theme.colorScheme.primary;
        txtColor = textColor ?? Colors.white;
        elevation = isEnabled ? 2 : 0;
        break;
      case ButtonVariant.secondary:
        bgColor = backgroundColor ?? theme.colorScheme.secondary;
        txtColor = textColor ?? Colors.white;
        elevation = isEnabled ? 2 : 0;
        break;
      case ButtonVariant.outlined:
        bgColor = Colors.transparent;
        txtColor = textColor ?? theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        elevation = 0;
        break;
      case ButtonVariant.text:
        bgColor = Colors.transparent;
        txtColor = textColor ?? theme.colorScheme.primary;
        elevation = 0;
        break;
    }

    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(txtColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: txtColor),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: txtColor,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w600,
                ),
              ),
            ],
          );

    Widget button = Container(
      width: width,
      height: height ?? 48,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.5)
            : null,
      ),
      child: Center(child: buttonChild),
    );

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: button,
      ),
    );
  }
}