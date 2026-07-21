import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

// Model data untuk Meja
class TableModel {
  final String id;
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
  final String floor; // 'Lantai 1', 'Lantai 2', 'Lantai 3'
  final int rotationAngle; // 0, 90, 180, 270

  const TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.shape,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.isUsed,
    this.orderId,
    this.customerName,
    this.price,
    this.floor = 'Lantai 1',
    this.rotationAngle = 0,
  });
}

class PosTablesScreen extends StatefulWidget {
  const PosTablesScreen({super.key});

  @override
  State<PosTablesScreen> createState() => _PosTablesScreenState();
}

class _PosTablesScreenState extends State<PosTablesScreen> {
  // TransformationController for InteractiveViewer scaling
  final TransformationController _transformationController = TransformationController();

  // Active Floor layout filter
  String _selectedFloor = 'Lantai 1'; // 'Lantai 1', 'Lantai 2', 'Lantai 3'

  // Cashier coordinates per floor (same as layout editor)
  double _cashierX1 = 440.0, _cashierY1 = 200.0;
  double _cashierX2 = 440.0, _cashierY2 = 200.0;
  double _cashierX3 = 440.0, _cashierY3 = 200.0;

  double get _cashierX {
    if (_selectedFloor == 'Lantai 2') return _cashierX2;
    if (_selectedFloor == 'Lantai 3') return _cashierX3;
    return _cashierX1;
  }
  
  double get _cashierY {
    if (_selectedFloor == 'Lantai 2') return _cashierY2;
    if (_selectedFloor == 'Lantai 3') return _cashierY3;
    return _cashierY1;
  }

