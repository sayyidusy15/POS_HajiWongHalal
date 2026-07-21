import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class CustomSuccessToast extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? highlightText;
  final VoidCallback onDismiss;
  final Duration duration;
  final bool isSuccess;

  const CustomSuccessToast({
    super.key,
    required this.title,
    required this.subtitle,
    this.highlightText,
    required this.onDismiss,
    this.duration = const Duration(seconds: 3),
    this.isSuccess = true,
  });

  @override
  State<CustomSuccessToast> createState() => _CustomSuccessToastState();
}

class _CustomSuccessToastState extends State<CustomSuccessToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = widget.isSuccess ? AppColors.primary500 : AppColors.error500;
    final IconData iconData = widget.isSuccess ? Icons.check : Icons.info_outline;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 380,
        margin: const EdgeInsets.only(top: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circle check icon
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      iconData,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Text details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: AppTypography.bodyMBold.copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (widget.highlightText != null)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.highlightText,
                                  style: AppTypography.bodyXsRegular.copyWith(
                                    color: AppColors.error500,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: widget.subtitle,
                                  style: AppTypography.bodyXsRegular.copyWith(
                                    color: AppColors.neutral600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            widget.subtitle,
                            style: AppTypography.bodyXsRegular.copyWith(
                              color: AppColors.neutral600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Close Button
                  GestureDetector(
                    onTap: widget.onDismiss,
                    child: const Icon(
                      Icons.close,
                      color: AppColors.neutral500,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Loading Progress Bar at the bottom
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 4,
                    width: 380 * (1.0 - _controller.value),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
