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
      TextEditingController(text: 'Haji Wong Halal');
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
      {'title': 'Category', 'icon': Icons.grid_view_outlined},
      {'title': 'Modifier', 'icon': Icons.view_in_ar_outlined},
      {'title': 'Payment Method', 'icon': Icons.credit_card_outlined},
      {'title': 'Taxes', 'icon': Icons.percent_outlined},
      {'title': 'Discount & Voucher', 'icon': Icons.confirmation_number_outlined},
      {'title': 'Receipt Option', 'icon': Icons.receipt_long_outlined},
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
