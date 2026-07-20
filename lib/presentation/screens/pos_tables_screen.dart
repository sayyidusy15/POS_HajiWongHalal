import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

// Model data untuk Meja
class TableModel {
  final int id;
  final String name;
  final int capacity;
  final String shape; // 'circle', 'square', 'rectangle'
  final double x;
  final double y;
  final double width;
  final double height;
  final bool isUsed;
  final String? orderId;
  final String? customerName;
  final double? price;

  const TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.shape,
    required this.x,
    required this.y,
    this.width = 70,
    this.height = 70,
    required this.isUsed,
    this.orderId,
    this.customerName,
    this.price,
  });
}

class PosTablesScreen extends StatefulWidget {
  const PosTablesScreen({super.key});

  @override
  State<PosTablesScreen> createState() => _PosTablesScreenState();
}

class _PosTablesScreenState extends State<PosTablesScreen> {
  // Mock Data Meja
  final List<TableModel> _tables = const [
    // Top-Right Grid
    TableModel(id: 1, name: 'Table 1', capacity: 2, shape: 'circle', x: 580, y: 70, isUsed: false),
    TableModel(id: 2, name: 'Table 2', capacity: 2, shape: 'circle', x: 670, y: 70, isUsed: false),
    TableModel(id: 4, name: 'Table 4', capacity: 2, shape: 'circle', x: 580, y: 160, isUsed: false),
    TableModel(
      id: 3, 
      name: 'Table 3', 
      capacity: 2, 
      shape: 'circle', 
      x: 670, 
      y: 160, 
      isUsed: true,
      orderId: 'Order #0293E10',
      customerName: 'Emily Brown',
      price: 120.00,
    ),

    // Left horizontal line
    TableModel(id: 8, name: 'Table 8', capacity: 2, shape: 'circle', x: 80, y: 160, isUsed: false),
    TableModel(id: 7, name: 'Table 7', capacity: 2, shape: 'circle', x: 170, y: 160, isUsed: false),
    TableModel(id: 6, name: 'Table 6', capacity: 2, shape: 'circle', x: 260, y: 160, isUsed: false),
    TableModel(id: 5, name: 'Table 5', capacity: 2, shape: 'circle', x: 350, y: 160, isUsed: false),

    // Middle Area: Squares
    TableModel(
      id: 10, 
      name: 'Table 10', 
      capacity: 4, 
      shape: 'square', 
      x: 170, 
      y: 280, 
      isUsed: true,
      orderId: 'Order #201OB99',
      customerName: 'Michael Johnson',
      price: 105.25,
    ),
    TableModel(id: 9, name: 'Table 9', capacity: 4, shape: 'square', x: 260, y: 280, isUsed: false),
    TableModel(id: 11, name: 'Table 11', capacity: 4, shape: 'square', x: 170, y: 380, isUsed: false),
    TableModel(id: 12, name: 'Table 12', capacity: 4, shape: 'square', x: 260, y: 380, isUsed: false),

    // Middle Area: Rectangles (width=160, height=80)
    TableModel(id: 13, name: 'Table 13', capacity: 6, shape: 'rectangle', x: 580, y: 280, width: 160, height: 80, isUsed: false),
    TableModel(
      id: 14, 
      name: 'Table 14', 
      capacity: 6, 
      shape: 'rectangle', 
      x: 580, 
      y: 380, 
      width: 160, 
      height: 80, 
      isUsed: true,
      orderId: 'Order #883AD90',
      customerName: 'Sophia Williams',
      price: 185.00,
    ),
    TableModel(id: 15, name: 'Table 15', capacity: 6, shape: 'rectangle', x: 580, y: 480, width: 160, height: 80, isUsed: false),

    // Bottom horizontal line
    TableModel(id: 20, name: 'Table 20', capacity: 2, shape: 'circle', x: 260, y: 580, isUsed: false),
    TableModel(id: 19, name: 'Table 19', capacity: 2, shape: 'circle', x: 350, y: 580, isUsed: false),
    TableModel(id: 18, name: 'Table 18', capacity: 2, shape: 'circle', x: 440, y: 580, isUsed: false),
    TableModel(id: 17, name: 'Table 17', capacity: 2, shape: 'circle', x: 530, y: 580, isUsed: false),
    TableModel(id: 16, name: 'Table 16', capacity: 2, shape: 'circle', x: 620, y: 580, isUsed: false),
  ];

