import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/payment_modal.dart';
import '../widgets/payment_success_modal.dart';
import 'pos_dashboard_screen.dart';

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
  final List<OrderItem>? items;

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
    this.items,
  });

  TableModel copyWith({
    bool? isUsed,
    String? orderId,
    String? customerName,
    double? price,
    List<OrderItem>? items,
  }) {
    return TableModel(
      id: id,
      name: name,
      capacity: capacity,
      shape: shape,
      x: x,
      y: y,
      width: width,
      height: height,
      isUsed: isUsed ?? this.isUsed,
      orderId: isUsed == false ? null : (orderId ?? this.orderId),
      customerName: isUsed == false ? null : (customerName ?? this.customerName),
      price: isUsed == false ? null : (price ?? this.price),
      floor: floor,
      rotationAngle: rotationAngle,
      items: isUsed == false ? null : (items ?? this.items),
    );
  }
}

class PosTablesScreen extends StatefulWidget {
  const PosTablesScreen({super.key});

  @override
  State<PosTablesScreen> createState() => _PosTablesScreenState();
}

class _PosTablesScreenState extends State<PosTablesScreen> {
  final TransformationController _transformationController = TransformationController();

  // Active Filters
  String _selectedFloor = 'Lantai 1'; // 'Lantai 1', 'Lantai 2', 'Lantai 3'
  String _selectedStatusFilter = 'All Table'; // 'All Table', 'Available', 'Occupied'
  String _selectedCapacityFilter = 'All Capacity'; // 'All Capacity', '2 Seats', '4 Seats', '6 Seats'
  String _selectedTypeFilter = 'All Type'; // 'All Type', 'Circle', 'Square', 'Rectangle'
  String _searchQuery = '';

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

  // Stateful List Meja
  late List<TableModel> _tablesList;
  String? _selectedTableId;

  @override
  void initState() {
    super.initState();
    _tablesList = _generateInitialTables();
  }

