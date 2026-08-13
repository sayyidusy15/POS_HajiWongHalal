import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../screens/pos_dashboard_screen.dart';

class ReceiptPreviewModal extends StatelessWidget {
  final String orderId;
  final String customerName;
  final List<OrderItem> cartItems;
  final double subtotal;
  final double discountAmount;
  final double tax;
  final double total;
  final String paymentMethod;
  final double paidAmount;
  final double changeAmount;

  const ReceiptPreviewModal({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.cartItems,
    required this.subtotal,
    required this.discountAmount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.paidAmount,
    required this.changeAmount,
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
    final String formattedDate = _getFormattedDateTime();

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
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Receipt Preview
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
                'Receipt Preview',
                style: AppTypography.bodyLBold.copyWith(
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Scrollable Receipt Sheet Container
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Container(
                    width: 340,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.neutral300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Restaurant Logo Box (Bakso Tjab Haji Logo)
                        Image.asset(
                          'assets/images/logo-app.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),

                        // Restaurant Header
                        Text(
                          'Bakso Tjab Haji',
                          style: AppTypography.bodyLBold.copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '4402 Sunset Blvd, Los Angeles, California, 90001, United States',
                          style: AppTypography.bodyXsRegular.copyWith(
                            color: AppColors.neutral500,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),

                        Text(
                          formattedDate,
                          style: AppTypography.bodyXsRegular.copyWith(
                            color: AppColors.neutral500,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _DottedLine(),
                        const SizedBox(height: 16),

                        // Transaction details
                        _buildReceiptDetailRow('Transaction ID', orderId),
                        _buildReceiptDetailRow('Salesperson', 'Brian Susanto'),
                        _buildReceiptDetailRow('Customer', customerName),
                        const SizedBox(height: 16),
                        const _DottedLine(),
                        const SizedBox(height: 16),

                        // Cart Items List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            final double itemTotal =
                                item.product.price * item.quantity;
                            final String baseName = item.product.name
                                .split(' (')
                                .first;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item.quantity}  ',
                                        style: AppTypography.bodySRegular
                                            .copyWith(
                                              color: AppColors.neutral800,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          baseName,
                                          style: AppTypography.bodySRegular
                                              .copyWith(
                                                color: AppColors.neutral800,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        _formatRupiah(itemTotal),
                                        style: AppTypography.bodySRegular
                                            .copyWith(
                                              color: AppColors.neutral900,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  // Sub-details (Size, Add-ons)
                                  if (item.size != null ||
                                      (item.addons != null &&
                                          item.addons!.isNotEmpty))
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 18.0,
                                        top: 2.0,
                                      ),
                                      child: Text(
                                        '${item.size ?? "Regular"}${item.addons != null && item.addons!.isNotEmpty ? " + " + item.addons!.join(", ") : ""}',
                                        style: AppTypography.bodyXsRegular
                                            .copyWith(
                                              color: AppColors.neutral500,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ),
                                  // Notes
                                  if (item.notes != null &&
                                      item.notes!.trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 18.0,
                                        top: 2.0,
                                      ),
                                      child: Text(
                                        'Note: "${item.notes}"',
                                        style: AppTypography.bodyXsRegular
                                            .copyWith(
                                              color: AppColors.neutral500,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const _DottedLine(),
                        const SizedBox(height: 16),

                        // Pricing summary
                        _buildSummaryRow('Sub Total', _formatRupiah(subtotal)),
                        if (discountAmount > 0)
                          _buildSummaryRow(
                            'Discount',
                            '- ' + _formatRupiah(discountAmount),
                          ),
                        _buildSummaryRow('Tax', _formatRupiah(tax)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: AppTypography.bodyMRegular.copyWith(
                                color: AppColors.neutral900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatRupiah(total),
                              style: AppTypography.bodyLBold.copyWith(
                                color: AppColors.neutral900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const _DottedLine(),
                        const SizedBox(height: 12),

                        // Payment Methods and Balance details
                        _buildSummaryRow('Payment Method', paymentMethod),
                        if (paymentMethod == 'Cash') ...[
                          _buildSummaryRow('Cash', _formatRupiah(paidAmount)),
                          _buildSummaryRow(
                            'Change',
                            _formatRupiah(changeAmount),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

            // Footer buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
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
                      child: Text(
                        'Cancel',
                        style: AppTypography.bodyMRegular.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showSelectPrinterModal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Print',
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
    ),
    );
  }

  Widget _buildReceiptDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyXsRegular.copyWith(
              color: AppColors.neutral500,
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyXsRegular.copyWith(
              color: AppColors.neutral800,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySRegular.copyWith(
              color: AppColors.neutral500,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodySRegular.copyWith(
              color: AppColors.neutral800,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDateTime() {
    final now = DateTime.now();
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final String dayName = days[now.weekday - 1];

    final String dayStr = now.day.toString().padLeft(2, '0');
    final String monthStr = now.month.toString().padLeft(2, '0');
    final String yearStr = now.year.toString();

    int hour = now.hour;
    final String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    final String hourStr = hour.toString().padLeft(2, '0');
    final String minuteStr = now.minute.toString().padLeft(2, '0');

    return '$dayName  $dayStr/$monthStr/$yearStr  •  $hourStr:$minuteStr $period';
  }

  void _showSelectPrinterModal(BuildContext context) {
    String selectedPrinterId = 'p1'; // Default to Front Printer

    final List<Map<String, dynamic>> printers = [
      {
        'id': 'p1',
        'name': 'Front Printer',
        'model': 'Epson TMT-82X',
        'connectionType': 'Wireless (Wi-Fi)',
        'target': 'Receipt / Kasir',
        'ipOrMac': '192.168.1.101',
        'paperWidth': '80mm',
        'status': 'Connected',
      },
      {
        'id': 'p2',
        'name': 'Kitchen Printer',
        'model': 'Epson TM-m30II-NT',
        'connectionType': 'Wired (USB)',
        'target': 'Kitchen / Dapur',
        'ipOrMac': 'USB Port 1',
        'paperWidth': '80mm',
        'status': 'Connected',
      },
      {
        'id': 'p3',
        'name': 'Office & Report',
        'model': 'PIXMA E3470',
        'connectionType': 'Bluetooth',
        'target': 'Report',
        'ipOrMac': 'BT: 00:1B:44:11:3A:B7',
        'paperWidth': 'A4 / Standard',
        'status': 'Offline',
      },
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 480,
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
                              color: AppColors.primary50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.print_outlined, color: AppColors.primary500, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Connected Printer',
                                style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Choose printer device to output receipt',
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
                  const Divider(height: 1, color: AppColors.neutral200),
                  const SizedBox(height: 16),

                  // Printers List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: printers.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 10),
                    itemBuilder: (c, i) {
                      final printer = printers[i];
                      final bool isSelected = selectedPrinterId == printer['id'];
                      final bool isConnected = printer['status'] == 'Connected';

                      return InkWell(
                        onTap: isConnected
                            ? () {
                                setModalState(() {
                                  selectedPrinterId = printer['id'];
                                });
                              }
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary50 : (isConnected ? AppColors.white : AppColors.neutral100),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary500 : (isConnected ? AppColors.neutral300 : AppColors.neutral200),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: printer['id'],
                                groupValue: selectedPrinterId,
                                activeColor: AppColors.primary500,
                                onChanged: isConnected
                                    ? (val) {
                                        if (val != null) {
                                          setModalState(() {
                                            selectedPrinterId = val;
                                          });
                                        }
                                      }
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          printer['name'],
                                          style: AppTypography.bodySRegular.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isConnected ? AppColors.neutral900 : AppColors.neutral400,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isConnected ? const Color(0xFFF0FDF4) : AppColors.neutral200,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isConnected ? const Color(0xFF16A34A) : AppColors.neutral500,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                printer['status'],
                                                style: AppTypography.bodyXsRegular.copyWith(
                                                  color: isConnected ? const Color(0xFF15803D) : AppColors.neutral600,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${printer['model']} • ${printer['connectionType']} (${printer['ipOrMac']})',
                                      style: AppTypography.bodyXsRegular.copyWith(
                                        color: isConnected ? AppColors.neutral600 : AppColors.neutral400,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Target: ${printer['target']} • Width: ${printer['paperWidth']}',
                                      style: AppTypography.bodyXsRegular.copyWith(
                                        color: isConnected ? AppColors.primary600 : AppColors.neutral400,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          final selected = printers.firstWhere((p) => p['id'] == selectedPrinterId);
                          Navigator.pop(ctx); // Close printer modal
                          Navigator.pop(context, true); // Close preview modal with success

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Printing receipt via ${selected['name']} (${selected['model']})...'),
                              backgroundColor: const Color(0xFF16A34A),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          backgroundColor: AppColors.primary500,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.print, color: Colors.white, size: 18),
                        label: const Text(
                          'Print Now',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom widget to paint a dotted line on thermal receipts
class _DottedLine extends StatelessWidget {
  const _DottedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        const dashSpace = 3.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.neutral300),
              ),
            );
          }),
        );
      },
    );
  }
}