  // Mock Data Meja matching layout editor instances exactly
  final List<TableModel> _tables = const [
    // --- LANTAI 1 ---
    // Circles (2 seats)
    TableModel(id: 'T1', name: '01', capacity: 2, shape: 'circle', x: 80, y: 100, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T2', name: '02', capacity: 2, shape: 'circle', x: 170, y: 100, width: 50, height: 50, isUsed: true, orderId: 'Order #0293E10', customerName: 'Emily Brown', price: 245000, floor: 'Lantai 1'),
    TableModel(id: 'T3', name: '03', capacity: 2, shape: 'circle', x: 260, y: 100, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T4', name: '04', capacity: 2, shape: 'circle', x: 350, y: 100, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),

    // Squares (4 seats)
    TableModel(id: 'T5', name: '05', capacity: 4, shape: 'square', x: 80, y: 200, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T6', name: '06', capacity: 4, shape: 'square', x: 170, y: 200, width: 50, height: 50, isUsed: true, orderId: 'Order #201OB99', customerName: 'Michael Johnson', price: 345000, floor: 'Lantai 1'),
    TableModel(id: 'T7', name: '07', capacity: 4, shape: 'square', x: 260, y: 200, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T8', name: '08', capacity: 4, shape: 'square', x: 350, y: 200, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),

    // Middle Squares (4 seats)
    TableModel(id: 'T9', name: '09', capacity: 4, shape: 'square', x: 80, y: 320, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T10', name: '10', capacity: 4, shape: 'square', x: 170, y: 320, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T11', name: '11', capacity: 4, shape: 'square', x: 260, y: 320, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T12', name: '12', capacity: 4, shape: 'square', x: 350, y: 320, width: 50, height: 50, isUsed: true, orderId: 'Order #883AD90', customerName: 'Sophia Williams', price: 189000, floor: 'Lantai 1'),

    // Long Rectangles (6 seats)
    TableModel(id: 'T13', name: '13', capacity: 6, shape: 'rectangle', x: 580, y: 200, width: 110, height: 60, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T14', name: '14', capacity: 6, shape: 'rectangle', x: 580, y: 320, width: 110, height: 60, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T15', name: '15', capacity: 6, shape: 'rectangle', x: 580, y: 440, width: 110, height: 60, isUsed: true, orderId: 'Order #332FF88', customerName: 'Jack Reacher', price: 760000, floor: 'Lantai 1'),

    // Bottom Circles (2 seats)
    TableModel(id: 'T16', name: '16', capacity: 2, shape: 'circle', x: 80, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T17', name: '17', capacity: 2, shape: 'circle', x: 170, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T18', name: '18', capacity: 2, shape: 'circle', x: 260, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T19', name: '19', capacity: 2, shape: 'circle', x: 350, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
    TableModel(id: 'T20', name: '20', capacity: 2, shape: 'circle', x: 440, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),

    // --- LANTAI 2 ---
    TableModel(id: 'T21', name: '21', capacity: 2, shape: 'circle', x: 100, y: 150, width: 50, height: 50, isUsed: false, floor: 'Lantai 2'),
    TableModel(id: 'T22', name: '22', capacity: 2, shape: 'circle', x: 200, y: 150, width: 50, height: 50, isUsed: true, orderId: 'Order #L2O01', customerName: 'Bruce Wayne', price: 145000, floor: 'Lantai 2'),
    TableModel(id: 'T23', name: '23', capacity: 2, shape: 'circle', x: 300, y: 150, width: 50, height: 50, isUsed: false, floor: 'Lantai 2'),
    TableModel(id: 'T24', name: '24', capacity: 4, shape: 'square', x: 100, y: 250, width: 50, height: 50, isUsed: false, floor: 'Lantai 2'),
    TableModel(id: 'T25', name: '25', capacity: 4, shape: 'square', x: 200, y: 250, width: 50, height: 50, isUsed: false, floor: 'Lantai 2'),
    TableModel(id: 'T26', name: '26', capacity: 4, shape: 'square', x: 300, y: 250, width: 50, height: 50, isUsed: true, orderId: 'Order #L2O02', customerName: 'Clark Kent', price: 290000, floor: 'Lantai 2'),
    TableModel(id: 'T27', name: '27', capacity: 6, shape: 'rectangle', x: 500, y: 200, width: 110, height: 60, isUsed: false, floor: 'Lantai 2'),
    TableModel(id: 'T28', name: '28', capacity: 6, shape: 'rectangle', x: 500, y: 320, width: 110, height: 60, isUsed: false, floor: 'Lantai 2'),
    TableModel(id: 'T29', name: '29', capacity: 2, shape: 'circle', x: 100, y: 400, width: 50, height: 50, isUsed: false, floor: 'Lantai 2'),
    TableModel(id: 'T30', name: '30', capacity: 2, shape: 'circle', x: 200, y: 400, width: 50, height: 50, isUsed: false, floor: 'Lantai 2'),

    // --- LANTAI 3 ---
    TableModel(id: 'T31', name: '31', capacity: 2, shape: 'circle', x: 150, y: 120, width: 50, height: 50, isUsed: false, floor: 'Lantai 3'),
    TableModel(id: 'T32', name: '32', capacity: 2, shape: 'circle', x: 250, y: 120, width: 50, height: 50, isUsed: false, floor: 'Lantai 3'),
    TableModel(id: 'T33', name: '33', capacity: 4, shape: 'square', x: 150, y: 220, width: 50, height: 50, isUsed: false, floor: 'Lantai 3'),
    TableModel(id: 'T34', name: '34', capacity: 4, shape: 'square', x: 250, y: 220, width: 50, height: 50, isUsed: true, orderId: 'Order #L3O01', customerName: 'Diana Prince', price: 95000, floor: 'Lantai 3'),
    TableModel(id: 'T35', name: '35', capacity: 6, shape: 'rectangle', x: 450, y: 180, width: 110, height: 60, isUsed: false, floor: 'Lantai 3'),
    TableModel(id: 'T36', name: '36', capacity: 6, shape: 'rectangle', x: 450, y: 300, width: 110, height: 60, isUsed: false, floor: 'Lantai 3'),
    TableModel(id: 'T37', name: '37', capacity: 4, shape: 'square', x: 150, y: 340, width: 50, height: 50, isUsed: false, floor: 'Lantai 3'),
    TableModel(id: 'T38', name: '38', capacity: 4, shape: 'square', x: 250, y: 340, width: 50, height: 50, isUsed: false, floor: 'Lantai 3'),
    TableModel(id: 'T39', name: '39', capacity: 2, shape: 'circle', x: 150, y: 460, width: 50, height: 50, isUsed: false, floor: 'Lantai 3'),
    TableModel(id: 'T40', name: '40', capacity: 2, shape: 'circle', x: 250, y: 460, width: 50, height: 50, isUsed: false, floor: 'Lantai 3'),
  ];

  // State Management Screen
  String? _selectedTableId = 'T5'; // Table 5 selected by default
  String _activeListTab = 'All Table'; // 'All Table', 'Available', 'Used'
  String _searchQuery = '';
  String _selectedCapacityFilter = 'All Capacity'; // 'All Capacity', '2 Seats', '4 Seats', '6 Seats'

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Zoom out canvas visually to match editor scale initially
    _transformationController.value = Matrix4.diagonal3Values(0.6, 0.6, 1.0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter tables for this floor
    final List<TableModel> floorTablesList = _tables.where((t) => t.floor == _selectedFloor).toList();

    // 2. Filter list of tables for Left Panel
    final filteredListTables = floorTablesList.where((table) {
      // Filter by Search
      final matchesSearch = table.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filter by Tab
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
                              // Header Peta (Legend & Dropdown Kapasitas)
                              Positioned(
                                top: 20,
                                left: 24,
                                right: 24,
                                child: _buildMapHeader(),
                              ),

                              // Interactive Tables Canvas Stack (Scrollable/Zoomable 4000x4000 canvas matching layout editor)
                              Positioned.fill(
                                child: InteractiveViewer(
                                  transformationController: _transformationController,
                                  boundaryMargin: const EdgeInsets.all(2500),
                                  minScale: 0.1,
                                  maxScale: 1.5,
                                  child: SizedBox(
                                    width: 4000,
                                    height: 4000,
                                    child: Stack(
                                      children: [
                                        // Subtle Dotted Grid Background (zooms & moves inside child container)
                                        const Positioned.fill(
                                          child: _DottedGridBackground(),
                                        ),

                                        // Cashier Block
                                        _buildCashierBlock(),

                                        // Map Tables for selected floor
                                        ...floorTablesList.map((table) => _buildMapTableItem(table)),
                                      ],
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
              // Search table name bar (perfectly centered icon & text)
              Container(
                width: 160,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.neutral300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.search, size: 18, color: AppColors.neutral500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                        decoration: InputDecoration(
                          hintText: 'Search table...',
                          hintStyle: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral400),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Floor selector dropdown button
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.neutral300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFloor,
                    dropdownColor: AppColors.white,
                    style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800, fontWeight: FontWeight.bold),
                    items: ['Lantai 1', 'Lantai 2', 'Lantai 3'].map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item, style: const TextStyle(color: AppColors.neutral800)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedFloor = val;
                          _selectedTableId = null; // reset selection
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                  table.price != null ? 'Rp ' + table.price!.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.') : 'Rp 0',
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neutral300),
          ),
          child: Row(
            children: [
              _buildLegendItem('Available', const Color(0xFFFFFFFF), border: AppColors.neutral400),
              const SizedBox(width: 16),
              _buildLegendItem('Used', Colors.transparent, isStriped: true),
              const SizedBox(width: 16),
              _buildLegendItem('Selected', AppColors.primary500),
            ],
          ),
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
              dropdownColor: AppColors.white,
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
                  child: Text(value, style: const TextStyle(color: AppColors.neutral800)),
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
      left: _cashierX,
      top: _cashierY,
      width: 50,
      height: 120,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          'CASHIER',
          style: AppTypography.bodyXsRegular.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
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
                              table.name,
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

// Custom Painter untuk Menggambar Pola Garis Diagonal (Arsir)
class DiagonalStripesPainter extends CustomPainter {
  final Color color;
  final double stripeWidth;
  final double gap;

  DiagonalStripesPainter({
    required this.color,
    this.stripeWidth = 2.0,
    this.gap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = stripeWidth
      ..style = PaintingStyle.stroke;

    final double step = stripeWidth + gap;
    // Gambar garis diagonal dari kiri-bawah ke kanan-atas
    for (double i = -size.height; i < size.width; i += step) {
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Clipper Lingkaran
class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Clipper Rounded Rectangle
class _RoundedRectClipper extends CustomClipper<Path> {
  final double radius;
  _RoundedRectClipper({required this.radius});

  @override
  Path getClip(Size size) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Painter to draw a clean dotted grid background for layout alignment
class _DottedGridBackground extends StatelessWidget {
  const _DottedGridBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.neutral300
      ..strokeWidth = 1.0;

    const double gap = 20.0;
    
    // Draw horizontal/vertical dots
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
