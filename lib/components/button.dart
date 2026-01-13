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
    final colors = _getColors(theme);
    final radius = borderRadius ?? BorderRadius.circular(8);

    return Material(
      color: Colors.transparent,
      elevation: colors.elevation,
      borderRadius: radius,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: radius,
        child: Container(
          width: width,
          height: height ?? 48,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: radius,
            border: colors.border != null
                ? Border.all(color: colors.border!, width: 1.5)
                : null,
          ),
          child: Center(child: _buildContent(colors.text)),
        ),
      ),
    );
  }

  _ButtonColors _getColors(ThemeData theme) {
    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonColors(
          background: backgroundColor ?? theme.colorScheme.primary,
          text: textColor ?? Colors.white,
          elevation: (onPressed != null && !isLoading) ? 2.0 : 0.0,
        );
      case ButtonVariant.secondary:
        return _ButtonColors(
          background: backgroundColor ?? theme.colorScheme.secondary,
          text: textColor ?? Colors.white,
          elevation: (onPressed != null && !isLoading) ? 2.0 : 0.0,
        );
      case ButtonVariant.outlined:
        return _ButtonColors(
          background: Colors.transparent,
          text: textColor ?? theme.colorScheme.primary,
          border: theme.colorScheme.primary,
        );
      case ButtonVariant.text:
        return _ButtonColors(
          background: Colors.transparent,
          text: textColor ?? theme.colorScheme.primary,
        );
    }
  }

  Widget _buildContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ButtonColors {
  final Color background;
  final Color text;
  final Color? border;
  final double elevation;

  _ButtonColors({
    required this.background,
    required this.text,
    this.border,
    this.elevation = 0.0,
  });
}