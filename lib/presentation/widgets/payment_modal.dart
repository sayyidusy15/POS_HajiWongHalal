import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class PaymentModal extends StatefulWidget {
  final double totalAmount;
  final double subtotal;
  final double tax;
  final bool isDineIn;

  final String customerName;

  const PaymentModal({
    super.key,
    required this.totalAmount,
    required this.subtotal,
    required this.tax,
    required this.isDineIn,
    required this.customerName,
  });

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  String _inputAmount = '0';
  String _selectedMethod = 'Cash';

  // Format angka ke format Rupiah (contoh: Rp 45.000)
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

  void _onKeyPress(String value) {
    setState(() {
      if (_inputAmount == '0') {
        if (value != '00' && value != '0') {
          _inputAmount = value;
        }
      } else {
        _inputAmount += value;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_inputAmount.length > 1) {
        _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
      } else {
        _inputAmount = '0';
      }
    });
  }

  void _onShortcutPress(double value) {
    setState(() {
      _inputAmount = value.toInt().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double paidAmount = double.tryParse(_inputAmount) ?? 0.0;
    final double balance = paidAmount - widget.totalAmount;
    final bool isUnderpaid = balance < 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Center(
        child: Container(
          width: 820,
          height: 600,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            children: [
              // 1. HEADER MODAL
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40), // Spasi balancing
                    Text(
                      'Payment',
                      style: AppTypography.bodyLBold.copyWith(
                        color: AppColors.neutral900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.neutral500),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

              // 2. BODY MODAL (GRID 2 KOLOM)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // KOLOM KIRI: Input & Numpad
                    Expanded(
                      flex: 11,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // Input Field Display
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.neutral100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.neutral200, width: 1.5),
                              ),
                              alignment: Alignment.centerRight,
                              child: Text(
                                _formatRupiah(paidAmount),
                                style: AppTypography.h3Bold.copyWith(color: AppColors.neutral900),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Numpad Grid Layout (3x4 Kiri + 1x4 Kanan)
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Numpad Angka Kiri (3x4)
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        _buildNumpadRow(['1', '2', '3']),
                                        const SizedBox(height: 8),
                                        _buildNumpadRow(['4', '5', '6']),
                                        const SizedBox(height: 8),
                                        _buildNumpadRow(['7', '8', '9']),
                                        const SizedBox(height: 8),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              _buildNumpadButton('00'),
                                              const SizedBox(width: 8),
                                              _buildNumpadButton('0'),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: AppColors.neutral200, width: 1.5),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: _onBackspace,
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: const Center(
                                                        child: Icon(Icons.backspace_outlined, color: AppColors.neutral800, size: 20),
                                                      ),
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
                                  const SizedBox(width: 8),

                                  // Shortcut Nominal Kanan (1x4)
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        _buildShortcutButton('100k', 100000),
                                        const SizedBox(height: 8),
                                        _buildShortcutButton('50k', 50000),
                                        const SizedBox(height: 8),
                                        _buildShortcutButton('20k', 20000),
                                        const SizedBox(height: 8),
                                        _buildShortcutButton('10k', 10000),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Divider Vertikal Pemisah Kolom
                    const VerticalDivider(width: 1, thickness: 1, color: AppColors.neutral200),

                    // KOLOM KANAN: Rincian & Aksi Pembayaran
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Bagian 1: Order Information
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 18, color: AppColors.neutral500),
                                const SizedBox(width: 8),
                                Text(
                                  'Customer: ${widget.customerName}',
                                  style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  widget.isDineIn ? Icons.table_restaurant_outlined : Icons.delivery_dining_outlined,
                                  size: 18,
                                  color: AppColors.neutral500,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.isDineIn ? 'Dine In - Table 12' : 'Take Away',
                                  style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1, thickness: 1, color: AppColors.neutral200),
                            const SizedBox(height: 12),

                            // Bagian 2: Financial Breakdown
                            _buildReceiptRow('Subtotal', _formatRupiah(widget.subtotal)),
                            const SizedBox(height: 6),
                            _buildReceiptRow('Tax (3%)', _formatRupiah(widget.tax)),
                            const SizedBox(height: 6),
                            _buildReceiptRow('Discount', _formatRupiah(0)),
                            const SizedBox(height: 12),
                            const Divider(height: 1, thickness: 1, color: AppColors.neutral200),
                            const SizedBox(height: 12),

                             // Bagian 3: Payment Methods (Hanya Cash & QRIS)
                            Text(
                              'Payment Methods',
                              style: AppTypography.bodyXsRegular.copyWith(
                                color: AppColors.neutral500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(child: _buildMethodCard('Cash', Icons.payments_outlined)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildMethodCard('QRIS', Icons.qr_code_2_outlined)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, thickness: 1, color: AppColors.neutral200),
                            const SizedBox(height: 16),

                            // Bagian 4: Totals, Paid & Change (Kembalian Uang)
                            _buildReceiptRow('Total', _formatRupiah(widget.totalAmount)),
                            const SizedBox(height: 6),
                            _buildReceiptRow('Paid', _formatRupiah(paidAmount)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isUnderpaid ? 'Underpaid' : 'Change',
                                  style: AppTypography.bodyMRegular.copyWith(
                                    color: AppColors.neutral700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isUnderpaid ? '- ${_formatRupiah(balance.abs())}' : _formatRupiah(balance),
                                  style: AppTypography.bodyLBold.copyWith(
                                    color: isUnderpaid ? AppColors.error500 : AppColors.primary500,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            // Bagian 5: Call to Action (Confirm Payment)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true); // Tutup modal dengan sukses
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF289656), // Warna hijau sukses
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Confirm Payment',
                                style: AppTypography.bodyMRegular.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildNumpadRow(List<String> keys) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: keys.map((key) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildNumpadButton(key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNumpadButton(String label) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.neutral200, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyPress(label),
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: Text(
                label,
                style: AppTypography.bodyLBold.copyWith(
                  color: AppColors.neutral800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutButton(String label, double value) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.neutral100, // Warna abu-abu muda sesuai spesifikasi
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.neutral200, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onShortcutPress(value),
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: Text(
                label,
                style: AppTypography.bodySRegular.copyWith(
                  color: AppColors.neutral800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard(String method, IconData icon) {
    final bool isSelected = _selectedMethod == method;
    final Color strokeColor = isSelected ? AppColors.primary500 : AppColors.neutral200;
    final Color bgColor = isSelected ? AppColors.primary500.withValues(alpha: 0.1) : AppColors.white;
    final Color contentColor = isSelected ? AppColors.primary500 : AppColors.neutral800;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: strokeColor, width: isSelected ? 1.8 : 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: contentColor, size: 20),
            const SizedBox(height: 4),
            Text(
              method,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyXsRegular.copyWith(
                color: contentColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
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
            color: AppColors.neutral900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
