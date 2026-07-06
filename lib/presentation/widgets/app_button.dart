import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum AppButtonVariant {
  solid,
  gradient,
  outline,
  text,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isEnabled;
  final IconData? iconLeft;
  final IconData? iconRight;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.solid,
    this.isEnabled = true,
    this.iconLeft,
    this.iconRight,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPress = isEnabled && onPressed != null;

    return Container(
      height: 54,
      decoration: _buildContainerDecoration(canPress),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canPress ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconLeft != null) ...[
                  Icon(
                    iconLeft,
                    color: _getTextColor(canPress),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTypography.bodyMRegular.copyWith(
                    color: _getTextColor(canPress),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (iconRight != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    iconRight,
                    color: _getTextColor(canPress),
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration(bool canPress) {
    if (!canPress) {
      if (variant == AppButtonVariant.solid || variant == AppButtonVariant.gradient) {
        return BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(12),
        );
      }
      if (variant == AppButtonVariant.outline) {
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral200, width: 1.5),
        );
      }
      return const BoxDecoration(color: Colors.transparent);
    }

    switch (variant) {
      case AppButtonVariant.solid:
        return BoxDecoration(
          color: AppColors.primary500,
          borderRadius: BorderRadius.circular(12),
        );
      case AppButtonVariant.gradient:
        return BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        );
      case AppButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.neutral300,
            width: 1.5,
          ),
        );
      case AppButtonVariant.text:
        return const BoxDecoration(color: Colors.transparent);
    }
  }

  Color _getTextColor(bool canPress) {
    if (!canPress) {
      return AppColors.neutral400; // Disabled text color (#8F8F8F)
    }

    switch (variant) {
      case AppButtonVariant.solid:
      case AppButtonVariant.gradient:
        return AppColors.white;
      case AppButtonVariant.outline:
        return AppColors.neutral900; // Text black in light mode (#141414)
      case AppButtonVariant.text:
        return AppColors.primary500;
    }
  }
}
