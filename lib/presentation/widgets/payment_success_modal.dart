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
    _orderId =
        'PZ' +
        DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13);
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

  void _showOrderDetailsModal(BuildContext context) {
    final now = DateTime.now();
    final String nowStr = '${now.day} ${_getMonthName(now.month)} ${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0FDF4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.receipt_long, color: Color(0xFF15803D), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _orderId,
                            style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, color: AppColors.neutral500),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transaction Info Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer: ${widget.customerName.isEmpty ? "Guest" : widget.customerName}',
                          style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral900),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.tableName ?? (widget.isDineIn ? "Dine In" : "Take Away")} • $nowStr',
                          style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Text(
                        'Completed',
                        style: AppTypography.bodyXsRegular.copyWith(
                          color: const Color(0xFF15803D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Ordered Items List
              Text(
                'Items Ordered (${widget.cartItems.length})',
                style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.cartItems.length,
                  separatorBuilder: (c, i) => const Divider(height: 12, thickness: 0.5, color: AppColors.neutral200),
                  itemBuilder: (c, i) {
                    final item = widget.cartItems[i];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary500.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${item.quantity}x',
                            style: AppTypography.bodyXsRegular.copyWith(color: AppColors.primary500, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800, fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.addons != null && item.addons!.isNotEmpty && !item.product.name.contains('+'))
                                Text(
                                  'Addons: ${item.addons!.join(', ')}',
                                  style: AppTypography.bodyXsRegular.copyWith(color: AppColors.primary500),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (item.notes != null && item.notes!.isNotEmpty)
                                Text(
                                  'Note: ${item.notes}',
                                  style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500, fontStyle: FontStyle.italic),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatRupiah(item.product.price * item.quantity),
                          style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900, fontWeight: FontWeight.w600),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: AppColors.neutral200),
              const SizedBox(height: 12),

              // Payment Summary
              _buildSummaryRow('Subtotal', _formatRupiah(widget.subtotal)),
              if (widget.discountAmount > 0) ...[
                const SizedBox(height: 4),
                _buildSummaryRow('Discount', '- ${_formatRupiah(widget.discountAmount)}'),
              ],
              const SizedBox(height: 4),
              _buildSummaryRow('Tax (3%)', _formatRupiah(widget.tax)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral900),
                  ),
                  Text(
                    _formatRupiah(widget.total),
                    style: AppTypography.h4Bold.copyWith(color: AppColors.primary500),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _buildSummaryRow('Payment Method', widget.method),
              if (widget.method == 'Cash') ...[
                const SizedBox(height: 4),
                _buildSummaryRow('Total Paid', _formatRupiah(widget.paid)),
                const SizedBox(height: 4),
                _buildSummaryRow('Change', _formatRupiah(widget.change)),
              ],
              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        showDialog(
                          context: context,
                          builder: (c) => ReceiptPreviewModal(
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
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        backgroundColor: AppColors.primary500,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.print_outlined, color: Colors.white, size: 18),
                      label: const Text('Print Receipt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500)),
        Text(value, style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800, fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Dialog(
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
              ),
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
                child: const Icon(Icons.check, color: AppColors.white, size: 40),
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
                    Container(width: 1, height: 40, color: AppColors.neutral300),
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
                              color: const Color(0xFF16A34A),
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
                      onPressed: () => _showOrderDetailsModal(context),
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('View Order'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: AppColors.neutral300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                              backgroundColor: Color(0xFF16A34A),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.print_outlined, size: 18),
                      label: const Text('Print Receipt'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: AppColors.neutral300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor: AppColors.neutral800,
                        backgroundColor: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // New Order Button (Solid Primary, Full Width)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
      ),
    );
  }
}
