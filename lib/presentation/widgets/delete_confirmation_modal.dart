import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class DeleteConfirmationModal extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const DeleteConfirmationModal({
    super.key,
    this.title = 'Delete Confirmation',
    this.message = 'Are you sure you want to delete this item? This action cannot be undone.',
    this.confirmLabel = 'Delete',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    String title = 'Delete Confirmation',
    String message = 'Are you sure you want to delete this item? This action cannot be undone.',
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      barrierDismissible: true,
      builder: (ctx) => DeleteConfirmationModal(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: () => Navigator.pop(ctx, true),
        onCancel: () => Navigator.pop(ctx, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Red Trash/Warning Icon Header
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.error500.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error500,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                title,
                style: AppTypography.bodyLBold.copyWith(
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Body Message
              Text(
                message,
                style: AppTypography.bodySRegular.copyWith(
                  color: AppColors.neutral500,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Footer Actions
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel ?? () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.neutral300, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor: AppColors.neutral800,
                      ),
                      child: Text(
                        cancelLabel,
                        style: AppTypography.bodySRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Delete Primary Action Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error500,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        confirmLabel,
                        style: AppTypography.bodySRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
