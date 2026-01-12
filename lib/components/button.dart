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
    final enabled = onPressed != null && !isLoading;

    Color? bg;
    Color? txt;
    Color? border;
    double? elev;

    switch (variant) {
      case ButtonVariant.primary:
        bg = backgroundColor ?? theme.colorScheme.primary;
        txt = textColor ?? Colors.white;
        elev = enabled ? 2 : 0;
        break;
      case ButtonVariant.secondary:
        bg = backgroundColor ?? theme.colorScheme.secondary;
        txt = textColor ?? Colors.white;
        elev = enabled ? 2 : 0;
        break;
      case ButtonVariant.outlined:
        bg = Colors.transparent;
        txt = textColor ?? theme.colorScheme.primary;
        border = theme.colorScheme.primary;
        elev = 0;
        break;
      case ButtonVariant.text:
        bg = Colors.transparent;
        txt = textColor ?? theme.colorScheme.primary;
        elev = 0;
        break;
    }

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(txt),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: txt),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: txt,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w600,
                ),
              ),
            ],
          );

    return Material(
      color: Colors.transparent,
      elevation: elev,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Container(
          width: width,
          height: height ?? 48,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            border: border != null
                ? Border.all(color: border, width: 1.5)
                : null,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}