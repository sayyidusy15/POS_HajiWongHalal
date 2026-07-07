import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../screens/pos_dashboard_screen.dart';

class ProductDetailModal extends StatefulWidget {
  final Product product;

  const ProductDetailModal({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  int _quantity = 1;
  String _selectedSize = 'Regular';
  final List<String> _selectedAddons = [];
  final TextEditingController _notesController = TextEditingController();

  // Harga Tambahan
  final double _largePriceAdd = 10000;
  final Map<String, double> _addonsPrice = {
    'Extra onions': 5000,
    'Extra Cheese': 8000,
    'Extra Fried Egg': 6000,
  };

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

  double get _currentSinglePrice {
    double base = widget.product.price;
    if (_selectedSize == 'Large') {
      base += _largePriceAdd;
    }
    for (var addon in _selectedAddons) {
      base += _addonsPrice[addon] ?? 0;
    }
    return base;
  }

  double get _totalPrice {
    return _currentSinglePrice * _quantity;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 580),
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
        // Membungkus seluruh dialog ke dalam SingleChildScrollView agar scrollable saat keyboard muncul
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. HEADER PRODUK (bg-gray-50)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder Gambar Produk
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.product.icon,
                        color: AppColors.neutral600,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Detail Teks Kanan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: AppTypography.bodyLBold.copyWith(
                              color: AppColors.neutral900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Features with premium ingredients, fresh sauce, and delicious toppings customized just for you.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyXsRegular.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatRupiah(widget.product.price),
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
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

              // 2. BODY CONTENT
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Qty Stepper
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Qty',
                          style: AppTypography.bodyMRegular.copyWith(
                            color: AppColors.neutral800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.neutral200),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  '$_quantity',
                                  style: AppTypography.bodyMRegular.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neutral900,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Size Radio Options
                    Text(
                      'Size',
                      style: AppTypography.bodyMRegular.copyWith(
                        color: AppColors.neutral800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSizeCard('Regular', '+ Rp 0'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSizeCard('Large', '+ ${_formatRupiah(_largePriceAdd)}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Add-ons Checkbox Options
                    Text(
                      'Add-ons',
                      style: AppTypography.bodyMRegular.copyWith(
                        color: AppColors.neutral800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAddonRow('Extra onions', '+ ${_formatRupiah(_addonsPrice['Extra onions']!)}'),
                    const SizedBox(height: 8),
                    _buildAddonRow('Extra Cheese', '+ ${_formatRupiah(_addonsPrice['Extra Cheese']!)}'),
                    const SizedBox(height: 8),
                    _buildAddonRow('Extra Fried Egg', '+ ${_formatRupiah(_addonsPrice['Extra Fried Egg']!)}'),
                    const SizedBox(height: 20),

                    // Notes Input Textarea
                    Text(
                      'Notes',
                      style: AppTypography.bodyMRegular.copyWith(
                        color: AppColors.neutral800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Make the cheese more melted...',
                        hintStyle: AppTypography.bodySRegular.copyWith(color: AppColors.neutral400),
                        fillColor: AppColors.neutral100,
                        filled: true,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.neutral200, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.neutral200, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

              // 3. FOOTER / AKSI
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral500),
                        ),
                        Text(
                          _formatRupiah(_totalPrice),
                          style: AppTypography.bodyLBold.copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.neutral300, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              foregroundColor: AppColors.neutral800,
                            ),
                            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final customProduct = Product(
                                name: '${widget.product.name} (${_selectedSize}${_selectedAddons.isNotEmpty ? ' + Addons' : ''})',
                                price: _currentSinglePrice,
                                category: widget.product.category,
                                icon: widget.product.icon,
                              );
                              Navigator.pop(context, {
                                'product': customProduct,
                                'quantity': _quantity,
                                'notes': _notesController.text,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
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
      ),
    );
  }

  Widget _buildSizeCard(String size, String label) {
    final bool isSelected = _selectedSize == size;
    final Color strokeColor = isSelected ? AppColors.primary500 : AppColors.neutral200;
    final Color bgColor = isSelected ? AppColors.primary500.withValues(alpha: 0.1) : AppColors.white;
    final Color contentColor = isSelected ? AppColors.primary500 : AppColors.neutral800;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: strokeColor, width: isSelected ? 1.8 : 1.2),
        ),
        child: Center(
          child: Text(
            '$size ($label)',
            style: AppTypography.bodySRegular.copyWith(
              color: contentColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddonRow(String addon, String priceLabel) {
    final bool isSelected = _selectedAddons.contains(addon);
    final Color strokeColor = isSelected ? AppColors.primary500 : AppColors.neutral200;
    final Color bgColor = isSelected ? AppColors.primary500.withValues(alpha: 0.1) : AppColors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAddons.remove(addon);
          } else {
            _selectedAddons.add(addon);
          }
        });
      },
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: strokeColor, width: isSelected ? 1.8 : 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                  color: isSelected ? AppColors.primary500 : AppColors.neutral500,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  addon,
                  style: AppTypography.bodySRegular.copyWith(
                    color: AppColors.neutral800,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            Text(
              priceLabel,
              style: AppTypography.bodySRegular.copyWith(
                color: isSelected ? AppColors.primary500 : AppColors.neutral600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
