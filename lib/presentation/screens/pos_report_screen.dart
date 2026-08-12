import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/pos_navigation_drawer.dart';
import '../widgets/custom_success_toast.dart';
import 'pos_order_screen.dart';

class PosReportScreen extends StatefulWidget {
  const PosReportScreen({super.key});

  @override
  State<PosReportScreen> createState() => _PosReportScreenState();
}

class _PosReportScreenState extends State<PosReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTimeRange = 'Last 6 Months';

  // State untuk hover chart
  int _hoveredChartIndex = 7; // Default ke Agustus 2024 (index 7)

  // State untuk Toast Notification (Konsisten dengan page lain)
  bool _showToast = false;
  String _toastTitle = '';
  String _toastSubtitle = '';
  bool _toastIsSuccess = true;

  // Data Sales Chart (Januari - Desember 12 Bulan)
  final List<double> _salesData = [
    1800, 2400, 2900, 3100, 3800, 4200, 4500, 4802, 5100, 5600, 6200, 6800
  ];
  final List<String> _salesMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final List<String> _salesFullMonths = [
    'January 2024',
    'February 2024',
    'March 2024',
    'April 2024',
    'May 2024',
    'June 2024',
    'July 2024',
    'August 2024',
    'September 2024',
    'October 2024',
    'November 2024',
    'December 2024'
  ];

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

  // Dialog Pemilih Custom Date Range
  Future<void> _selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026, 12, 31),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary500,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.neutral900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String startStr =
          "${picked.start.day.toString().padLeft(2, '0')}/${picked.start.month.toString().padLeft(2, '0')}/${picked.start.year}";
      final String endStr =
          "${picked.end.day.toString().padLeft(2, '0')}/${picked.end.month.toString().padLeft(2, '0')}/${picked.end.year}";
      final String displayRange = "$startStr - $endStr";

      setState(() {
        _selectedTimeRange = displayRange;
      });
      _triggerToast('Custom Date Selected', 'Rentang waktu: $displayRange');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1100;
    final bool isTablet = screenWidth >= 768 && screenWidth < 1100;
    final bool isMobile = screenWidth < 768;

    // Menyiapkan opsi dropdown secara dinamis jika ada custom date range yang dipilih
    final List<String> dropdownOptions = [
      'Today',
      'Last 7 Days',
      'This Month',
      'Last 6 Months',
      'Custom Date Range',
    ];
    if (!dropdownOptions.contains(_selectedTimeRange)) {
      dropdownOptions.add(_selectedTimeRange);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA), // Light gray background
      drawer: const PosNavigationDrawer(activeRoute: 'report'),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Report',
          style: AppTypography.h4Bold.copyWith(color: AppColors.neutral900),
        ),
        actions: [
          // Time range filter dropdown
          Center(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neutral300, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTimeRange,
                  dropdownColor: AppColors.white,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.neutral500, size: 18),
                  style: AppTypography.bodySRegular.copyWith(
                    color: AppColors.neutral900,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue == 'Custom Date Range') {
                      _selectCustomDateRange(context);
                    } else if (newValue != null) {
                      setState(() {
                        _selectedTimeRange = newValue;
                      });
                      _triggerToast('Filter Ganti', 'Rentang waktu diubah menjadi $newValue');
                    }
                  },
                  items: dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppTypography.bodySRegular.copyWith(
                          color: AppColors.neutral900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Download button
          Center(
            child: SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  _triggerToast('Unduh Laporan', 'File PDF/Excel sedang dipersiapkan...');
                },
                icon: const Icon(Icons.file_download_outlined, color: AppColors.neutral800, size: 18),
                label: isMobile
                    ? const SizedBox.shrink()
                    : Text(
                        'Download',
                        style: AppTypography.bodySRegular.copyWith(
                          color: AppColors.neutral800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.neutral800,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.neutral300, width: 1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Baris Stat Cards
                _buildStatCardsGrid(screenWidth),
                const SizedBox(height: 24),

                // 2. Area Grafik & Top Products
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kiri: Grafik Area & Donut (Flex 7)
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: [
                                _buildSalesOverviewCard(),
                                const SizedBox(height: 24),
                                _buildDonutChartsRow(isMobile: false),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Kanan: Top 10 Product (Flex 3)
                          Expanded(
                            flex: 3,
                            child: _buildTopProductsCard(),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildSalesOverviewCard(),
                          const SizedBox(height: 24),
                          _buildDonutChartsRow(isMobile: !isTablet),
                          const SizedBox(height: 24),
                          _buildTopProductsCard(),
                        ],
                      ),
                const SizedBox(height: 24),

                // 3. Recent Order Table
                _buildRecentOrdersCard(),
              ],
            ),
          ),

          // FLOATING TOAST NOTIFICATION (Konsisten dengan page lain)
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

  // --- SECTION WIDGETS ---

  // Stat Cards (Grid)
  Widget _buildStatCardsGrid(double screenWidth) {
    int crossAxisCount = 4;
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 1100) {
      crossAxisCount = 2;
    }

    if (crossAxisCount == 1) {
      return Column(
        children: [
          _buildStatCard(
            title: 'Total Order',
            value: '72.099',
            trend: '+7%',
            isPositive: true,
            icon: Icons.shopping_bag_outlined,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            title: 'Total Revenue',
            value: 'Rp 349.005.000',
            trend: '+12%',
            isPositive: true,
            icon: Icons.account_balance_wallet_outlined,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            title: 'Total Customer',
            value: '50.921',
            trend: '+4%',
            isPositive: true,
            icon: Icons.people_outline,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            title: 'New Customer',
            value: '6.007',
            trend: '-5%',
            isPositive: false,
            icon: Icons.person_add_outlined,
          ),
        ],
      );
    } else if (crossAxisCount == 2) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Order',
                  value: '72.099',
                  trend: '+7%',
                  isPositive: true,
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Total Revenue',
                  value: 'Rp 349.005.000',
                  trend: '+12%',
                  isPositive: true,
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Customer',
                  value: '50.921',
                  trend: '+4%',
                  isPositive: true,
                  icon: Icons.people_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'New Customer',
                  value: '6.007',
                  trend: '-5%',
                  isPositive: false,
                  icon: Icons.person_add_outlined,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Total Order',
              value: '72.099',
              trend: '+7%',
              isPositive: true,
              icon: Icons.shopping_bag_outlined,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Total Revenue',
              value: 'Rp 349.005.000',
              trend: '+12%',
              isPositive: true,
              icon: Icons.account_balance_wallet_outlined,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Total Customer',
              value: '50.921',
              trend: '+4%',
              isPositive: true,
              icon: Icons.people_outline,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'New Customer',
              value: '6.007',
              trend: '-5%',
              isPositive: false,
              icon: Icons.person_add_outlined,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary500,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: AppTypography.bodyMRegular.copyWith(
                      color: AppColors.neutral600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Badge trend persentase
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trend,
                    style: TextStyle(
                      color: isPositive ? AppColors.primary600 : AppColors.error500,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? AppColors.primary600 : AppColors.error500,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTypography.h4Bold.copyWith(
              color: AppColors.neutral900,
              fontSize: 26,
            ),
          ),
        ],
      ),
    );
  }

  // Sales Overview Card (Left column middle) - 12 Bulan (Januari - Desember)
  Widget _buildSalesOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Overview',
            style: AppTypography.bodyLBold.copyWith(
              color: AppColors.neutral900,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Sumbu Y dan Grafik Custom Painter
          LayoutBuilder(
            builder: (context, constraints) {
              final double chartWidth = constraints.maxWidth;
              const double chartHeight = 240.0;

              // Hitung posisi tooltip berdasarkan hovered index
              double tooltipLeft = 0.0;
              double tooltipTop = 0.0;

              if (_hoveredChartIndex >= 0 && _hoveredChartIndex < _salesData.length) {
                const double paddingLeft = 20.0;
                const double paddingRight = 60.0;
                const double paddingTop = 20.0;
                const double paddingBottom = 40.0;

                final double activeWidth = chartWidth - paddingLeft - paddingRight;
                final double activeHeight = chartHeight - paddingTop - paddingBottom;

                final double stepX = activeWidth / (_salesData.length - 1);
                final double val = _salesData[_hoveredChartIndex];
                
                tooltipLeft = paddingLeft + _hoveredChartIndex * stepX;
                tooltipTop = paddingTop + activeHeight * (1 - (val / 7000.0));
              }

              // Perbaikan right/left overflow pada tooltip dengan pembatasan clamp (lebar 180 px)
              double leftPosition = tooltipLeft - 90; // Centered tooltip width (180 px)
              if (leftPosition < 8.0) {
                leftPosition = 8.0;
              } else if (leftPosition + 180.0 > chartWidth - 8.0) {
                leftPosition = chartWidth - 180.0 - 8.0;
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Area Grafik & Interaksi Mouse
                  GestureDetector(
                    onPanUpdate: (details) {
                      _updateHoverIndex(details.localPosition, chartWidth, chartHeight);
                    },
                    onTapDown: (details) {
                      _updateHoverIndex(details.localPosition, chartWidth, chartHeight);
                    },
                    child: MouseRegion(
                      onHover: (event) {
                        _updateHoverIndex(event.localPosition, chartWidth, chartHeight);
                      },
                      child: CustomPaint(
                        size: Size(chartWidth, chartHeight),
                        painter: SalesChartPainter(
                          data: _salesData,
                          months: _salesMonths,
                          selectedIndex: _hoveredChartIndex,
                        ),
                      ),
                    ),
                  ),

                  // Floating Tooltip Clamped (Lebar 180 px)
                  if (_hoveredChartIndex >= 0 && _hoveredChartIndex < _salesData.length)
                    Positioned(
                      left: leftPosition,
                      top: tooltipTop - 70,  // Berada di atas titik
                      child: Container(
                        width: 180,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: AppColors.neutral200),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _salesFullMonths[_hoveredChartIndex],
                              style: AppTypography.bodyXsRegular.copyWith(
                                color: AppColors.neutral500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary500,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Sales: Rp ${_formatCurrency(_salesData[_hoveredChartIndex])}',
                                  style: AppTypography.bodyXsBold.copyWith(
                                    color: AppColors.neutral900,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _updateHoverIndex(Offset localPosition, double chartWidth, double chartHeight) {
    const double paddingLeft = 20.0;
    const double paddingRight = 60.0;
    final double activeWidth = chartWidth - paddingLeft - paddingRight;

    if (activeWidth <= 0) return;

    final double stepX = activeWidth / (_salesData.length - 1);
    final double relativeX = localPosition.dx - paddingLeft;
    
    int index = (relativeX / stepX).round();
    index = index.clamp(0, _salesData.length - 1);

    if (_hoveredChartIndex != index) {
      setState(() {
        _hoveredChartIndex = index;
      });
    }
  }

  // Row of 3 Donut Charts (Order Type, Category Sales, Payment Method)
  Widget _buildDonutChartsRow({required bool isMobile}) {
    if (isMobile) {
      return Column(
        children: [
          // Donut 1: Order Type (Dine In vs Take Away)
          _buildDonutCard(
            title: 'Order Type',
            totalLabel: '100%\nOrder Type',
            values: [68, 32],
            colors: [AppColors.primary500, const Color(0xFFFF9F43)],
            legends: [
              _buildLegendRow('Dine In', '68% (49.027 Orders)', AppColors.primary500),
              _buildLegendRow('Take Away', '32% (23.072 Orders)', const Color(0xFFFF9F43)),
            ],
            showShowAll: false,
          ),
          const SizedBox(height: 16),
          // Donut 2: Category Sales (Main Course, Dimsum, Beverages, Dessert)
          _buildDonutCard(
            title: 'Category Sales',
            totalLabel: '4\nCategories',
            values: [45, 30, 15, 10],
            colors: [
              AppColors.primary500,
              const Color(0xFFFFAB00),
              const Color(0xFF1D90FB),
              const Color(0xFF9C27B0),
            ],
            legends: [
              _buildLegendRow('Main Course', '45%', AppColors.primary500),
              _buildLegendRow('Dimsum', '30%', const Color(0xFFFFAB00)),
              _buildLegendRow('Beverages', '15%', const Color(0xFF1D90FB)),
              _buildLegendRow('Dessert', '10%', const Color(0xFF9C27B0)),
            ],
            showShowAll: false,
          ),
          const SizedBox(height: 16),
          // Donut 3: Payment Method (Cash vs QRIS)
          _buildDonutCard(
            title: 'Payment Method',
            totalLabel: '100%\nTransactions',
            values: [65, 35],
            colors: [const Color(0xFF1E5631), AppColors.primary500],
            legends: [
              _buildLegendRow('Cash', '65% (Rp 226.853.250)', const Color(0xFF1E5631)),
              _buildLegendRow('QRIS', '35% (Rp 122.151.750)', AppColors.primary500),
            ],
            showShowAll: false,
          ),
        ],
      );
    }

    return Row(
      children: [
        // Donut 1: Order Type (Dine In vs Take Away)
        Expanded(
          child: _buildDonutCard(
            title: 'Order Type',
            totalLabel: '100%\nOrder Type',
            values: [68, 32],
            colors: [AppColors.primary500, const Color(0xFFFF9F43)],
            legends: [
              _buildLegendRow('Dine In', '68% (49.027)', AppColors.primary500),
              _buildLegendRow('Take Away', '32% (23.072)', const Color(0xFFFF9F43)),
            ],
            showShowAll: false,
          ),
        ),
        const SizedBox(width: 16),
        // Donut 2: Category Sales (Main Course, Dimsum, Beverages, Dessert)
        Expanded(
          child: _buildDonutCard(
            title: 'Category Sales',
            totalLabel: '4\nCategories',
            values: [45, 30, 15, 10],
            colors: [
              AppColors.primary500,
              const Color(0xFFFFAB00),
              const Color(0xFF1D90FB),
              const Color(0xFF9C27B0),
            ],
            legends: [
              _buildLegendRow('Main Course', '45%', AppColors.primary500),
              _buildLegendRow('Dimsum', '30%', const Color(0xFFFFAB00)),
              _buildLegendRow('Beverages', '15%', const Color(0xFF1D90FB)),
              _buildLegendRow('Dessert', '10%', const Color(0xFF9C27B0)),
            ],
            showShowAll: false,
          ),
        ),
        const SizedBox(width: 16),
        // Donut 3: Payment Method (Cash vs QRIS)
        Expanded(
          child: _buildDonutCard(
            title: 'Payment Method',
            totalLabel: '100%\nTransactions',
            values: [65, 35],
            colors: [const Color(0xFF1E5631), AppColors.primary500],
            legends: [
              _buildLegendRow('Cash', '65% (Rp 226.853.250)', const Color(0xFF1E5631)),
              _buildLegendRow('QRIS', '35% (Rp 122.151.750)', AppColors.primary500),
            ],
            showShowAll: false,
          ),
        ),
      ],
    );
  }

  Widget _buildDonutCard({
    required String title,
    required String totalLabel,
    required List<double> values,
    required List<Color> colors,
    required List<Widget> legends,
    bool showShowAll = true,
    VoidCallback? onShowAll,
  }) {
    return Container(
      height: 310,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.bodyMBold.copyWith(
                  color: AppColors.neutral900,
                ),
              ),
              if (showShowAll)
                TextButton(
                  onPressed: onShowAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Show All',
                    style: AppTypography.bodyXsMedium.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Donut Chart drawing
          Center(
            child: SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(110, 110),
                    painter: DonutChartPainter(
                      values: values,
                      colors: colors,
                    ),
                  ),
                  Center(
                    child: Text(
                      totalLabel,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyXsBold.copyWith(
                        fontSize: 10,
                        color: AppColors.neutral800,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legends
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: legends,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(String label, String count, Color color, {Widget? trailingIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.bodyXsRegular.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 4),
                trailingIcon,
              ],
            ],
          ),
          Text(
            count,
            style: AppTypography.bodyXsBold.copyWith(
              color: AppColors.neutral800,
            ),
          ),
        ],
      ),
    );
  }

  // Top 10 Product List (Right Column)
  Widget _buildTopProductsCard() {
    final List<Map<String, dynamic>> products = [
      {'name': 'Special Crispyburger', 'sales': '9778'},
      {'name': 'Double Cheeseburger', 'sales': '7640'},
      {'name': 'Chocolate Milkshake', 'sales': '7620'},
      {'name': 'Combo Drumstick & French fries', 'sales': '7184'},
      {'name': 'Coca cola', 'sales': '4659'},
      {'name': 'Cheeseburger Deluxe', 'sales': '3880'},
      {'name': 'Vanilla Sundae', 'sales': '3783'},
      {'name': 'Spicy Chicken Burger', 'sales': '3366'},
      {'name': '3 Cheese Wings', 'sales': '1278'},
      {'name': 'Sprite', 'sales': '808'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top 10 Product',
            style: AppTypography.bodyLBold.copyWith(
              color: AppColors.neutral900,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Custom Table Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  'Item',
                  style: AppTypography.bodyXsBold.copyWith(color: AppColors.neutral400),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Terjual',
                  textAlign: TextAlign.end,
                  style: AppTypography.bodyXsBold.copyWith(color: AppColors.neutral400),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.neutral200),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (context, index) => const Divider(color: AppColors.neutral100),
            itemBuilder: (context, index) {
              final prod = products[index];
              final rank = index + 1;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    // Rank Badge / Icon
                    _buildRankBadge(rank),
                    const SizedBox(width: 12),
                    // Item Thumbnail
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fastfood_outlined,
                          color: AppColors.primary500,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Product Name
                    Expanded(
                      flex: 6,
                      child: Text(
                        prod['name'],
                        style: AppTypography.bodySRegular.copyWith(
                          color: AppColors.neutral900,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Total Sold
                    Expanded(
                      flex: 3,
                      child: Text(
                        prod['sales'],
                        textAlign: TextAlign.end,
                        style: AppTypography.bodySBold.copyWith(
                          color: AppColors.neutral900,
                        ),
                      ),
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

  Widget _buildRankBadge(int rank) {
    Color badgeColor = AppColors.neutral200;
    Color textColor = AppColors.neutral700;
    bool isCup = rank <= 3;

    if (rank == 1) {
      badgeColor = AppColors.primary500;
      textColor = AppColors.white;
    } else if (rank == 2) {
      badgeColor = const Color(0xFFFFAB00); // Orange/Amber
      textColor = AppColors.white;
    } else if (rank == 3) {
      badgeColor = const Color(0xFF1D90FB); // Blue
      textColor = AppColors.white;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCup
            ? Icon(
                Icons.emoji_events,
                color: textColor,
                size: 14,
              )
            : Text(
                '$rank',
                style: AppTypography.bodyXsBold.copyWith(
                  color: textColor,
                ),
              ),
      ),
    );
  }

  // Recent Orders Card (Bottom Section)
  Widget _buildRecentOrdersCard() {
    final List<Map<String, dynamic>> orders = [
      {
        'id': '#201OE10',
        'status': 'In Progress',
        'statusColor': AppColors.warning500,
        'date': 'Oct 16, 2024\n09:31 AM',
        'customer': 'Dian Rahmani',
        'type': 'Dine In',
        'payment': 'QRIS',
        'qty': '5',
        'total': 'Rp 34.500',
      },
      {
        'id': '#926MN67',
        'status': 'Open',
        'statusColor': AppColors.info500,
        'date': 'Oct 16, 2024\n11:32 AM',
        'customer': 'Sinta Dewi',
        'type': 'Dine In',
        'payment': 'Cash',
        'qty': '-',
        'total': '-',
      },
      {
        'id': '#201OE10',
        'status': 'In Progress',
        'statusColor': AppColors.warning500,
        'date': 'Oct 16, 2024\n11:17 AM',
        'customer': '-',
        'type': 'Take Away',
        'payment': 'Cash',
        'qty': '12',
        'total': 'Rp 110.800',
      },
      {
        'id': '#926MN67',
        'status': 'Open',
        'statusColor': AppColors.info500,
        'date': 'Oct 16, 2024\n10:54 AM',
        'customer': 'Adi Nugroho',
        'type': 'Dine In',
        'payment': 'QRIS',
        'qty': '-',
        'total': '-',
      },
      {
        'id': '#201OE10',
        'status': 'Completed',
        'statusColor': AppColors.primary500,
        'date': 'Oct 16, 2024\n11:15 AM',
        'customer': 'Lia Wijaya',
        'type': 'Dine In',
        'payment': 'Cash',
        'qty': '3',
        'total': 'Rp 11.000',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Order',
                style: AppTypography.bodyLBold.copyWith(
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PosOrderScreen()),
                  );
                },
                child: Text(
                  'Show All',
                  style: AppTypography.bodyXsMedium.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Scrollable Table stretched on desktop, scrolls on mobile
          LayoutBuilder(
            builder: (context, constraints) {
              // Rapi dan membentang penuh (stretch) jika ukuran lebar cukup, minimal 950 px
              final double tableWidth = constraints.maxWidth > 950 ? constraints.maxWidth : 950.0;
              
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.2), // ID
                      1: FlexColumnWidth(1.5), // STATUS
                      2: FlexColumnWidth(2.0), // ORDER DATE
                      3: FlexColumnWidth(2.5), // CUSTOMER
                      4: FlexColumnWidth(1.5), // ORDER TYPE
                      5: FlexColumnWidth(1.8), // PAYMENT METHOD
                      6: FlexColumnWidth(1.0), // QTY
                      7: FlexColumnWidth(1.5), // TOTAL
                      8: FlexColumnWidth(0.8), // ACTION
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      // Table Header Row
                      TableRow(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.neutral200, width: 1.5)),
                        ),
                        children: [
                          _buildTableHeaderCell('ID'),
                          _buildTableHeaderCell('STATUS'),
                          _buildTableHeaderCell('ORDER DATE'),
                          _buildTableHeaderCell('CUSTOMER'),
                          _buildTableHeaderCell('ORDER TYPE'),
                          _buildTableHeaderCell('PAYMENT METHOD'),
                          _buildTableHeaderCell('QTY'),
                          _buildTableHeaderCell('TOTAL'),
                          _buildTableHeaderCell(''),
                        ],
                      ),
                      // Table Data Rows
                      ...orders.map((ord) {
                        return TableRow(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.neutral100)),
                          ),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  ord['id'],
                                  style: AppTypography.bodySRegular.copyWith(
                                    color: AppColors.neutral900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (ord['statusColor'] as Color).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        ord['status'],
                                        style: AppTypography.bodyXsBold.copyWith(
                                          color: ord['statusColor'],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  ord['date'],
                                  style: AppTypography.bodyXsRegular.copyWith(
                                    color: AppColors.neutral500,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ord['customer'],
                                      style: AppTypography.bodySRegular.copyWith(
                                        color: ord['customer'] == '-'
                                            ? AppColors.neutral400
                                            : AppColors.neutral800,
                                        fontWeight: ord['customer'] == '-'
                                            ? FontWeight.normal
                                            : FontWeight.w600,
                                      ),
                                    ),
                                    if (ord['customer'] != '-') ...[
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.open_in_new,
                                        size: 12,
                                        color: AppColors.neutral400,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  ord['type'],
                                  style: AppTypography.bodySRegular.copyWith(
                                    color: AppColors.neutral700,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  ord['payment'],
                                  style: AppTypography.bodySRegular.copyWith(
                                    color: AppColors.neutral800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  ord['qty'],
                                  style: AppTypography.bodySRegular.copyWith(
                                    color: ord['qty'] == '-'
                                        ? AppColors.neutral400
                                        : AppColors.neutral800,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  ord['total'],
                                  style: AppTypography.bodySBold.copyWith(
                                    color: ord['total'] == '-'
                                        ? AppColors.neutral400
                                        : AppColors.neutral900,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, color: AppColors.neutral500),
                                onSelected: (String value) {
                                  _triggerToast('Aksi Terpilih', '$value untuk transaksi ${ord['id']}');
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'details',
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility_outlined, size: 18),
                                        SizedBox(width: 8),
                                        Text('View Details'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'print',
                                    child: Row(
                                      children: [
                                        Icon(Icons.print_outlined, size: 18),
                                        SizedBox(width: 8),
                                        Text('Print Receipt'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuDivider(),
                                  const PopupMenuItem<String>(
                                    value: 'refund',
                                    child: Row(
                                      children: [
                                        Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Refund / Cancel', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Text(
          text,
          style: AppTypography.bodyXsBold.copyWith(
            color: AppColors.neutral400,
          ),
        ),
      ),
    );
  }

  // Formatting helpers
  String _formatCurrency(double amount) {
    int value = amount.toInt();
    String str = value.toString();
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = '${str[i]}$result';
      count++;
      if (count == 3 && i > 0) {
        result = '.$result';
        count = 0;
      }
    }
    // Karena data chart adalah kelipatan ribuan, misal 4802 = Rp 4.802.000
    return '$result.000';
  }
}

// --- DONUT CHART PAINTER ---
class DonutChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double holeRadiusPercent;

  DonutChartPainter({
    required this.values,
    required this.colors,
    this.holeRadiusPercent = 0.65,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total = values.fold(0, (sum, item) => sum + item);
    if (total == 0) return;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -3.1415926535 / 2; // -90 derajat (atas)

    for (int i = 0; i < values.length; i++) {
      final double sweepAngle = (values[i] / total) * 2 * 3.1415926535;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    // Gambar lingkaran putih di tengah untuk membuat lubang donat
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * holeRadiusPercent, innerPaint);
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) => true;
}

// --- LINE/AREA CHART PAINTER ---
class SalesChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> months;
  final int? selectedIndex;

  SalesChartPainter({
    required this.data,
    required this.months,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double paddingLeft = 20.0;
    const double paddingRight = 60.0; // Memberikan ruang cukup di kanan untuk label sumbu Y agar tidak overflow
    const double paddingTop = 20.0;
    const double paddingBottom = 40.0;

    final double chartWidth = size.width - paddingLeft - paddingRight;
    final double chartHeight = size.height - paddingTop - paddingBottom;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    final Paint gridPaint = Paint()
      ..color = AppColors.neutral200.withValues(alpha: 0.5)
      ..strokeWidth = 1.0;

    final Paint linePaint = Paint()
      ..color = AppColors.primary500
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = AppColors.primary500
      ..style = PaintingStyle.fill;

    final Paint dotOuterPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const double maxVal = 7000.0;

    // 1. Grid Horisontal & Label Y Axis (Digambar di sisi kanan sesuai screenshot)
    final List<double> yLevels = [0, 1000, 3000, 5000, 7000];
    for (int i = 0; i < yLevels.length; i++) {
      final double val = yLevels[i];
      final double y = paddingTop + chartHeight * (1 - (val / maxVal));
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      // Label teks di sebelah kanan
      final tp = TextPainter(
        text: TextSpan(
          text: val.toInt().toString(),
          style: AppTypography.bodyXsMedium.copyWith(color: AppColors.neutral400, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(size.width - paddingRight + 8, y - tp.height / 2));
    }

    if (data.isEmpty) return;

    // 2. Hitung Titik Koordinat Data
    final double stepX = chartWidth / (data.length - 1);
    final List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final double x = paddingLeft + i * stepX;
      final double y = paddingTop + chartHeight * (1 - (data[i] / maxVal));
      points.add(Offset(x, y));
    }

    // 3. Gambar Area Gradasi di Bawah Garis
    final Path areaPath = Path();
    areaPath.moveTo(points.first.dx, paddingTop + chartHeight);
    for (int i = 0; i < points.length; i++) {
      areaPath.lineTo(points[i].dx, points[i].dy);
    }
    areaPath.lineTo(points.last.dx, paddingTop + chartHeight);
    areaPath.close();

    final Paint areaPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.primary500.withValues(alpha: 0.25),
          AppColors.primary500.withValues(alpha: 0.005),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(
        paddingLeft,
        paddingTop,
        size.width - paddingRight,
        paddingTop + chartHeight,
      ));
    canvas.drawPath(areaPath, areaPaint);

    // 4. Gambar Garis Penghubung Titik
    final Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // 5. Gambar Garis Vertikal Dotted untuk Data yang sedang dipilih/hovered
    if (selectedIndex != null && selectedIndex! < points.length) {
      final Offset selPt = points[selectedIndex!];
      final Path dottedPath = Path();
      double currY = paddingTop;
      const double dashHeight = 4.0;
      const double dashSpace = 4.0;
      while (currY < paddingTop + chartHeight) {
        dottedPath.moveTo(selPt.dx, currY);
        dottedPath.lineTo(selPt.dx, currY + dashHeight);
        currY += dashHeight + dashSpace;
      }
      final Paint dottedPaint = Paint()
        ..color = AppColors.neutral400
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawPath(dottedPath, dottedPaint);
    }

    // 6. Gambar Titik-titik Data & Label X Axis
    for (int i = 0; i < points.length; i++) {
      final Offset pt = points[i];

      // Dot outline
      canvas.drawCircle(pt, 6.0, dotPaint);
      canvas.drawCircle(pt, 3.0, dotOuterPaint);

      // Label X
      final tp = TextPainter(
        text: TextSpan(
          text: months[i],
          style: AppTypography.bodyXsBold.copyWith(
            color: selectedIndex == i ? AppColors.neutral900 : AppColors.neutral400,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(pt.dx - tp.width / 2, paddingTop + chartHeight + 8));
    }
  }

  @override
  bool shouldRepaint(covariant SalesChartPainter oldDelegate) => true;
}
