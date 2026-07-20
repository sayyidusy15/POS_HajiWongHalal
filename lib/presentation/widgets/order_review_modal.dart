import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../screens/pos_dashboard_screen.dart';

class OrderReviewModal extends StatelessWidget {
  final List<OrderItem> cartItems;
  final String customerName;
  final String? tableName;
  final bool isDineIn;
  final double subtotal;
  final double discountAmount;
  final double tax;
  final double total;

  const OrderReviewModal({
    super.key,
    required this.cartItems,
    required this.customerName,
    required this.tableName,
    required this.isDineIn,
    required this.subtotal,
    required this.discountAmount,
    required this.tax,
    required this.total,
  });

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
        width: 520,
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. HEADER
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.neutral50,
                border: Border(
                  bottom: BorderSide(color: AppColors.neutral200, width: 1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Order Review',
                style: AppTypography.bodyLBold.copyWith(
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 2. BODY (Scrollable)
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: General Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: isDineIn ? Icons.restaurant : Icons.shopping_bag,
                            label: 'Order Mode',
                            value: isDineIn ? 'Dine In' : 'Take Away',
                          ),
                          const SizedBox(height: 10),
                          _buildDetailRow(
                            icon: Icons.person_outline,
                            label: 'Customer',
                            value: customerName,
                          ),
                          if (isDineIn && tableName != null) ...[
                            const SizedBox(height: 10),
                            _buildDetailRow(
                              icon: Icons.table_restaurant_outlined,
                              label: 'Table',
                              value: tableName!,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Items Summary List
                    Text(
                      'Items Summary',
                      style: AppTypography.bodySMedium.copyWith(
                        color: AppColors.neutral600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.neutral100,
                        ),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final double itemTotal = item.product.price * item.quantity;
                          final String baseName = item.product.name.split(' (').first;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        baseName,
                                        style: AppTypography.bodySRegular.copyWith(
                                          color: AppColors.neutral800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.product.category,
                                        style: AppTypography.bodyXsRegular.copyWith(
                                          color: AppColors.neutral500,
                                        ),
                                      ),
                                      if (item.size != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Size: ${item.size}',
                                          style: AppTypography.bodyXsRegular.copyWith(
                                            color: AppColors.neutral500,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                      if (item.addons != null && item.addons!.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Add-ons: ${item.addons!.join(", ")}',
                                          style: AppTypography.bodyXsRegular.copyWith(
                                            color: AppColors.neutral500,
                                          ),
                                        ),
                                      ],
                                      if (item.notes != null && item.notes!.trim().isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.neutral100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.edit_note, size: 14, color: AppColors.neutral500),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  '"${item.notes}"',
                                                  style: AppTypography.bodyXsRegular.copyWith(
                                                    color: AppColors.neutral600,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    'x${item.quantity}',
                                    style: AppTypography.bodySRegular.copyWith(
                                      color: AppColors.neutral600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    _formatRupiah(itemTotal),
                                    style: AppTypography.bodySRegular.copyWith(
                                      color: AppColors.neutral900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 3: Summary Totals
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          _buildTotalRow('Subtotal', _formatRupiah(subtotal)),
                          if (discountAmount > 0) ...[
                            const SizedBox(height: 8),
                            _buildTotalRow('Discount', '- ' + _formatRupiah(discountAmount), isDiscount: true),
                          ],
                          const SizedBox(height: 8),
                          _buildTotalRow('Tax (3%)', _formatRupiah(tax)),
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.neutral300, thickness: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: AppTypography.bodyLBold.copyWith(color: AppColors.neutral900),
                              ),
                              Text(
                                _formatRupiah(total),
                                style: AppTypography.h4Bold.copyWith(color: AppColors.primary600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

            // 3. FOOTER
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.neutral300, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        foregroundColor: AppColors.neutral800,
                        backgroundColor: AppColors.white,
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTypography.bodyMRegular.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Proceed to Payment',
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.neutral500),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500),
        ),
        Text(
          value,
          style: AppTypography.bodySRegular.copyWith(
            color: isDiscount ? AppColors.error500 : AppColors.neutral900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
