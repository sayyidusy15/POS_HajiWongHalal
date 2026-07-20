import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/pos_navigation_drawer.dart';

class TableEditorModel {
  final String id;
  String name;
  int capacity;
  double x;
  double y;
  double width;
  double height;
  String tableType; // 'Circle', 'Square', 'Rectangle'
  String status; // 'Available', 'Used'
  double? usedAmount;
  int rotationAngle; // 0, 90, 180, 270
  String floor; // 'Lantai 1', 'Lantai 2', 'Lantai 3'

  TableEditorModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.tableType,
    this.status = 'Available',
    this.usedAmount,
    this.rotationAngle = 0,
    this.floor = 'Lantai 1',
  });

  TableEditorModel copyWith({
    String? name,
    int? capacity,
    double? x,
    double? y,
    double? width,
    double? height,
    String? tableType,
    String? status,
    double? usedAmount,
    int? rotationAngle,
    String? floor,
  }) {
    return TableEditorModel(
      id: id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      tableType: tableType ?? this.tableType,
      status: status ?? this.status,
      usedAmount: usedAmount ?? this.usedAmount,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      floor: floor ?? this.floor,
    );
  }
}

class PosTablesEditorScreen extends StatefulWidget {
  const PosTablesEditorScreen({super.key});

  @override
  State<PosTablesEditorScreen> createState() => _PosTablesEditorScreenState();
}

