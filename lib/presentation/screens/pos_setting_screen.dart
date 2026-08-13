import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/pos_navigation_drawer.dart';
import '../widgets/custom_success_toast.dart';

class PosSettingScreen extends StatefulWidget {
  const PosSettingScreen({super.key});

  @override
  State<PosSettingScreen> createState() => _PosSettingScreenState();
}

class _PosSettingScreenState extends State<PosSettingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeTab = 'Store Setting';

  // State Toast Notification
  bool _showToast = false;
  String _toastTitle = '';
  String _toastSubtitle = '';
  bool _toastIsSuccess = true;

  // Controllers Form
  final TextEditingController _storeNameController =
      TextEditingController(text: 'Bakso Tjab Haji');
  final TextEditingController _phoneController =
      TextEditingController(text: '+62 812 3456 7890');
  final TextEditingController _whatsappController =
      TextEditingController(text: '+62 812 3456 7890');
  final TextEditingController _cityController =
      TextEditingController(text: 'Jakarta Selatan');
  final TextEditingController _countryController =
      TextEditingController(text: 'Indonesia');
  final TextEditingController _regencyController =
      TextEditingController(text: 'DKI Jakarta');
  final TextEditingController _postCodeController =
      TextEditingController(text: '12190');
  final TextEditingController _addressController = TextEditingController(
      text: 'Jl. Senopati No. 45, Kebayoran Baru, Jakarta Selatan');

  // State Payment Methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cash',
      'name': 'Cash',
      'category': 'Cash',
      'iconType': 'cash',
      'enabled': true,
    },
    {
      'id': 'qris',
      'name': 'QRIS',
      'category': 'QRIS',
      'iconType': 'qris',
      'enabled': true,
    },
    {
      'id': 'bca',
      'name': 'Bank BCA',
      'category': 'Bank Transfer',
      'iconType': 'bca',
      'enabled': true,
    },
    {
      'id': 'mandiri',
      'name': 'Bank Mandiri',
      'category': 'Bank Transfer',
      'iconType': 'mandiri',
      'enabled': true,
    },
    {
      'id': 'bni',
      'name': 'Bank BNI',
      'category': 'Bank Transfer',
      'iconType': 'bni',
      'enabled': true,
    },
    {
      'id': 'mastercard',
      'name': 'Mastercard',
      'category': 'Credit Card',
      'iconType': 'mastercard',
      'enabled': true,
    },
    {
      'id': 'visa',
      'name': 'VISA',
      'category': 'Credit Card',
      'iconType': 'visa',
      'enabled': false,
    },
  ];

  // State Printers
  final List<Map<String, dynamic>> _printersList = [
    {
      'id': 'p1',
      'name': 'Front Printer',
      'model': 'Epson TMT-82X',
      'connectionType': 'Wireless',
      'ipOrMac': '192.168.1.101',
      'paperWidth': '80mm',
      'target': 'Receipt / Kasir',
      'status': 'Connected',
    },
    {
      'id': 'p2',
      'name': 'Kitchen Printer',
      'model': 'Epson TM-m30II-NT',
      'connectionType': 'Wired',
      'ipOrMac': 'USB Port 1',
      'paperWidth': '80mm',
      'target': 'Kitchen / Dapur',
      'status': 'Connected',
    },
    {
      'id': 'p3',
      'name': 'Office & Report',
      'model': 'PIXMA E3470',
      'connectionType': 'Bluetooth',
      'ipOrMac': 'BT: 00:1B:44:11:3A:B7',
      'paperWidth': 'A4 / Standard',
      'target': 'Report',
      'status': 'Offline',
    },
  ];

  // State Discount & Voucher
  String _discountSubTab = 'Discount';
  late List<Map<String, dynamic>> _discountsList;
  late List<Map<String, dynamic>> _vouchersList;

  @override
  void initState() {
    super.initState();
    _discountsList = [
      {
        'id': '1',
        'enabled': true,
        'nameCtrl': TextEditingController(text: '2026 New Year Discount'),
        'amountCtrl': TextEditingController(text: '25'),
        'type': 'By Percentage',
      },
      {
        'id': '2',
        'enabled': true,
        'nameCtrl': TextEditingController(text: '20% 3 Days Streak Discount'),
        'amountCtrl': TextEditingController(text: '20'),
        'type': 'By Percentage',
      },
      {
        'id': '3',
        'enabled': false,
        'nameCtrl': TextEditingController(text: 'Rp 5.000 Monday Off'),
        'amountCtrl': TextEditingController(text: '5000'),
        'type': 'By Price',
      },
      {
        'id': '4',
        'enabled': false,
        'nameCtrl': TextEditingController(text: ''),
        'amountCtrl': TextEditingController(text: ''),
        'type': 'Choose type',
      },
    ];

    _vouchersList = [
      {
        'id': 'v1',
        'enabled': true,
        'nameCtrl': TextEditingController(text: 'Voucher HAJIWONG50K'),
        'amountCtrl': TextEditingController(text: '50000'),
        'type': 'By Price',
      },
      {
        'id': 'v2',
        'enabled': true,
        'nameCtrl': TextEditingController(text: 'Voucher Member 10%'),
        'amountCtrl': TextEditingController(text: '10'),
        'type': 'By Percentage',
      },
    ];
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _regencyController.dispose();
    _postCodeController.dispose();
    _addressController.dispose();
    for (var d in _discountsList) {
      d['nameCtrl']?.dispose();
      d['amountCtrl']?.dispose();
    }
    for (var v in _vouchersList) {
      v['nameCtrl']?.dispose();
      v['amountCtrl']?.dispose();
    }
    super.dispose();
  }

  void _triggerToast(String title, String subtitle, {bool isSuccess = true}) {
    setState(() {
      _showToast = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _showToast = true;
          _toastTitle = title;
          _toastSubtitle = subtitle;
          _toastIsSuccess = isSuccess;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA), // Light gray background
      drawer: const PosNavigationDrawer(activeRoute: 'setting'),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Setting',
          style: AppTypography.h4Bold.copyWith(color: AppColors.neutral900),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kiri: Navigation Sidebar Menu (Flex 3)
                      SizedBox(
                        width: 260,
                        child: _buildSidebarMenu(),
                      ),
                      const SizedBox(width: 24),
                      // Kanan: Form Content Panel (Flex 9)
                      Expanded(
                        child: _buildMainFormPanel(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildSidebarMenu(),
                      const SizedBox(height: 24),
                      _buildMainFormPanel(),
                    ],
                  ),
          ),

          // FLOATING TOAST NOTIFICATION
          if (_showToast)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: CustomSuccessToast(
                  title: _toastTitle,
                  subtitle: _toastSubtitle,
                  isSuccess: _toastIsSuccess,
                  onDismiss: () {
                    if (mounted) {
                      setState(() {
                        _showToast = false;
                      });
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- 1. SIDEBAR MENU KIRI ---
  Widget _buildSidebarMenu() {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Store Setting', 'icon': Icons.storefront_outlined},
      {'title': 'Payment Method', 'icon': Icons.credit_card_outlined},
      {'title': 'Discount & Voucher', 'icon': Icons.confirmation_number_outlined},
      {'title': 'Printer', 'icon': Icons.print_outlined},
    ];

    return Column(
      children: menuItems.map((item) {
        final bool isActive = _activeTab == item['title'];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _activeTab = item['title'];
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    // Indicator border tebal hijau di sisi kiri untuk menu aktif
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 4,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary500 : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      item['icon'],
                      color: isActive ? AppColors.neutral900 : AppColors.neutral600,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item['title'],
                        style: AppTypography.bodyMRegular.copyWith(
                          color: isActive ? AppColors.neutral900 : AppColors.neutral600,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- 2. MAIN FORM PANEL KANAN ---
  Widget _buildMainFormPanel() {
    if (_activeTab == 'Payment Method') {
      return _buildPaymentMethodPanel();
    }
    if (_activeTab == 'Discount & Voucher') {
      return _buildDiscountVoucherPanel();
    }
    if (_activeTab == 'Printer') {
      return _buildPrinterPanel();
    }

    if (_activeTab != 'Store Setting') {
      return Container(
        height: 400,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.settings, size: 64, color: AppColors.neutral300),
              const SizedBox(height: 16),
              Text(
                '$_activeTab Configuration',
                style: AppTypography.h4Bold.copyWith(color: AppColors.neutral900),
              ),
              const SizedBox(height: 8),
              Text(
                'Settings for $_activeTab will appear here.',
                style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral500),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Panel (Store Setting Title & Save Button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Store Setting',
                style: AppTypography.h3Bold.copyWith(
                  color: AppColors.neutral900,
                  fontSize: 26,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _triggerToast(
                    'Changes Saved Successfully!',
                    'Your store settings have been updated.',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: AppTypography.bodyMBold.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // 1. Logo Dropzone
          _buildFormFieldLabel('Logo'),
          const SizedBox(height: 8),
          _buildLogoDropzone(),
          const SizedBox(height: 24),

          // 2. Store Name Field
          _buildFormFieldLabel('Store Name'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _storeNameController,
            placeholder: 'Input store name',
          ),
          const SizedBox(height: 20),

          // 3. Contact Information (2 Parallel Columns)
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 500;
              return isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormFieldLabel('Contact Information'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _phoneController,
                                placeholder: 'ex: +1(968) 283 8821',
                                prefixIcon: Icons.phone_outlined,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormFieldLabel('Contact Information'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _whatsappController,
                                placeholder: 'ex: +1(968) 283 8821',
                                prefixIcon: Icons.chat_outlined,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormFieldLabel('Contact Information'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _phoneController,
                              placeholder: 'ex: +1(968) 283 8821',
                              prefixIcon: Icons.phone_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormFieldLabel('Contact Information'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _whatsappController,
                              placeholder: 'ex: +1(968) 283 8821',
                              prefixIcon: Icons.chat_outlined,
                            ),
                          ],
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 20),

          // 4. City & Country (2 Parallel Columns)
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 500;
              return isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormFieldLabel('City'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _cityController,
                                placeholder: 'Input city',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormFieldLabel('Country'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _countryController,
                                placeholder: 'Input country',
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormFieldLabel('City'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _cityController,
                              placeholder: 'Input city',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormFieldLabel('Country'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _countryController,
                              placeholder: 'Input country',
                            ),
                          ],
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 20),

          // 5. Regency & Post Code (2 Parallel Columns)
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 500;
              return isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormFieldLabel('Regency'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _regencyController,
                                placeholder: 'Input regency',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormFieldLabel('Post Code'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _postCodeController,
                                placeholder: 'Input post code',
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormFieldLabel('Regency'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _regencyController,
                              placeholder: 'Input regency',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormFieldLabel('Post Code'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _postCodeController,
                              placeholder: 'Input post code',
                            ),
                          ],
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 20),

          // 6. Full Address (Textarea)
          _buildFormFieldLabel('Full Address'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _addressController,
            placeholder: 'Add full address',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // Helper Widget: Form Field Label
  Widget _buildFormFieldLabel(String text) {
    return Text(
      text,
      style: AppTypography.bodySMedium.copyWith(
        color: AppColors.neutral900,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Helper Widget: Logo Dropzone dengan Custom Dashed Border
  Widget _buildLogoDropzone() {
    return GestureDetector(
      onTap: () {
        _triggerToast('Image Picker', 'Selecting logo image file...');
      },
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AppColors.neutral300,
          strokeWidth: 1.5,
          gap: 6,
        ),
        child: Container(
          width: double.infinity,
          height: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.neutral50.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.file_upload_outlined,
                size: 28,
                color: AppColors.neutral500,
              ),
              const SizedBox(height: 6),
              Text(
                'Click to upload',
                style: AppTypography.bodyMBold.copyWith(
                  color: AppColors.neutral800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'JPG, PNG (Max 2 MB)',
                style: AppTypography.bodyXsRegular.copyWith(
                  color: AppColors.neutral400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: TextField Input Standard
  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTypography.bodyMRegular.copyWith(
        color: AppColors.neutral900,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: AppTypography.bodyMRegular.copyWith(
          color: AppColors.neutral400,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.neutral500, size: 20)
            : null,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.neutral300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
        ),
      ),
    );
  }

  // --- PAYMENT METHOD PANEL ---
  Widget _buildPaymentMethodPanel() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Panel (Title & Action Buttons)
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 600;
              return isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: AppTypography.h3Bold.copyWith(
                            color: AppColors.neutral900,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _showAddPaymentMethodModal,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Method'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.neutral800,
                                  side: const BorderSide(color: AppColors.neutral300),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _triggerToast(
                                    'Changes Saved Successfully!',
                                    'Your payment method settings have been updated.',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary500,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Save Changes',
                                  style: AppTypography.bodyMBold.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Method',
                          style: AppTypography.h3Bold.copyWith(
                            color: AppColors.neutral900,
                            fontSize: 26,
                          ),
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: _showAddPaymentMethodModal,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add Payment Method'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.neutral800,
                                side: const BorderSide(color: AppColors.neutral300),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                _triggerToast(
                                  'Changes Saved Successfully!',
                                  'Your payment method settings have been updated.',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary500,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Save Changes',
                                style: AppTypography.bodyMBold.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 24),

          // Payment Methods List Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paymentMethods.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              final bool isEnabled = method['enabled'] == true;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isEnabled ? AppColors.neutral200 : AppColors.neutral200.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Logo Box Container
                    _buildPaymentLogo(method['iconType'] ?? ''),
                    const SizedBox(width: 16),

                    // Name and Category Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method['name'],
                            style: AppTypography.bodyLBold.copyWith(
                              color: isEnabled ? AppColors.neutral900 : AppColors.neutral400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (method['category'] != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              method['category'],
                              style: AppTypography.bodySRegular.copyWith(
                                color: AppColors.neutral400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Toggle Switch (Active/Disable)
                    Switch.adaptive(
                      value: isEnabled,
                      activeThumbColor: AppColors.primary500,
                      onChanged: (val) {
                        setState(() {
                          _paymentMethods[index]['enabled'] = val;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentLogo(String iconType) {
    final type = iconType.toLowerCase();

    if (type == 'cash') {
      return Container(
        width: 54,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF86EFAC)),
        ),
        child: const Icon(Icons.payments_outlined, color: Color(0xFF16A34A), size: 22),
      );
    } else if (type == 'qris') {
      return Container(
        width: 54,
        height: 38,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo-pembayaran/qris.png',
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (type == 'bca') {
      return Container(
        width: 54,
        height: 38,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo-pembayaran/bca.png',
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (type == 'mandiri') {
      return Container(
        width: 54,
        height: 38,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFBAE6FD)),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo-pembayaran/mandiri.png',
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (type == 'bni') {
      return Container(
        width: 54,
        height: 38,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFFEDD5)),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo-pembayaran/bni.png',
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (type == 'mastercard') {
      return Container(
        width: 54,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle),
            ),
            Transform.translate(
              offset: const Offset(-5, 0),
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: const Color(0xFFF79E1B).withValues(alpha: 0.95), shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      );
    } else if (type == 'visa') {
      return Container(
        width: 54,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFC7D2FE)),
        ),
        child: const Center(
          child: Text(
            'VISA',
            style: TextStyle(
              color: Color(0xFF1E40AF),
              fontWeight: FontWeight.w900,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 54,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Center(
          child: Text(
            iconType.length > 4 ? iconType.substring(0, 4).toUpperCase() : iconType.toUpperCase(),
            style: const TextStyle(
              color: AppColors.neutral700,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      );
    }
  }

  void _showAddPaymentMethodModal() {
    final TextEditingController nameController = TextEditingController();
    String selectedCategory = 'E-Wallet';
    bool initialEnabled = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 480,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Payment Method',
                          style: AppTypography.h4Bold.copyWith(color: AppColors.neutral900),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.neutral500),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Method Name', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Bank BRI, GoPay, ShopeePay',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Category / Type', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      dropdownColor: AppColors.white,
                      style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900),
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.neutral600),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      items: [
                        DropdownMenuItem(value: 'Cash', child: Text('Cash', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900))),
                        DropdownMenuItem(value: 'QRIS', child: Text('QRIS', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900))),
                        DropdownMenuItem(value: 'E-Wallet', child: Text('E-Wallet', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900))),
                        DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900))),
                        DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900))),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedCategory = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Enable Method Immediately', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                        Switch.adaptive(
                          value: initialEnabled,
                          activeThumbColor: AppColors.primary500,
                          onChanged: (val) {
                            setModalState(() => initialEnabled = val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.neutral300),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            final name = nameController.text.trim();
                            if (name.isNotEmpty) {
                              String iconType = name.toLowerCase();
                              if (iconType.contains('bri')) {
                                iconType = 'bri';
                              } else if (iconType.contains('gopay')) {
                                iconType = 'gopay';
                              } else if (iconType.contains('shopee')) {
                                iconType = 'shopeepay';
                              } else if (iconType.contains('ovo')) {
                                iconType = 'ovo';
                              }

                              setState(() {
                                _paymentMethods.add({
                                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                  'name': name,
                                  'category': selectedCategory,
                                  'iconType': iconType,
                                  'enabled': initialEnabled,
                                });
                              });
                              Navigator.pop(ctx);
                              _triggerToast(
                                'Payment Method Added!',
                                '$name has been added to payment options.',
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Add Method'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- DISCOUNT & VOUCHER PANEL ---
  Widget _buildDiscountVoucherPanel() {
    final bool isDiscountTab = _discountSubTab == 'Discount';
    final currentList = isDiscountTab ? _discountsList : _vouchersList;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Row (Title & Add Button)
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 600;
              return isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discount & Voucher',
                          style: AppTypography.h3Bold.copyWith(
                            color: AppColors.neutral900,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    currentList.add({
                                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                      'enabled': true,
                                      'nameCtrl': TextEditingController(),
                                      'amountCtrl': TextEditingController(),
                                      'type': 'Choose type',
                                    });
                                  });
                                },
                                icon: const Icon(Icons.add, size: 18),
                                label: Text(isDiscountTab ? 'Add Discount' : 'Add Voucher'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary500,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _triggerToast(
                                    'Changes Saved Successfully!',
                                    'Your ${_discountSubTab.toLowerCase()} settings have been updated.',
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.neutral800,
                                  side: const BorderSide(color: AppColors.neutral300),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Save Changes',
                                  style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount & Voucher',
                          style: AppTypography.h3Bold.copyWith(
                            color: AppColors.neutral900,
                            fontSize: 26,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  currentList.add({
                                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                    'enabled': true,
                                    'nameCtrl': TextEditingController(),
                                    'amountCtrl': TextEditingController(),
                                    'type': 'Choose type',
                                  });
                                });
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: Text(isDiscountTab ? 'Add Discount' : 'Add Voucher'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary500,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () {
                                _triggerToast(
                                  'Changes Saved Successfully!',
                                  'Your ${_discountSubTab.toLowerCase()} settings have been updated.',
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.neutral800,
                                side: const BorderSide(color: AppColors.neutral300),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Save Changes',
                                style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 24),

          // 2. Sub-tab Switcher (Segmented Control: Discount | Voucher)
          Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSubTabItem('Discount'),
                ),
                Expanded(
                  child: _buildSubTabItem('Voucher'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Discount / Voucher List Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = currentList[index];
              final bool isEnabled = item['enabled'] == true;
              final TextEditingController nameCtrl = item['nameCtrl'];
              final TextEditingController amountCtrl = item['amountCtrl'];
              final String typeVal = item['type'] ?? 'Choose type';

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.neutral200,
                    width: 1.2,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isMobile = constraints.maxWidth < 650;
                    return isMobile
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Switch.adaptive(
                                    value: isEnabled,
                                    activeThumbColor: AppColors.primary500,
                                    onChanged: (val) {
                                      setState(() {
                                        item['enabled'] = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildItemTextField(
                                      controller: nameCtrl,
                                      hintText: isDiscountTab ? 'Discount Name' : 'Voucher Code',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildItemTextField(
                                      controller: amountCtrl,
                                      hintText: 'Amount',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: _buildTypeDropdown(
                                      currentValue: typeVal,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            item['type'] = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppColors.neutral500),
                                    onPressed: () {
                                      setState(() {
                                        currentList.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              // Toggle switch
                              Switch.adaptive(
                                value: isEnabled,
                                activeThumbColor: AppColors.primary500,
                                onChanged: (val) {
                                  setState(() {
                                    item['enabled'] = val;
                                  });
                                },
                              ),
                              const SizedBox(width: 12),

                              // Name TextField
                              Expanded(
                                flex: 3,
                                child: _buildItemTextField(
                                  controller: nameCtrl,
                                  hintText: isDiscountTab ? 'Discount Name' : 'Voucher Code',
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Amount TextField
                              SizedBox(
                                width: 140,
                                child: _buildItemTextField(
                                  controller: amountCtrl,
                                  hintText: 'Amount',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Type Dropdown
                              SizedBox(
                                width: 170,
                                child: _buildTypeDropdown(
                                  currentValue: typeVal,
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        item['type'] = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Delete Button
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.neutral200),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.neutral500, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      currentList.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabItem(String label) {
    final bool isActive = _discountSubTab == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _discountSubTab = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTypography.bodyMBold.copyWith(
                color: isActive ? AppColors.neutral900 : AppColors.neutral600,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 3),
              Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral900),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral400),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutral300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildTypeDropdown({
    required String currentValue,
    required ValueChanged<String?> onChanged,
  }) {
    final List<String> options = ['By Percentage', 'By Price', 'Choose type'];
    final String validValue = options.contains(currentValue) ? currentValue : 'Choose type';

    return DropdownButtonFormField<String>(
      initialValue: validValue,
      dropdownColor: AppColors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutral300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
        ),
      ),
      style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral900),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.neutral500),
      items: options.map((opt) {
        return DropdownMenuItem(
          value: opt,
          child: Text(
            opt,
            style: AppTypography.bodyMRegular.copyWith(
              color: opt == 'Choose type' ? AppColors.neutral400 : AppColors.neutral900,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // --- PRINTER PANEL ---
  Widget _buildPrinterPanel() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Panel (Title & Add Printer Button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Printer',
                style: AppTypography.h3Bold.copyWith(
                  color: AppColors.neutral900,
                  fontSize: 26,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditPrinterModal(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Printer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. Printer List Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _printersList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final printer = _printersList[index];
              final bool isConnected = printer['status'] == 'Connected';
              final String connType = printer['connectionType'] ?? 'Wireless';

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.neutral200,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    // Printer Image / Graphic Box
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        connType == 'Bluetooth'
                            ? Icons.print
                            : Icons.print_outlined,
                        size: 32,
                        color: AppColors.neutral800,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Printer Name & Model Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            printer['name'],
                            style: AppTypography.bodyLBold.copyWith(
                              color: AppColors.neutral900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                printer['model'],
                                style: AppTypography.bodySRegular.copyWith(
                                  color: AppColors.neutral500,
                                ),
                              ),
                              const SizedBox(width: 10),
                              _buildConnectionTypeBadge(connType),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Status Badge (Connected / Offline)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isConnected
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF6B7280),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isConnected ? 'Connected' : 'Offline',
                            style: TextStyle(
                              color: isConnected
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 3-dots Menu Button (Edit & Delete)
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.neutral200),
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          size: 18,
                          color: AppColors.neutral700,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showAddEditPrinterModal(printer: printer, index: index);
                        } else if (value == 'delete') {
                          _confirmDeletePrinter(index);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: const [
                              Icon(Icons.edit_outlined, size: 18, color: AppColors.neutral700),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                              SizedBox(width: 10),
                              Text('Delete', style: TextStyle(color: Color(0xFFDC2626))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionTypeBadge(String type) {
    IconData iconData;
    Color color;

    if (type == 'Bluetooth') {
      iconData = Icons.bluetooth;
      color = const Color(0xFF2563EB);
    } else if (type == 'Wireless') {
      iconData = Icons.wifi;
      color = const Color(0xFF059669);
    } else {
      iconData = Icons.usb;
      color = const Color(0xFFD97706);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEditPrinterModal({Map<String, dynamic>? printer, int? index}) {
    final bool isEdit = printer != null;
    final TextEditingController nameCtrl =
        TextEditingController(text: isEdit ? printer['name'] : '');
    final TextEditingController modelCtrl =
        TextEditingController(text: isEdit ? printer['model'] : '');
    final TextEditingController ipCtrl =
        TextEditingController(text: isEdit ? printer['ipOrMac'] : '');

    String connectionType = isEdit ? (printer['connectionType'] ?? 'Wireless') : 'Wireless';
    String paperWidth = isEdit ? (printer['paperWidth'] ?? '80mm') : '80mm';
    String target = isEdit ? (printer['target'] ?? 'Receipt / Kasir') : 'Receipt / Kasir';
    bool isConnected = isEdit ? (printer['status'] == 'Connected') : true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 520,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modal Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEdit ? 'Edit Printer' : 'Add Printer',
                            style: AppTypography.h4Bold.copyWith(color: AppColors.neutral900),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.neutral500),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Printer Name
                      Text('Printer Name', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Front Printer, Kitchen Printer',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Printer Model
                      Text('Printer Model / Specification', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: modelCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Epson TMT-82X, Star Micronics',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Connection Type
                      Text('Connection Type', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                      const SizedBox(height: 8),
                      Row(
                        children: ['Wireless', 'Bluetooth', 'Wired'].map((type) {
                          final bool selected = connectionType == type;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Center(child: Text(type)),
                                selected: selected,
                                selectedColor: AppColors.primary500.withValues(alpha: 0.15),
                                labelStyle: TextStyle(
                                  color: selected ? AppColors.primary500 : AppColors.neutral700,
                                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                ),
                                side: BorderSide(
                                  color: selected ? AppColors.primary500 : AppColors.neutral300,
                                ),
                                onSelected: (bool val) {
                                  if (val) {
                                    setModalState(() => connectionType = type);
                                  }
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // IP Address / Bluetooth MAC / Port
                      Text(
                        connectionType == 'Wireless'
                            ? 'IP Address (Wi-Fi/LAN)'
                            : connectionType == 'Bluetooth'
                                ? 'Bluetooth MAC / Device Name'
                                : 'USB / Cable Port',
                        style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: ipCtrl,
                        decoration: InputDecoration(
                          hintText: connectionType == 'Wireless'
                              ? 'e.g. 192.168.1.100'
                              : connectionType == 'Bluetooth'
                                  ? 'e.g. 00:11:22:33:44:55'
                                  : 'e.g. USB001',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Paper Width & Target Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Paper Width', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  initialValue: paperWidth,
                                  dropdownColor: AppColors.white,
                                  style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900),
                                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.neutral600),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: '80mm',
                                      child: Text('80mm (Thermal)', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900)),
                                    ),
                                    DropdownMenuItem(
                                      value: '58mm',
                                      child: Text('58mm (Mini)', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900)),
                                    ),
                                    DropdownMenuItem(
                                      value: 'A4 / Standard',
                                      child: Text('A4 Paper', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900)),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => paperWidth = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Printer Target', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  initialValue: target,
                                  dropdownColor: AppColors.white,
                                  style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900),
                                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.neutral600),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'Receipt / Kasir',
                                      child: Text('Receipt / Kasir', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900)),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Kitchen / Dapur',
                                      child: Text('Kitchen / Dapur', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900)),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Bar',
                                      child: Text('Bar', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900)),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Report',
                                      child: Text('Report', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900)),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => target = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Status Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mark as Connected', style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral800)),
                          Switch.adaptive(
                            value: isConnected,
                            activeThumbColor: AppColors.primary500,
                            onChanged: (val) {
                              setModalState(() => isConnected = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.neutral300),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              final name = nameCtrl.text.trim();
                              final model = modelCtrl.text.trim();
                              if (name.isNotEmpty) {
                                setState(() {
                                  final itemData = {
                                    'id': isEdit
                                        ? printer['id']
                                        : DateTime.now().millisecondsSinceEpoch.toString(),
                                    'name': name,
                                    'model': model.isEmpty ? 'Thermal Printer' : model,
                                    'connectionType': connectionType,
                                    'ipOrMac': ipCtrl.text.trim(),
                                    'paperWidth': paperWidth,
                                    'target': target,
                                    'status': isConnected ? 'Connected' : 'Offline',
                                  };

                                  if (isEdit && index != null) {
                                    _printersList[index] = itemData;
                                  } else {
                                    _printersList.add(itemData);
                                  }
                                });
                                Navigator.pop(ctx);
                                _triggerToast(
                                  isEdit ? 'Printer Updated!' : 'Printer Added!',
                                  '$name has been saved successfully.',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(isEdit ? 'Save Changes' : 'Add Printer'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeletePrinter(int index) {
    final name = _printersList[index]['name'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Printer'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _printersList.removeAt(index);
              });
              Navigator.pop(ctx);
              _triggerToast('Printer Deleted', '$name removed successfully.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: AppColors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER UNTUK DASHED BORDER LOGO DROPZONE ---
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = math.min(6.0, metric.length - distance);
        dashPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += len + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) => false;
}