  // State Manajemen Screen
  int? _selectedTableId = 5; // Meja 5 terpilih secara default
  String _activeListTab = 'All Table'; // 'All Table', 'Available', 'Used'
  String _searchQuery = '';
  String _selectedCapacityFilter = 'All Capacity'; // 'All Capacity', '2 Seats', '4 Seats', '6 Seats'

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter Meja untuk Panel Kiri (Daftar Meja)
    final filteredListTables = _tables.where((table) {
      // Filter berdasarkan Search
      final matchesSearch = table.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filter berdasarkan Tab
      bool matchesTab = true;
      if (_activeListTab == 'Available') {
        matchesTab = !table.isUsed;
      } else if (_activeListTab == 'Used') {
        matchesTab = table.isUsed;
      }

      return matchesSearch && matchesTab;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. HEADER HALAMAN ---
            _buildHeader(),

            // --- 2. BODY CONTENT (Daftar Kiri & Peta Kanan) ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- PANEL KIRI (Daftar Meja) ---
                    SizedBox(
                      width: 330,
                      child: Card(
                        color: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.neutral200, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Toggle Menu Pil
                              _buildPillToggle(),
                              const SizedBox(height: 16),

                              // Search Bar
                              _buildSearchBar(),
                              const SizedBox(height: 16),

                              // List Meja (Scrollable)
                              Expanded(
                                child: _buildTableListView(filteredListTables),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),

                    // --- AREA KANAN (Peta Visual Meja) ---
                    Expanded(
                      child: Card(
                        color: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.neutral200, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              // Subtle Dotted Grid Background
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: DottedGridPainter(),
                                ),
                              ),

                              // Header Peta (Legend & Dropdown Kapasitas)
                              Positioned(
                                top: 20,
                                left: 24,
                                right: 24,
                                child: _buildMapHeader(),
                              ),

                              // Visual Map Content (Responsive scaling container)
                              Positioned.fill(
                                top: 80,
                                bottom: 20,
                                left: 24,
                                right: 24,
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: SizedBox(
                                      width: 800,
                                      height: 680,
                                      child: Stack(
                                        children: [
                                          // Cashier Block
                                          _buildCashierBlock(),

                                          // Map Tables
                                          ..._tables.map((table) => _buildMapTableItem(table)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }

  // --- WIDGET BUILDERS ---

  // 1. Header Halaman (Atas)
  Widget _buildHeader() {
    final bool isAnyTableSelected = _selectedTableId != null;

    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.neutral200, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tables',
            style: AppTypography.h4Bold.copyWith(
              color: AppColors.neutral900,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              // Cancel Button
              SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.neutral700,
                    side: const BorderSide(color: AppColors.neutral300, width: 1.2),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Select Table Button
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: isAnyTableSelected
                      ? () {
                          final selectedTable = _tables.firstWhere((t) => t.id == _selectedTableId);
                          Navigator.pop(context, selectedTable.name);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAnyTableSelected ? AppColors.primary500 : AppColors.neutral300,
                    foregroundColor: isAnyTableSelected ? AppColors.white : AppColors.neutral500,
                    disabledBackgroundColor: AppColors.neutral200,
                    disabledForegroundColor: AppColors.neutral400,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Select Table',
                    style: AppTypography.bodySRegular.copyWith(
                      color: isAnyTableSelected ? AppColors.white : AppColors.neutral500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Left Panel: Toggle Pill Menu
  Widget _buildPillToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: ['All Table', 'Available', 'Used'].map((tabName) {
          final bool isActive = _activeListTab == tabName;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeListTab = tabName;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  tabName,
                  style: AppTypography.bodySRegular.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppColors.neutral900 : AppColors.neutral500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 2. Left Panel: Search Bar
  Widget _buildSearchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral300, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.neutral400, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search table name...',
                hintStyle: AppTypography.bodySRegular.copyWith(color: AppColors.neutral400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Icon(Icons.close, color: AppColors.neutral500, size: 16),
            ),
        ],
      ),
    );
  }

  // 2. Left Panel: Scrollable ListView
  Widget _buildTableListView(List<TableModel> listTables) {
    if (listTables.isEmpty) {
      return Center(
        child: Text(
          'No tables found',
          style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500),
        ),
      );
    }

    return ListView.separated(
      itemCount: listTables.length,
      separatorBuilder: (context, index) => const Divider(color: AppColors.neutral200, height: 1),
      itemBuilder: (context, index) {
        final table = listTables[index];
        final bool isSelected = _selectedTableId == table.id;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          onTap: () {
            if (table.isUsed) {
              // Jika meja terpakai, tampilkan snackbar bahwa meja terpakai
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.error500,
                  content: Text(
                    '${table.name} is currently used by ${table.customerName}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              setState(() {
                _selectedTableId = (isSelected) ? null : table.id;
              });
            }
          },
          leading: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: table.isUsed ? AppColors.error500 : AppColors.primary500,
            ),
          ),
          title: Text(
            table.name,
            style: AppTypography.bodyMBold.copyWith(
              color: isSelected ? AppColors.primary600 : AppColors.neutral900,
            ),
          ),
          subtitle: table.isUsed
              ? Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '${table.orderId} • ${table.customerName}',
                    style: AppTypography.bodyXsRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                )
              : null,
          trailing: table.isUsed
              ? Text(
                  '\$ ${table.price?.toStringAsFixed(2)}',
                  style: AppTypography.bodyMBold.copyWith(
                    color: AppColors.neutral900,
                  ),
                )
              : null,
          tileColor: isSelected ? AppColors.primary50.withValues(alpha: 0.5) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }

  // 3. Right Area: Map Header (Legend & Capacity filter)
  Widget _buildMapHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Legend Indicators
        Row(
          children: [
            _buildLegendItem('Available', const Color(0xFFFFFFFF), border: AppColors.neutral400),
            const SizedBox(width: 16),
            _buildLegendItem('Used', Colors.transparent, isStriped: true),
            const SizedBox(width: 16),
            _buildLegendItem('Selected', AppColors.primary500),
          ],
        ),

        // Dropdown Capacity Filter
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neutral300, width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCapacityFilter,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.neutral600),
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCapacityFilter = newValue;
                  });
                }
              },
              items: <String>['All Capacity', '2 Seats', '4 Seats', '6 Seats']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, {Color? border, bool isStriped = false}) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isStriped ? Colors.white : color,
            border: border != null ? Border.all(color: border, width: 1.2) : null,
          ),
          child: isStriped
              ? ClipOval(
                  child: CustomPaint(
                    painter: DiagonalStripesPainter(color: AppColors.neutral300, stripeWidth: 1.5, gap: 3.0),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 3. Right Area: Cashier Block widget
  Widget _buildCashierBlock() {
    return Positioned(
      left: 80,
      top: 280,
      width: 70,
      height: 170,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.neutral300, width: 1.5),
        ),
        alignment: Alignment.center,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            'Cashier',
            style: AppTypography.bodySRegular.copyWith(
              color: AppColors.neutral500,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // 3. Right Area: Individual Map Table Item
  Widget _buildMapTableItem(TableModel table) {
    // Tentukan kecocokan filter kapasitas
    bool isFilteredOut = false;
    if (_selectedCapacityFilter == '2 Seats' && table.capacity != 2) {
      isFilteredOut = true;
    } else if (_selectedCapacityFilter == '4 Seats' && table.capacity != 4) {
      isFilteredOut = true;
    } else if (_selectedCapacityFilter == '6 Seats' && table.capacity != 6) {
      isFilteredOut = true;
    }

    final bool isSelected = _selectedTableId == table.id;

    // Dimensi Stack Pembungkus (untuk menampung overlay badge di top-right)
    final double padLeft = 0;
    final double padTop = 10;
    final double mainWidth = table.width;
    final double mainHeight = table.height;

    final double stackWidth = mainWidth + 10;
    final double stackHeight = mainHeight + 10;

    return Positioned(
      left: table.x - 5, // Kurangi offset untuk meletakkan wadah Stack
      top: table.y - 10,
      width: stackWidth,
      height: stackHeight,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isFilteredOut ? 0.15 : 1.0,
        child: IgnorePointer(
          ignoring: isFilteredOut,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Shape Utama Meja
              Positioned(
                left: padLeft,
                top: padTop,
                width: mainWidth,
                height: mainHeight,
                child: GestureDetector(
                  onTap: () {
                    if (table.isUsed) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.error500,
                          content: Text(
                            '${table.name} is currently used by ${table.customerName}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        _selectedTableId = isSelected ? null : table.id;
                      });
                    }
                  },
                  child: Container(
                    decoration: _buildTableDecoration(table, isSelected),
                    child: ClipPath(
                      clipper: _getTableClipper(table.shape),
                      child: Stack(
                        children: [
                          // Hashing Pattern untuk meja terpakai
                          if (table.isUsed && !isSelected)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: DiagonalStripesPainter(
                                  color: AppColors.neutral300,
                                  stripeWidth: 2,
                                  gap: 5,
                                ),
                              ),
                            ),
                          
                          // Nomor Meja
                          Center(
                            child: Text(
                              table.id.toString(),
                              style: AppTypography.bodyLBold.copyWith(
                                color: isSelected 
                                    ? AppColors.white 
                                    : (table.isUsed ? AppColors.neutral600 : AppColors.neutral800),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Badge Kapasitas di Pojok Kanan Atas
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.neutral900,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    table.capacity.toString(),
                    style: AppTypography.bodyXsRegular.copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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

  // Helper Dekorasi Kontainer Meja
  BoxDecoration _buildTableDecoration(TableModel table, bool isSelected) {
    Color bgColor = AppColors.white;
    Border border = Border.all(color: AppColors.neutral300, width: 1.5);

    if (isSelected) {
      bgColor = AppColors.primary500;
      border = Border.all(color: AppColors.primary500, width: 1.5);
    }

    return BoxDecoration(
      color: bgColor,
      shape: table.shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: table.shape != 'circle' ? BorderRadius.circular(12) : null,
      border: border,
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: AppColors.primary500.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
          : [],
    );
  }

  // Custom Clipper untuk memotong garis arsir di dalam bentuk meja
  CustomClipper<Path> _getTableClipper(String shape) {
    if (shape == 'circle') {
      return _CircleClipper();
    } else {
      return _RoundedRectClipper(radius: 12);
    }
  }
}

// --- CLIPPER DEFINITIONS ---

class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _RoundedRectClipper extends CustomClipper<Path> {
  final double radius;
  _RoundedRectClipper({required this.radius});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    ));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// --- PAINTER DEFINITIONS ---

// 1. Grid Pola Titik
class DottedGridPainter extends CustomPainter {
  final double dotRadius;
  final double spacing;
  final Color dotColor;

  DottedGridPainter({
    this.dotRadius = 1.0,
    this.spacing = 15.0,
    this.dotColor = const Color(0xFFD8D7D7), // AppColors.neutral300
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 2. Arsir Garis Diagonal (Used State)
class DiagonalStripesPainter extends CustomPainter {
  final Color color;
  final double stripeWidth;
  final double gap;

  DiagonalStripesPainter({
    required this.color,
    this.stripeWidth = 2,
    this.gap = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stripeWidth
      ..style = PaintingStyle.stroke;

    final double step = stripeWidth + gap;
    // Gambar garis diagonal dari kiri-atas ke kanan-bawah
    for (double i = -size.height; i < size.width; i += step) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
