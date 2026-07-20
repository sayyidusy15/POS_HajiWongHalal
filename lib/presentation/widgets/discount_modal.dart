import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class DiscountResult {
  final String name;
  final String value;
  final String type; // 'code', 'preset', 'percentage', 'price'
  final double discountAmount; // computed discount amount or raw value depending on type

  const DiscountResult({
    required this.name,
    required this.value,
    required this.type,
    required this.discountAmount,
  });
}

class DiscountModal extends StatefulWidget {
  final double subtotal;
  const DiscountModal({super.key, required this.subtotal});

  @override
  State<DiscountModal> createState() => _DiscountModalState();
}

class _DiscountModalState extends State<DiscountModal> {
  String _activeTab = 'New'; // 'New', 'Preset', 'By Percentage', 'By Price'
  
  // Tab controllers & states
  final TextEditingController _codeController = TextEditingController(text: 'R4D082024');
  final TextEditingController _percentageController = TextEditingController(text: '15');
  final TextEditingController _priceController = TextEditingController(text: '5.00');
  
  int _selectedPresetIndex = 1; // Default selected preset is Row 2 (index 1)

  final List<Map<String, dynamic>> _presets = const [
    {'name': '2025 New Year Discount', 'value': '-25%', 'percentage': 25.0},
    {'name': '20% 3 Days Streak Discount', 'value': '-20%', 'percentage': 20.0},
    {'name': '\$5 Monday Off', 'value': '- 5.00', 'price': 5.00},
  ];

  @override
  void dispose() {
    _codeController.dispose();
    _percentageController.dispose();
    _priceController.dispose();
    super.dispose();
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
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
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
                  'Discount',
                  style: AppTypography.bodyLBold.copyWith(
                    color: AppColors.neutral900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. TAB NAVIGATION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildTabPill('New')),
                      Expanded(child: _buildTabPill('Preset')),
                      Expanded(child: _buildTabPill('By Percentage')),
                      Expanded(child: _buildTabPill('By Price')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. CONTENT AREA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 120),
                  child: _buildTabContent(),
                ),
              ),
              const SizedBox(height: 20),

              const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

              // 4. FOOTER / BUTTONS
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
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
                        onPressed: _handleApply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: Text(
                          _getFooterButtonText(),
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

  Widget _buildTabPill(String tabName) {
    final bool isActive = _activeTab == tabName;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = tabName;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: Text(
                tabName,
                style: AppTypography.bodyXsBold.copyWith(
                  fontSize: 11,
                  color: isActive ? AppColors.primary600 : AppColors.neutral500,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (isActive)
              Positioned(
                bottom: 2,
                child: Container(
                  height: 3,
                  width: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary500,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'New':
        return _buildNewTabContent();
      case 'Preset':
        return _buildPresetTabContent();
      case 'By Percentage':
        return _buildPercentageTabContent();
      case 'By Price':
        return _buildPriceTabContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNewTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Discount Code',
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral600,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _codeController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.neutral300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral800),
        ),
      ],
    );
  }

  Widget _buildPresetTabContent() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral200),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_presets.length, (index) {
          final preset = _presets[index];
          final bool isSelected = _selectedPresetIndex == index;

          return Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primary50.withValues(alpha: 0.7) 
                  : Colors.transparent,
              border: index < _presets.length - 1
                  ? const Border(bottom: BorderSide(color: AppColors.neutral100, width: 1))
                  : null,
            ),
            child: ListTile(
              onTap: () {
                setState(() {
                  _selectedPresetIndex = index;
                });
              },
              title: Text(
                preset['name'],
                style: AppTypography.bodySRegular.copyWith(
                  color: AppColors.neutral800,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Text(
                preset['value'],
                style: AppTypography.bodyMBold.copyWith(
                  color: AppColors.error500, // pink/orange warna diskon
                  fontWeight: FontWeight.bold,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPercentageTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Percentage',
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral600,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _percentageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '%',
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.neutral300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral800),
        ),
      ],
    );
  }

  Widget _buildPriceTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Discount Amount',
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral600,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$',
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.neutral300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral800),
        ),
      ],
    );
  }

  String _getFooterButtonText() {
    if (_activeTab == 'New' || _activeTab == 'Preset') {
      return 'Apply';
    } else {
      return 'Add';
    }
  }

  void _handleApply() {
    if (_activeTab == 'New') {
      final code = _codeController.text.trim();
      if (code.isNotEmpty) {
        // Anggap kode ini memberikan diskon 10%
        Navigator.pop(
          context,
          DiscountResult(
            name: 'Discount Code',
            value: code,
            type: 'code',
            discountAmount: widget.subtotal * 0.10, // 10% off
          ),
        );
      }
    } else if (_activeTab == 'Preset') {
      final preset = _presets[_selectedPresetIndex];
      double amount = 0;
      if (preset.containsKey('percentage')) {
        amount = widget.subtotal * (preset['percentage'] / 100);
      } else if (preset.containsKey('price')) {
        amount = preset['price'];
      }
      Navigator.pop(
        context,
        DiscountResult(
          name: preset['name'],
          value: preset['value'],
          type: 'preset',
          discountAmount: amount,
        ),
      );
    } else if (_activeTab == 'By Percentage') {
      final valStr = _percentageController.text.trim();
      final percentage = double.tryParse(valStr) ?? 0.0;
      if (percentage > 0) {
        Navigator.pop(
          context,
          DiscountResult(
            name: 'Percentage Discount',
            value: '${percentage.toStringAsFixed(0)}%',
            type: 'percentage',
            discountAmount: widget.subtotal * (percentage / 100),
          ),
        );
      }
    } else if (_activeTab == 'By Price') {
      final valStr = _priceController.text.trim();
      final price = double.tryParse(valStr) ?? 0.0;
      if (price > 0) {
        Navigator.pop(
          context,
          DiscountResult(
            name: 'Price Discount',
            value: '\$ ${price.toStringAsFixed(2)}',
            type: 'price',
            discountAmount: price,
          ),
        );
      }
    }
  }
}
