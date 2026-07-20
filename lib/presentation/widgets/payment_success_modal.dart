import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../screens/pos_dashboard_screen.dart';
import 'receipt_preview_modal.dart';

class PaymentSuccessModal extends StatefulWidget {
  final String method; // 'Cash' or 'QRIS'
  final double total;
  final double paid;
  final double change;
  final double subtotal;
  final double discountAmount;
  final double tax;
  final String customerName;
  final List<OrderItem> cartItems;
  final bool isDineIn;
  final String? tableName;

  const PaymentSuccessModal({
    super.key,
    required this.method,
    required this.total,
    required this.paid,
    required this.change,
    required this.subtotal,
    required this.discountAmount,
    required this.tax,
    required this.customerName,
    required this.cartItems,
    required this.isDineIn,
    required this.tableName,
  });

  @override
  State<PaymentSuccessModal> createState() => _PaymentSuccessModalState();
}

class _PaymentSuccessModalState extends State<PaymentSuccessModal> {
  late String _orderId;

  @override
  void initState() {
    super.initState();
    // Generates a unique PZ Order ID based on current timestamp
    _orderId = 'PZ' + DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13);
  }

  // Rupiah formatting helper
  String _formatRupiah(double val) {
    int value = val.toInt();
    String str = value.toString();
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i > 0) {
        result = '.' + result;
        count = 0;
      }
    }
    return 'Rp ' + result;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        width: 480,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            // Green check icon container
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF289656), // Green success color
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.check,
                color: AppColors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Payment Success',
              style: AppTypography.h4Bold.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Order ID Label and Code
            Text(
              'Order ID',
              style: AppTypography.bodyXsRegular.copyWith(
                color: AppColors.neutral500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _orderId,
              style: AppTypography.bodyMRegular.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Conditional Financial Breakdown Row
            if (widget.method == 'Cash') ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Paid',
                          style: AppTypography.bodyXsRegular.copyWith(
                            color: AppColors.neutral500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatRupiah(widget.paid),
                          style: AppTypography.bodyLBold.copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.neutral300,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Change',
                          style: AppTypography.bodyXsRegular.copyWith(
                            color: AppColors.neutral500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatRupiah(widget.change),
                          style: AppTypography.bodyLBold.copyWith(
                            color: AppColors.primary500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              // QRIS Payment Method Summary Label
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Payment Method: ',
                    style: AppTypography.bodySRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                  Text(
                    'QRIS',
                    style: AppTypography.bodySRegular.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            const Divider(color: AppColors.neutral200, height: 1),
            const SizedBox(height: 20),

            // Action Row: View Order & Print Receipt
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // View order triggers navigation or message (TBD as requested: 'tpi itu nanti ajaa')
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Viewing order details (coming soon!)'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('View Order'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.neutral300, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      foregroundColor: AppColors.neutral800,
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final bool? printed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => ReceiptPreviewModal(
                          orderId: _orderId,
                          customerName: widget.customerName,
                          cartItems: widget.cartItems,
                          subtotal: widget.subtotal,
                          discountAmount: widget.discountAmount,
                          tax: widget.tax,
                          total: widget.total,
                          paymentMethod: widget.method,
                          paidAmount: widget.paid,
                          changeAmount: widget.change,
                        ),
                      );
                      if (printed == true && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Receipt printed successfully!'),
                            backgroundColor: AppColors.primary500,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text('Print Receipt'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.neutral300, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      foregroundColor: AppColors.neutral800,
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // New Order Button (Solid Green, Full Width)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: Text(
                  'New Order',
                  style: AppTypography.bodyMRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
