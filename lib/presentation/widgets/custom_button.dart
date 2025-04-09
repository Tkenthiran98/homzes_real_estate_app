import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isOutlined;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final BorderRadius? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isOutlined = false,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? Colors.white;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(32);

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isDisabled || isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDisabled
                      ? effectiveBackgroundColor.withOpacity(0.5)
                      : effectiveBackgroundColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: effectiveBorderRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: _buildButtonContent(
                effectiveTextColor: effectiveBackgroundColor,
                effectiveBackgroundColor: Colors.transparent,
              ),
            )
          : ElevatedButton(
              onPressed: isDisabled || isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                foregroundColor: effectiveTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: effectiveBorderRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                disabledBackgroundColor: effectiveBackgroundColor.withOpacity(0.5),
                disabledForegroundColor: effectiveTextColor.withOpacity(0.7),
              ),
              child: _buildButtonContent(
                effectiveTextColor: effectiveTextColor,
                effectiveBackgroundColor: effectiveBackgroundColor,
              ),
            ),
    );
  }

  Widget _buildButtonContent({
    required Color effectiveTextColor,
    required Color effectiveBackgroundColor,
  }) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? effectiveBackgroundColor : effectiveTextColor,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDisabled
                ? effectiveTextColor.withOpacity(0.7)
                : effectiveTextColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDisabled
                  ? effectiveTextColor.withOpacity(0.7)
                  : effectiveTextColor,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isDisabled
            ? effectiveTextColor.withOpacity(0.7)
            : effectiveTextColor,
      ),
    );
  }
}