class _PosTablesEditorScreenState extends State<PosTablesEditorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // TransformationController for visual canvas zoom and scale state
  final TransformationController _transformationController = TransformationController();
  
  // State variables
  bool _isEditMode = false;
  bool _showCashier = true;
  String _selectedTableId = '';
  
  // Active Floor layout
  String _selectedFloor = 'Lantai 1'; // 'Lantai 1', 'Lantai 2', 'Lantai 3'
  
  // Cashier coordinates per floor
  double _cashierX1 = 440.0, _cashierY1 = 200.0;
  double _cashierX2 = 440.0, _cashierY2 = 200.0;
  double _cashierX3 = 440.0, _cashierY3 = 200.0;

  double get _cashierX {
    if (_selectedFloor == 'Lantai 2') return _cashierX2;
    if (_selectedFloor == 'Lantai 3') return _cashierX3;
    return _cashierX1;
  }
  set _cashierX(double val) {
    if (_selectedFloor == 'Lantai 2') {
      _cashierX2 = val;
    } else if (_selectedFloor == 'Lantai 3') {
      _cashierX3 = val;
    } else {
      _cashierX1 = val;
    }
  }

  double get _cashierY {
    if (_selectedFloor == 'Lantai 2') return _cashierY2;
    if (_selectedFloor == 'Lantai 3') return _cashierY3;
    return _cashierY1;
  }
  set _cashierY(double val) {
    if (_selectedFloor == 'Lantai 2') {
      _cashierY2 = val;
    } else if (_selectedFloor == 'Lantai 3') {
      _cashierY3 = val;
    } else {
      _cashierY1 = val;
    }
  }
  
  // Search & Filtering State (View Mode)
  String _searchQuery = '';
  String _statusFilter = 'All Table'; // 'All Table', 'Available', 'Used'
  String _capacityFilter = 'All Capacity'; // 'All Capacity', '2', '4', '6', '8'
  String _typeFilter = 'All Type'; // 'All Type', 'Circle', 'Square', 'Rectangle'
  
  // Toast Notification state
  String _toastMessage = '';
  bool _toastVisible = false;
  bool _toastIsSuccess = true;

  // Tables State
  late List<TableEditorModel> _tables;

  @override
  void initState() {
    super.initState();
    _tables = _generateDefaultTables();
    // Start canvas with a zoomed-out scale of 0.7 to increase apparent canvas area size
    _transformationController.value = Matrix4.diagonal3Values(0.7, 0.7, 1.0);
  }

  // Formatting currency helper
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
    // 1. Filter by floor first
    List<TableEditorModel> floorTables = _tables.where((t) => t.floor == _selectedFloor).toList();

    // 2. Apply filters for List Pane & Highlight matching ones in the Visual Canvas
    List<TableEditorModel> filteredTables = floorTables;
    if (_searchQuery.isNotEmpty) {
      filteredTables = filteredTables.where((t) => t.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    if (_statusFilter != 'All Table') {
      filteredTables = filteredTables.where((t) => t.status == _statusFilter).toList();
    }
    if (_capacityFilter != 'All Capacity') {
      final int cap = int.tryParse(_capacityFilter) ?? 2;
      filteredTables = filteredTables.where((t) => t.capacity == cap).toList();
    }
    if (_typeFilter != 'All Type') {
      filteredTables = filteredTables.where((t) => t.tableType == _typeFilter).toList();
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Tables' : 'Table Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        leading: _isEditMode 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _handleCancelEdit,
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
        actions: _buildAppBarActions(),
      ),
      drawer: _isEditMode ? null : const PosNavigationDrawer(activeRoute: 'tables_editor'),
      body: Stack(
        children: [
          Column(
            children: [
              // 2. MAIN WORKSPACE (VIEW OR EDIT MODE Layout)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Panel Kiri: Daftar Meja (hanya muncul saat View Mode)
                      if (!_isEditMode) ...[
                        _buildLeftListPanel(filteredTables),
                        const SizedBox(width: 24),
                      ],
                      
                      // Area Kanan: Peta Visual Meja (Grid Canvas)
                      Expanded(
                        child: _buildRightVisualCanvas(filteredTables, floorTables),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. FLOAT TOAST NOTIFICATIONS overlay
          if (_toastVisible) _buildToastNotificationBanner(),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    // Floor dropdown button is visible in both view and edit modes
    Widget floorFilterWidget = Center(
      child: _buildDropdownFilter(
        value: _selectedFloor,
        items: ['Lantai 1', 'Lantai 2', 'Lantai 3'],
        onChanged: (val) {
          if (val != null) {
            setState(() {
              _selectedFloor = val;
              _selectedTableId = '';
            });
          }
        },
      ),
    );

    if (_isEditMode) {
      // Header for EDIT MODE
      return [
        floorFilterWidget,
        const SizedBox(width: 12),
        TextButton(
          onPressed: _showResetConfirmDialog,
          child: const Text(
            'Reset to default',
            style: TextStyle(color: AppColors.error500, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        // Show Cashier Toggle
        Center(
          child: Text(
            'Show Cashier',
            style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 6),
        Center(
          child: Switch(
            value: _showCashier,
            activeColor: AppColors.primary500,
            onChanged: (val) {
              setState(() {
                _showCashier = val;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        // + Add Table button
        Center(
          child: OutlinedButton.icon(
            onPressed: _showAddTableDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Table'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              side: const BorderSide(color: AppColors.neutral300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              foregroundColor: AppColors.neutral800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Cancel button
        Center(
          child: OutlinedButton(
            onPressed: _handleCancelEdit,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              side: const BorderSide(color: AppColors.neutral300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              foregroundColor: AppColors.neutral800,
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        // Save button
        Center(
          child: ElevatedButton(
            onPressed: _handleSaveEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(
              'Save',
              style: AppTypography.bodySRegular.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 24),
      ];
    } else {
      // Header for VIEW MODE
      return [
        // Search table name bar (perfectly centered icon & text)
        Center(
          child: Container(
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
        floorFilterWidget,
        const SizedBox(width: 8),
        // Status dropdown button
        Center(
          child: _buildDropdownFilter(
            value: _statusFilter,
            items: ['All Table', 'Available', 'Used'],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _statusFilter = val;
                });
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        // Capacity dropdown button
        Center(
          child: _buildDropdownFilter(
            value: _capacityFilter,
            items: ['All Capacity', '2', '4', '6', '8'],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _capacityFilter = val;
                });
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        // Type dropdown button
        Center(
          child: _buildDropdownFilter(
            value: _typeFilter,
            items: ['All Type', 'Circle', 'Square', 'Rectangle'],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _typeFilter = val;
                });
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        // Edit Layout button
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isEditMode = true;
                _selectedTableId = '';
              });
            },
            icon: const Icon(Icons.edit, size: 16, color: AppColors.white),
            label: const Text('Edit Layout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 24),
      ];
    }
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.neutral300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.white, // White dropdown menu popup background
          style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral800, fontWeight: FontWeight.bold),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: AppColors.neutral800)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLeftListPanel(List<TableEditorModel> filtered) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.neutral50,
            child: Text(
              'Table List (${_selectedFloor})',
              style: AppTypography.bodySMedium.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.neutral200),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No tables match filters.',
                      style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.neutral100),
                    itemBuilder: (context, index) {
                      final table = filtered[index];
                      final bool isUsed = table.status == 'Used';

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 5,
                          backgroundColor: isUsed ? AppColors.error500 : AppColors.primary500,
                        ),
                        title: Text(
                          'Table ${table.name}',
                          style: AppTypography.bodySRegular.copyWith(
                            color: AppColors.neutral800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: isUsed && table.usedAmount != null
                            ? Text(
                                _formatRupiah(table.usedAmount!),
                                style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                              )
                            : Text(
                                '${table.capacity} Seats',
                                style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral400),
                              ),
                        trailing: Icon(
                          table.tableType == 'Circle'
                              ? Icons.circle_outlined
                              : table.tableType == 'Rectangle'
                                  ? Icons.view_headline_outlined
                                  : Icons.crop_square_outlined,
                          size: 16,
                          color: AppColors.neutral400,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightVisualCanvas(List<TableEditorModel> filtered, List<TableEditorModel> floorTables) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // B. LEGEND (Only visible in View Mode, top-left overlay)
            if (!_isEditMode)
              Positioned(
                left: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.neutral300),
                  ),
                  child: Row(
                    children: [
                      _buildLegendDot(AppColors.primary500, 'Available'),
                      const SizedBox(width: 12),
                      _buildLegendDot(AppColors.error500, 'Used'),
                    ],
                  ),
                ),
              ),

            // C. INTERACTIVE TABLES CANVAS STACK (Massive 4000x4000 layout)
            InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(1000), // Massive margin so user can pan anywhere
              minScale: 0.1, // Zoom out extensively
              maxScale: 1.5,
              child: SizedBox(
                width: 4000,
                height: 4000,
                child: Stack(
                  children: [
                    // A. DOTTED GRID CANVAS BACKGROUND (Now moves/zooms inside the InteractiveViewer child)
                    const Positioned.fill(
                      child: _DottedGridBackground(),
                    ),

                    // Draggable Cashier block
                    if (_showCashier)
                      Positioned(
                        left: _cashierX,
                        top: _cashierY,
                        child: GestureDetector(
                          onPanUpdate: _isEditMode
                              ? (details) {
                                  setState(() {
                                    _cashierX += details.delta.dx;
                                    _cashierY += details.delta.dy;
                                    _cashierX = _cashierX.clamp(10.0, 3900.0);
                                    _cashierY = _cashierY.clamp(10.0, 3900.0);
                                  });
                                }
                              : null,
                          onTap: () {
                            if (_isEditMode) {
                              setState(() {
                                _selectedTableId = 'CASHIER';
                              });
                            }
                          },
                          child: MouseRegion(
                            cursor: _isEditMode ? SystemMouseCursors.grab : SystemMouseCursors.click,
                            child: Container(
                              width: 50,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(8),
                                border: (_isEditMode && _selectedTableId == 'CASHIER')
                                    ? Border.all(color: const Color(0xFF289656), width: 2.5)
                                    : null,
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
                          ),
                        ),
                      ),

                    // Render client tables for selected floor
                    ...floorTables.map((table) {
                      // Apply filter highlight state: dim if it doesn't match active search/filter options
                      final bool matchesFilter = filtered.any((t) => t.id == table.id);
                      final double opacity = matchesFilter ? 1.0 : 0.2;
                      final bool isSelected = _isEditMode && table.id == _selectedTableId;

                      // Display coordinates and dimensions dynamically
                      double drawWidth = table.width;
                      double drawHeight = table.height;
                      if (table.rotationAngle == 90 || table.rotationAngle == 270) {
                        drawWidth = table.height;
                        drawHeight = table.width;
                      }

                      return Positioned(
                        left: table.x,
                        top: table.y,
                        child: Opacity(
                          opacity: opacity,
                          child: GestureDetector(
                            onPanUpdate: _isEditMode
                                ? (details) {
                                    setState(() {
                                      table.x += details.delta.dx;
                                      table.y += details.delta.dy;
                                      // Constrain boundaries to canvas coordinates (extended sizes)
                                      table.x = table.x.clamp(10.0, 3900.0);
                                      table.y = table.y.clamp(10.0, 3900.0);
                                    });
                                  }
                                : null,
                            onTap: () {
                              if (_isEditMode) {
                                setState(() {
                                  _selectedTableId = table.id;
                                });
                              }
                            },
                            child: MouseRegion(
                              cursor: _isEditMode ? SystemMouseCursors.grab : SystemMouseCursors.click,
                              child: _buildTableShapeWidget(table, drawWidth, drawHeight, isSelected),
                            ),
                          ),
                        ),
                      );
                    }),

                    // D. FLOATING TOOLBAR (renders in Edit Mode directly above the highlighted table)
                    if (_isEditMode && _selectedTableId.isNotEmpty && _selectedTableId != 'CASHIER')
                      _buildFloatingToolbarOverlay(floorTables),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildTableShapeWidget(TableEditorModel table, double width, double height, bool isSelected) {
    final bool isUsed = table.status == 'Used';
    final Color borderColor = isSelected 
        ? const Color(0xFF289656) // Bright green select border
        : isUsed 
            ? AppColors.error500
            : AppColors.neutral300;
    
    final Color bgColor = isUsed 
        ? AppColors.error500.withValues(alpha: 0.08)
        : AppColors.white;

    final bool isCircle = table.tableType == 'Circle';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Core Table Container
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.5 : 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            table.name,
            style: AppTypography.bodyLBold.copyWith(
              color: AppColors.neutral800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Capacity Badge (top right corner)
        Positioned(
          right: -4,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B), // black grey badge
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${table.capacity}',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingToolbarOverlay(List<TableEditorModel> floorTables) {
    // Find the currently selected table in this floor's list
    final TableEditorModel? selectedTable = floorTables.firstWhere((t) => t.id == _selectedTableId, orElse: () => _tables.firstWhere((t) => t.id == _selectedTableId));
    if (selectedTable == null) return const SizedBox();

    double drawWidth = selectedTable.width;
    if (selectedTable.rotationAngle == 90 || selectedTable.rotationAngle == 270) {
      drawWidth = selectedTable.height;
    }

    // Position coordinates
    double toolbarX = selectedTable.x + (drawWidth / 2) - 60;
    double toolbarY = selectedTable.y - 48;
    
    // Clamp coordinates to remain visible inside canvas bounds
    toolbarX = toolbarX.clamp(10.0, 3900.0);
    toolbarY = toolbarY.clamp(10.0, 3920.0);

    return Positioned(
      left: toolbarX,
      top: toolbarY,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B), // Dark grey toolbar background
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. ROTATE ICON BUTTON
            _buildToolbarIcon(
              icon: Icons.rotate_right_outlined,
              tooltip: 'Rotate Table',
              onTap: () {
                setState(() {
                  selectedTable.rotationAngle = (selectedTable.rotationAngle + 90) % 360;
                });
              },
            ),
            const VerticalDivider(width: 12, thickness: 1, color: AppColors.neutral700),
            
            // 2. EDIT SETTINGS ICON BUTTON
            _buildToolbarIcon(
              icon: Icons.edit_outlined,
              tooltip: 'Edit Settings',
              onTap: () => _showEditTableSettingsDialog(selectedTable),
            ),
            const VerticalDivider(width: 12, thickness: 1, color: AppColors.neutral700),
            
            // 3. DELETE ICON BUTTON
            _buildToolbarIcon(
              icon: Icons.delete_outline,
              tooltip: 'Delete Table',
              color: AppColors.error500,
              onTap: () {
                setState(() {
                  _tables.removeWhere((t) => t.id == selectedTable.id);
                  _selectedTableId = '';
                });
                _showToastAlert('Table deleted successfully', success: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarIcon({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    Color color = AppColors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }

  Widget _buildToastNotificationBanner() {
    return Positioned(
      top: 24,
      right: 24,
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacity(
          opacity: _toastVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _toastIsSuccess ? const Color(0xFF289656) : AppColors.neutral800,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _toastIsSuccess ? Icons.check_circle_outline : Icons.info_outline,
                  color: AppColors.white,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  _toastMessage,
                  style: AppTypography.bodySRegular.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Toast trigger controller helper
  void _showToastAlert(String message, {bool success = true}) {
    setState(() {
      _toastMessage = message;
      _toastIsSuccess = success;
      _toastVisible = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _toastVisible = false;
        });
      }
    });
  }

  // Header Dialogs & Callbacks handlers
  void _handleCancelEdit() {
    setState(() {
      _isEditMode = false;
      _selectedTableId = '';
      _cashierX1 = 440.0; _cashierY1 = 200.0;
      _cashierX2 = 440.0; _cashierY2 = 200.0;
      _cashierX3 = 440.0; _cashierY3 = 200.0;
      _tables = _generateDefaultTables(); // Discard placements
    });
  }

  void _handleSaveEdit() {
    setState(() {
      _isEditMode = false;
      _selectedTableId = '';
    });
    _showToastAlert('Table layout saved successfully', success: true);
  }

  void _showResetConfirmDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            width: 400,
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
                  child: const Icon(Icons.refresh, color: AppColors.white, size: 28),
                ),
                const SizedBox(height: 16),
                Text(
                  'Reset Layout?',
                  style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to reset the layout to its default state? All custom placements will be lost.',
                  style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx, false);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.neutral300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          foregroundColor: AppColors.neutral800,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error500,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

    if (confirm == true) {
      setState(() {
        _tables = _generateDefaultTables();
        _selectedTableId = '';
        _cashierX1 = 440.0; _cashierY1 = 200.0;
        _cashierX2 = 440.0; _cashierY2 = 200.0;
        _cashierX3 = 440.0; _cashierY3 = 200.0;
      });
      _showToastAlert('Layout reset to default', success: false);
    }
  }

  void _showAddTableDialog() async {
    final TextEditingController nameController = TextEditingController();
    int capacityVal = 4;
    String typeVal = 'Square'; // 'Circle', 'Square', 'Rectangle'
    String floorVal = _selectedFloor; // default to active floor

    final TableEditorModel? newTable = await showDialog<TableEditorModel>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              width: 440,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add New Table',
                    style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Table Name',
                    style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. 21',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Capacity',
                              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: capacityVal,
                                  dropdownColor: AppColors.white,
                                  isExpanded: true,
                                  items: [
                                    DropdownMenuItem(value: 2, child: Text('2 Seats', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 4, child: Text('4 Seats', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 6, child: Text('6 Seats', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 8, child: Text('8 Seats', style: TextStyle(color: AppColors.neutral800))),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        capacityVal = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Table Type',
                              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: typeVal,
                                  dropdownColor: AppColors.white,
                                  isExpanded: true,
                                  items: [
                                    DropdownMenuItem(value: 'Circle', child: Text('Circle', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 'Square', child: Text('Square', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 'Rectangle', child: Text('Rectangle', style: TextStyle(color: AppColors.neutral800))),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        typeVal = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Floor',
                    style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: floorVal,
                        dropdownColor: AppColors.white,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(value: 'Lantai 1', child: Text('Lantai 1', style: TextStyle(color: AppColors.neutral800))),
                          DropdownMenuItem(value: 'Lantai 2', child: Text('Lantai 2', style: TextStyle(color: AppColors.neutral800))),
                          DropdownMenuItem(value: 'Lantai 3', child: Text('Lantai 3', style: TextStyle(color: AppColors.neutral800))),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              floorVal = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(ctx, null);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.neutral300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            foregroundColor: AppColors.neutral800,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final String name = nameController.text.trim();
                            if (name.isNotEmpty) {
                              Navigator.pop(
                                ctx,
                                TableEditorModel(
                                  id: 'T' + DateTime.now().millisecondsSinceEpoch.toString(),
                                  name: name,
                                  capacity: capacityVal,
                                  x: 100.0,
                                  y: 100.0,
                                  width: typeVal == 'Rectangle' ? 110.0 : 50.0,
                                  height: typeVal == 'Rectangle' ? 60.0 : 50.0,
                                  tableType: typeVal,
                                  floor: floorVal,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text('Add'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (newTable != null) {
      setState(() {
        _tables.add(newTable);
      });
      _showToastAlert('Table successfully added to ${newTable.floor}', success: true);
    } else {
      _showToastAlert('Table creation cancelled', success: false);
    }
  }

  void _showEditTableSettingsDialog(TableEditorModel table) async {
    final TextEditingController nameController = TextEditingController(text: table.name);
    int capacityVal = table.capacity;
    String typeVal = table.tableType;
    String floorVal = table.floor;

    final TableEditorModel? updated = await showDialog<TableEditorModel>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Table Settings',
                    style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Table Name',
                    style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Capacity',
                              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: capacityVal,
                                  dropdownColor: AppColors.white,
                                  isExpanded: true,
                                  items: [
                                    DropdownMenuItem(value: 2, child: Text('2 Seats', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 4, child: Text('4 Seats', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 6, child: Text('6 Seats', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 8, child: Text('8 Seats', style: TextStyle(color: AppColors.neutral800))),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        capacityVal = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Table Type',
                              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: typeVal,
                                  dropdownColor: AppColors.white,
                                  isExpanded: true,
                                  items: [
                                    DropdownMenuItem(value: 'Circle', child: Text('Circle', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 'Square', child: Text('Square', style: TextStyle(color: AppColors.neutral800))),
                                    DropdownMenuItem(value: 'Rectangle', child: Text('Rectangle', style: TextStyle(color: AppColors.neutral800))),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() {
                                        typeVal = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Floor',
                    style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: floorVal,
                        dropdownColor: AppColors.white,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(value: 'Lantai 1', child: Text('Lantai 1', style: TextStyle(color: AppColors.neutral800))),
                          DropdownMenuItem(value: 'Lantai 2', child: Text('Lantai 2', style: TextStyle(color: AppColors.neutral800))),
                          DropdownMenuItem(value: 'Lantai 3', child: Text('Lantai 3', style: TextStyle(color: AppColors.neutral800))),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              floorVal = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(ctx, null);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.neutral300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            foregroundColor: AppColors.neutral800,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final String name = nameController.text.trim();
                            if (name.isNotEmpty) {
                              Navigator.pop(
                                ctx,
                                table.copyWith(
                                  name: name,
                                  capacity: capacityVal,
                                  width: typeVal == 'Rectangle' ? 110.0 : 50.0,
                                  height: typeVal == 'Rectangle' ? 60.0 : 50.0,
                                  tableType: typeVal,
                                  floor: floorVal,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (updated != null) {
      setState(() {
        final int index = _tables.indexWhere((t) => t.id == table.id);
        if (index != -1) {
          _tables[index] = updated;
          if (updated.floor != _selectedFloor) {
            _selectedTableId = ''; // unselect if moved to a different floor
          }
        }
      });
      _showToastAlert('Table settings saved', success: true);
    }
  }

  // Populate 40 default tables across Lantai 1, Lantai 2, Lantai 3 matching PosTablesScreen
  List<TableEditorModel> _generateDefaultTables() {
    final List<TableEditorModel> list = [];

    // --- LANTAI 1 ---
    // Circles (2 seats)
    list.add(TableEditorModel(id: 'T1', name: '01', capacity: 2, x: 80, y: 100, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T2', name: '02', capacity: 2, x: 170, y: 100, width: 50, height: 50, tableType: 'Circle', status: 'Used', usedAmount: 245000, floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T3', name: '03', capacity: 2, x: 260, y: 100, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T4', name: '04', capacity: 2, x: 350, y: 100, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 1'));

    // Squares (4 seats)
    list.add(TableEditorModel(id: 'T5', name: '05', capacity: 4, x: 80, y: 200, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T6', name: '06', capacity: 4, x: 170, y: 200, width: 50, height: 50, tableType: 'Square', status: 'Used', usedAmount: 345000, floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T7', name: '07', capacity: 4, x: 260, y: 200, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T8', name: '08', capacity: 4, x: 350, y: 200, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 1'));

    // Middle Squares (4 seats)
    list.add(TableEditorModel(id: 'T9', name: '09', capacity: 4, x: 80, y: 320, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T10', name: '10', capacity: 4, x: 170, y: 320, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T11', name: '11', capacity: 4, x: 260, y: 320, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T12', name: '12', capacity: 4, x: 350, y: 320, width: 50, height: 50, tableType: 'Square', status: 'Used', usedAmount: 189000, floor: 'Lantai 1'));

    // Long Rectangles (6 seats)
    list.add(TableEditorModel(id: 'T13', name: '13', capacity: 6, x: 580, y: 200, width: 110, height: 60, tableType: 'Rectangle', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T14', name: '14', capacity: 6, x: 580, y: 320, width: 110, height: 60, tableType: 'Rectangle', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T15', name: '15', capacity: 6, x: 580, y: 440, width: 110, height: 60, tableType: 'Rectangle', status: 'Used', usedAmount: 760000, floor: 'Lantai 1'));

    // Bottom Circles (2 seats)
    list.add(TableEditorModel(id: 'T16', name: '16', capacity: 2, x: 80, y: 580, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T17', name: '17', capacity: 2, x: 170, y: 580, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T18', name: '18', capacity: 2, x: 260, y: 580, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T19', name: '19', capacity: 2, x: 350, y: 580, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 1'));
    list.add(TableEditorModel(id: 'T20', name: '20', capacity: 2, x: 440, y: 580, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 1'));

    // --- LANTAI 2 ---
    list.add(TableEditorModel(id: 'T21', name: '21', capacity: 2, x: 100, y: 150, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T22', name: '22', capacity: 2, x: 200, y: 150, width: 50, height: 50, tableType: 'Circle', status: 'Used', usedAmount: 145000, floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T23', name: '23', capacity: 2, x: 300, y: 150, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T24', name: '24', capacity: 4, x: 100, y: 250, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T25', name: '25', capacity: 4, x: 200, y: 250, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T26', name: '26', capacity: 4, x: 300, y: 250, width: 50, height: 50, tableType: 'Square', status: 'Used', usedAmount: 290000, floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T27', name: '27', capacity: 6, x: 500, y: 200, width: 110, height: 60, tableType: 'Rectangle', floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T28', name: '28', capacity: 6, x: 500, y: 320, width: 110, height: 60, tableType: 'Rectangle', floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T29', name: '29', capacity: 2, x: 100, y: 400, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 2'));
    list.add(TableEditorModel(id: 'T30', name: '30', capacity: 2, x: 200, y: 400, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 2'));

    // --- LANTAI 3 ---
    list.add(TableEditorModel(id: 'T31', name: '31', capacity: 2, x: 150, y: 120, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T32', name: '32', capacity: 2, x: 250, y: 120, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T33', name: '33', capacity: 4, x: 150, y: 220, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T34', name: '34', capacity: 4, x: 250, y: 220, width: 50, height: 50, tableType: 'Square', status: 'Used', usedAmount: 95000, floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T35', name: '35', capacity: 6, x: 450, y: 180, width: 110, height: 60, tableType: 'Rectangle', floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T36', name: '36', capacity: 6, x: 450, y: 300, width: 110, height: 60, tableType: 'Rectangle', floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T37', name: '37', capacity: 4, x: 150, y: 340, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T38', name: '38', capacity: 4, x: 250, y: 340, width: 50, height: 50, tableType: 'Square', floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T39', name: '39', capacity: 2, x: 150, y: 460, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 3'));
    list.add(TableEditorModel(id: 'T40', name: '40', capacity: 2, x: 250, y: 460, width: 50, height: 50, tableType: 'Circle', floor: 'Lantai 3'));

    return list;
  }
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
    
    // Draw horizontal/vertical dots over the entire sized canvas
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