  List<TableModel> _generateInitialTables() {
    return [
      // --- LANTAI 1 ---
      const TableModel(id: 'T1', name: '01', capacity: 2, shape: 'circle', x: 80, y: 100, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      TableModel(
        id: 'T2',
        name: '02',
        capacity: 2,
        shape: 'circle',
        x: 170,
        y: 100,
        width: 50,
        height: 50,
        isUsed: true,
        orderId: 'Order #0293E10',
        customerName: 'Emily Brown',
        price: 245000,
        floor: 'Lantai 1',
        items: [
          OrderItem(product: const Product(name: 'Deluxe Crispy Burger', price: 45000, category: 'Burger', icon: Icons.lunch_dining_outlined), quantity: 2),
          OrderItem(product: const Product(name: 'Combo Drumstick', price: 55000, category: 'Fried Chicken', icon: Icons.restaurant_outlined), quantity: 2),
          OrderItem(product: const Product(name: 'Chocolate Milkshake', price: 22000, category: 'Drink', icon: Icons.local_drink_outlined), quantity: 2),
        ],
      ),
      const TableModel(id: 'T3', name: '03', capacity: 2, shape: 'circle', x: 260, y: 100, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T4', name: '04', capacity: 2, shape: 'circle', x: 350, y: 100, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),

      const TableModel(id: 'T5', name: '05', capacity: 4, shape: 'square', x: 80, y: 200, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      TableModel(
        id: 'T6',
        name: '06',
        capacity: 4,
        shape: 'square',
        x: 170,
        y: 200,
        width: 50,
        height: 50,
        isUsed: true,
        orderId: 'Order #201OB99',
        customerName: 'Michael Johnson',
        price: 345000,
        floor: 'Lantai 1',
        items: [
          OrderItem(product: const Product(name: 'Double Cheeseburger', price: 48000, category: 'Burger', icon: Icons.lunch_dining_outlined), quantity: 4),
          OrderItem(product: const Product(name: 'Coca Cola', price: 12000, category: 'Drink', icon: Icons.local_drink_outlined), quantity: 4),
          OrderItem(product: const Product(name: '3 Cheese Wings', price: 28000, category: 'Fried Chicken', icon: Icons.restaurant_outlined), quantity: 3),
        ],
      ),
      const TableModel(id: 'T7', name: '07', capacity: 4, shape: 'square', x: 260, y: 200, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T8', name: '08', capacity: 4, shape: 'square', x: 350, y: 200, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),

      const TableModel(id: 'T9', name: '09', capacity: 4, shape: 'square', x: 80, y: 320, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T10', name: '10', capacity: 4, shape: 'square', x: 170, y: 320, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T11', name: '11', capacity: 4, shape: 'square', x: 260, y: 320, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      TableModel(
        id: 'T12',
        name: '12',
        capacity: 4,
        shape: 'square',
        x: 350,
        y: 320,
        width: 50,
        height: 50,
        isUsed: true,
        orderId: 'Order #883AD90',
        customerName: 'Sophia Williams',
        price: 189000,
        floor: 'Lantai 1',
        items: [
          OrderItem(product: const Product(name: 'Special Crispy Burger', price: 38000, category: 'Burger', icon: Icons.lunch_dining_outlined), quantity: 3),
          OrderItem(product: const Product(name: 'Cappuccino', price: 25000, category: 'Coffee', icon: Icons.coffee_outlined), quantity: 3),
        ],
      ),

      const TableModel(id: 'T13', name: '13', capacity: 6, shape: 'rectangle', x: 580, y: 200, width: 110, height: 60, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T14', name: '14', capacity: 6, shape: 'rectangle', x: 580, y: 320, width: 110, height: 60, isUsed: false, floor: 'Lantai 1'),
      TableModel(
        id: 'T15',
        name: '15',
        capacity: 6,
        shape: 'rectangle',
        x: 580,
        y: 440,
        width: 110,
        height: 60,
        isUsed: true,
        orderId: 'Order #332FF88',
        customerName: 'Jack Reacher',
        price: 760000,
        floor: 'Lantai 1',
        items: [
          OrderItem(product: const Product(name: 'Double Cheeseburger', price: 48000, category: 'Burger', icon: Icons.lunch_dining_outlined), quantity: 6),
          OrderItem(product: const Product(name: 'Combo Drumstick', price: 55000, category: 'Fried Chicken', icon: Icons.restaurant_outlined), quantity: 6),
          OrderItem(product: const Product(name: 'Sprite', price: 12000, category: 'Drink', icon: Icons.local_drink_outlined), quantity: 6),
        ],
      ),

      const TableModel(id: 'T16', name: '16', capacity: 2, shape: 'circle', x: 80, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T17', name: '17', capacity: 2, shape: 'circle', x: 170, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T18', name: '18', capacity: 2, shape: 'circle', x: 260, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T19', name: '19', capacity: 2, shape: 'circle', x: 350, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),
      const TableModel(id: 'T20', name: '20', capacity: 2, shape: 'circle', x: 440, y: 440, width: 50, height: 50, isUsed: false, floor: 'Lantai 1'),

      // --- LANTAI 2 ---
      const TableModel(id: 'T21', name: '21', capacity: 2, shape: 'circle', x: 100, y: 150, width: 50, height: 50, isUsed: false, floor: 'Lantai 2'),
      const TableModel(id: 'T22', name: '22', capacity: 4, shape: 'square', x: 200, y: 150, width: 50, height: 50, isUsed: false, floor: 'Lantai 2'),

      // --- LANTAI 3 ---
      const TableModel(id: 'T23', name: '23', capacity: 6, shape: 'rectangle', x: 150, y: 200, width: 110, height: 60, isUsed: false, floor: 'Lantai 3'),
    ];
  }

  void _freeTable(String tableId) {
    setState(() {
      final idx = _tablesList.indexWhere((t) => t.id == tableId);
      if (idx != -1) {
        _tablesList[idx] = _tablesList[idx].copyWith(isUsed: false);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary500,
        content: Text('Table reset to Available!'),
      ),
    );
  }

  String _formatRupiah(double amount) {
    int value = amount.toInt();
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
    // Filter list meja
    List<TableModel> filteredTables = _tablesList.where((t) {
      if (t.floor != _selectedFloor) return false;

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = t.name.toLowerCase().contains(query);
        final matchCust = (t.customerName ?? '').toLowerCase().contains(query);
        if (!matchName && !matchCust) return false;
      }

      if (_selectedStatusFilter == 'Available' && t.isUsed) return false;
      if (_selectedStatusFilter == 'Occupied' && !t.isUsed) return false;

      if (_selectedCapacityFilter == '2 Seats' && t.capacity != 2) return false;
      if (_selectedCapacityFilter == '4 Seats' && t.capacity != 4) return false;
      if (_selectedCapacityFilter == '6 Seats' && t.capacity != 6) return false;

      if (_selectedTypeFilter == 'Circle' && t.shape != 'circle') return false;
      if (_selectedTypeFilter == 'Square' && t.shape != 'square') return false;
      if (_selectedTypeFilter == 'Rectangle' && t.shape != 'rectangle') return false;

      return true;
    }).toList();

    // Floor layout canvas tables (hanya berdasarkan lantai yang dipilih)
    final floorTables = _tablesList.where((t) => t.floor == _selectedFloor).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Select Table'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: _buildAppBarActions(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Sidebar Kiri (Floating Card Panel untuk List Table)
              SizedBox(
                width: 320,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.neutral200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Header List Meja
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        color: AppColors.neutral50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tables List (${filteredTables.length})',
                              style: AppTypography.bodyMBold.copyWith(
                                color: AppColors.neutral900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _selectedFloor,
                              style: AppTypography.bodyXsRegular.copyWith(
                                color: AppColors.primary600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.neutral200),

                      // List Meja Scrollable
                      Expanded(
                        child: _buildTablesListView(filteredTables),
                      ),

                      // Bottom Confirm Selection Button (jika meja kosong dipilih)
                      if (_selectedTableId != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                final selTable = _tablesList.firstWhere((t) => t.id == _selectedTableId);
                                Navigator.pop(context, 'Table ${selTable.name}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary500,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Confirm Selection (${_tablesList.firstWhere((t) => t.id == _selectedTableId).name})',
                                style: AppTypography.bodyMBold.copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 24),

              // 2. Main Area (Floating Card Canvas Layout)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.neutral200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Map Header Toolbar (Legend & Status)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        color: AppColors.white,
                        child: _buildMapHeader(),
                      ),
                      const Divider(height: 1, color: AppColors.neutral200),

                      // Layout Canvas Floor
                      Expanded(
                        child: Container(
                          color: const Color(0xFFF8FAFC),
                          child: ClipRect(
                            child: InteractiveViewer(
                              transformationController: _transformationController,
                              minScale: 0.5,
                              maxScale: 2.5,
                              boundaryMargin: const EdgeInsets.all(400),
                              child: Container(
                                width: 1200,
                                height: 800,
                                color: const Color(0xFFF8FAFC),
                                child: Stack(
                                  children: [
                                    // Cashier Desk
                                    _buildCashierBlock(),

                                    // List Meja di Canvas
                                    ...floorTables.map((table) => _buildMapTableItem(table)),
                                  ],
                                ),
                              ),
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
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      // 1. Search Table
      Center(
        child: Container(
          width: 160,
          height: 38,
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
      ),
      const SizedBox(width: 8),

      // 2. Floor Filter Dropdown
      Center(
        child: _buildDropdownFilter(
          value: _selectedFloor,
          items: ['Lantai 1', 'Lantai 2', 'Lantai 3'],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedFloor = val;
                _selectedTableId = null;
              });
            }
          },
        ),
      ),
      const SizedBox(width: 8),

      // 3. Status Filter Dropdown
      Center(
        child: _buildDropdownFilter(
          value: _selectedStatusFilter,
          items: ['All Table', 'Available', 'Occupied'],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedStatusFilter = val;
              });
            }
          },
        ),
      ),
      const SizedBox(width: 8),

      // 4. Capacity Filter Dropdown
      Center(
        child: _buildDropdownFilter(
          value: _selectedCapacityFilter,
          items: ['All Capacity', '2 Seats', '4 Seats', '6 Seats'],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedCapacityFilter = val;
              });
            }
          },
        ),
      ),
      const SizedBox(width: 8),

      // 5. Type Filter Dropdown
      Center(
        child: _buildDropdownFilter(
          value: _selectedTypeFilter,
          items: ['All Type', 'Circle', 'Square', 'Rectangle'],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedTypeFilter = val;
              });
            }
          },
        ),
      ),
      const SizedBox(width: 24),
    ];
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral300, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.white,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.neutral600, size: 18),
          style: AppTypography.bodyXsRegular.copyWith(
            color: AppColors.neutral800,
            fontWeight: FontWeight.bold,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String itemValue) {
            return DropdownMenuItem<String>(
              value: itemValue,
              child: Text(itemValue),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTablesListView(List<TableModel> listTables) {
    if (listTables.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.table_restaurant_outlined, size: 40, color: AppColors.neutral400),
            const SizedBox(height: 8),
            Text(
              'No Tables Found',
              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: listTables.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.neutral100),
      itemBuilder: (context, index) {
        final table = listTables[index];
        final bool isSelected = _selectedTableId == table.id;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          onTap: () {
            if (table.isUsed) {
              _showOccupiedTableModal(table);
            } else {
              setState(() {
                _selectedTableId = (isSelected) ? null : table.id;
              });
            }
          },
          leading: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: table.isUsed ? const Color(0xFFFF5630) : AppColors.primary500,
            ),
          ),
          title: Text(
            'Table ${table.name}',
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
                      color: const Color(0xFFFF5630),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Text(
                  'Available (${table.capacity} Seats)',
                  style: AppTypography.bodyXsRegular.copyWith(color: AppColors.primary600),
                ),
          trailing: table.isUsed
              ? Text(
                  _formatRupiah(table.price ?? 0),
                  style: AppTypography.bodyMBold.copyWith(
                    color: const Color(0xFFFF5630),
                  ),
                )
              : const Icon(Icons.chevron_right, color: AppColors.neutral400, size: 20),
          tileColor: isSelected ? AppColors.primary50.withValues(alpha: 0.5) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }

  Widget _buildMapHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
              _buildLegendItem('Occupied', const Color(0xFFFFF1F0), border: const Color(0xFFFF5630)),
              const SizedBox(width: 16),
              _buildLegendItem('Selected', AppColors.primary500),
            ],
          ),
        ),

        Text(
          '$_selectedFloor • ${ _tablesList.where((t) => t.floor == _selectedFloor && t.isUsed).length } Occupied',
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, {Color? border}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border ?? color),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.bodyXsRegular.copyWith(
            color: AppColors.neutral700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

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

  Widget _buildMapTableItem(TableModel table) {
    bool isFilteredOut = false;
    
    // Status filter
    if (_selectedStatusFilter == 'Available' && table.isUsed) isFilteredOut = true;
    if (_selectedStatusFilter == 'Occupied' && !table.isUsed) isFilteredOut = true;

    // Capacity filter
    if (_selectedCapacityFilter == '2 Seats' && table.capacity != 2) isFilteredOut = true;
    if (_selectedCapacityFilter == '4 Seats' && table.capacity != 4) isFilteredOut = true;
    if (_selectedCapacityFilter == '6 Seats' && table.capacity != 6) isFilteredOut = true;

    // Type filter
    if (_selectedTypeFilter == 'Circle' && table.shape != 'circle') isFilteredOut = true;
    if (_selectedTypeFilter == 'Square' && table.shape != 'square') isFilteredOut = true;
    if (_selectedTypeFilter == 'Rectangle' && table.shape != 'rectangle') isFilteredOut = true;

    // Search query filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      final matchName = table.name.toLowerCase().contains(query);
      final matchCust = (table.customerName ?? '').toLowerCase().contains(query);
      if (!matchName && !matchCust) isFilteredOut = true;
    }

    final bool isSelected = _selectedTableId == table.id;

    final double padLeft = 0;
    final double padTop = 10;
    final double mainWidth = table.width;
    final double mainHeight = table.height;

    final double stackWidth = mainWidth + 10;
    final double stackHeight = mainHeight + 10;

    return Positioned(
      left: table.x - 5,
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
              // Main Table Shape Container
              Positioned(
                left: padLeft,
                top: padTop,
                width: mainWidth,
                height: mainHeight,
                child: GestureDetector(
                  onTap: () {
                    if (table.isUsed) {
                      _showOccupiedTableModal(table);
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
                      child: Center(
                        child: Text(
                          table.name,
                          style: AppTypography.bodyMBold.copyWith(
                            color: isSelected ? AppColors.white : AppColors.neutral900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Top-Right Capacity Badge overlay (Matching reference image)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    table.capacity.toString(),
                    style: const TextStyle(
                      color: Colors.white,
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

  BoxDecoration _buildTableDecoration(TableModel table, bool isSelected) {
    if (isSelected) {
      return BoxDecoration(
        color: AppColors.primary500,
        shape: table.shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: table.shape != 'circle' ? BorderRadius.circular(8) : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary500.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      );
    }

    if (table.isUsed) {
      return BoxDecoration(
        color: const Color(0xFFFFF1F0), // Soft Coral Tint (Merah Soft)
        shape: table.shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: table.shape != 'circle' ? BorderRadius.circular(8) : null,
        border: Border.all(color: const Color(0xFFFF5630), width: 2.0), // Vibrant Coral Outline
      );
    }

    return BoxDecoration(
      color: AppColors.white,
      shape: table.shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: table.shape != 'circle' ? BorderRadius.circular(8) : null,
      border: Border.all(color: AppColors.neutral400, width: 1.5),
    );
  }

  CustomClipper<Path> _getTableClipper(String shape) {
    return _TableClipper(shape);
  }

  void _showOccupiedTableModal(TableModel table) {
    final List<OrderItem> items = table.items ?? [
      OrderItem(product: const Product(name: 'Deluxe Crispy Burger', price: 45000, category: 'Burger', icon: Icons.lunch_dining_outlined), quantity: 2),
      OrderItem(product: const Product(name: 'Sprite', price: 12000, category: 'Drink', icon: Icons.local_drink_outlined), quantity: 2),
    ];

    final double totalPrice = table.price ?? items.fold(0.0, (sum, i) => sum + (i.product.price * i.quantity));
    final double subtotal = totalPrice / 1.03;
    final double tax = totalPrice - subtotal;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 460,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5630).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.table_restaurant, color: Color(0xFFFF5630), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Table ${table.name}',
                            style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${table.floor} • Occupied',
                            style: AppTypography.bodyXsRegular.copyWith(color: const Color(0xFFFF5630), fontWeight: FontWeight.bold),
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

              // Customer & Order Info Card
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
                          'Customer: ${table.customerName ?? "Guest"}',
                          style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral900),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          table.orderId ?? "#201OE00",
                          style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Text(
                      _formatRupiah(totalPrice),
                      style: AppTypography.h4Bold.copyWith(color: AppColors.primary600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Active Items List
              Text(
                'Ordered Items',
                style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (c, i) => const Divider(height: 12, thickness: 0.5, color: AppColors.neutral200),
                  itemBuilder: (c, i) {
                    final item = items[i];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary500.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${item.quantity}x',
                                style: AppTypography.bodyXsRegular.copyWith(color: AppColors.primary600, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.product.name,
                              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                            ),
                          ],
                        ),
                        Text(
                          _formatRupiah(item.product.price * item.quantity),
                          style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900, fontWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 3 Action Buttons: Edit / Tambah Pesanan, Proses Pembayaran, Batalkan Pesanan
              Column(
                children: [
                  // 1. Edit / Tambah Pesanan (Primary Green Button)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PosDashboardScreen(
                            initialCustomer: table.customerName ?? 'Customer',
                            initialTable: 'Table ${table.name}',
                            initialOrderId: table.orderId,
                            initialCartItems: items,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      backgroundColor: AppColors.primary500,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.edit_note, color: Colors.white),
                    label: const Text(
                      'Edit / Tambah Pesanan',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 2. Proses Pembayaran & Batalkan Pesanan Row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            final Map<String, dynamic>? paymentResult = await showDialog<Map<String, dynamic>>(
                              context: context,
                              barrierDismissible: false,
                              builder: (c) => PaymentModal(
                                totalAmount: totalPrice,
                                subtotal: subtotal,
                                tax: tax,
                                discountAmount: 0.0,
                                isDineIn: true,
                                customerName: table.customerName ?? 'Guest',
                              ),
                            );

                            if (paymentResult != null && paymentResult['success'] == true) {
                              if (mounted) {
                                await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (c) => PaymentSuccessModal(
                                    method: paymentResult['method'] ?? 'Cash',
                                    total: totalPrice,
                                    paid: paymentResult['paidAmount'] ?? totalPrice,
                                    change: paymentResult['changeAmount'] ?? 0.0,
                                    subtotal: subtotal,
                                    discountAmount: 0.0,
                                    tax: tax,
                                    customerName: table.customerName ?? 'Guest',
                                    cartItems: items,
                                    isDineIn: true,
                                    tableName: 'Table ${table.name}',
                                  ),
                                );

                                _freeTable(table.id);
                              }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            side: const BorderSide(color: AppColors.primary500, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.payment, color: AppColors.primary500, size: 18),
                          label: const Text(
                            'Proses Pembayaran',
                            style: TextStyle(color: AppColors.primary500, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _confirmCancelTableOrder(table),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          side: const BorderSide(color: AppColors.error500),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Batalkan',
                          style: TextStyle(color: AppColors.error500, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCancelTableOrder(TableModel table) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.error500,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.cancel_outlined, color: AppColors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'Batalkan Pesanan Meja ${table.name}?',
                style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Pesanan ${table.orderId ?? ""} milik ${table.customerName ?? "pelanggan"} akan dibatalkan dan Meja ${table.name} akan kembali kosong (Available).',
                style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        _freeTable(table.id);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        backgroundColor: AppColors.error500,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
}

class _TableClipper extends CustomClipper<Path> {
  final String shape;
  _TableClipper(this.shape);

  @override
  Path getClip(Size size) {
    final path = Path();
    if (shape == 'circle') {
      path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    } else {
      path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(8),
      ));
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
