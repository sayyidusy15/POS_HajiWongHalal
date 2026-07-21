import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/pos_navigation_drawer.dart';
import '../widgets/receipt_preview_modal.dart';
import '../screens/pos_dashboard_screen.dart';

class OrderModel {
  String id;
  String status; // 'Open', 'In Progress', 'Completed', 'Cancelled'
  DateTime date;
  String customerName;
  String orderType; // 'Dine In', 'Take Away'
  int qty;
  double total;
  String paymentMethod; // 'Cash', 'QRIS'
  String? tableName;
  List<Map<String, dynamic>> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.date,
    required this.customerName,
    required this.orderType,
    required this.qty,
    required this.total,
    required this.paymentMethod,
    this.tableName,
    required this.items,
  });
}

class OrderFilters {
  String paymentMethod; // 'All', 'Cash', 'QRIS'
  String? orderType; // 'Dine In', 'Take Away', or null (All)
  double? minAmount;
  double? maxAmount;

  OrderFilters({
    required this.paymentMethod,
    this.orderType,
    this.minAmount,
    this.maxAmount,
  });
}

class PosOrderScreen extends StatefulWidget {
  const PosOrderScreen({super.key});

  @override
  State<PosOrderScreen> createState() => _PosOrderScreenState();
}

class _PosOrderScreenState extends State<PosOrderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Active Filter state
  String _activeFilter = 'All'; // 'All', 'Open', 'In Progress', 'Completed', 'Cancelled'
  String _searchQuery = '';
  String _sortBy = 'Recent'; // 'Recent', 'Total Item', 'Highest Payment', 'Lowest Payment'
  
  // Pagination State
  int _currentPage = 1;
  final int _rowsPerPage = 10;
  
  // Advanced Filters
  OrderFilters _currentFilters = OrderFilters(paymentMethod: 'All');

  // List of Orders
  late List<OrderModel> _orders;

  @override
  void initState() {
    super.initState();
    _orders = _generateMockOrders();
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

  String _formatDateTime(DateTime date) {
    final List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final String dayStr = date.day.toString().padLeft(2, '0');
    final String monthStr = months[date.month - 1];
    final String yearStr = date.year.toString();

    return '$monthStr $dayStr, $yearStr';
  }

  String _formatTimeOnly(DateTime date) {
    int hour = date.hour;
    final String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    final String hourStr = hour.toString().padLeft(2, '0');
    final String minuteStr = date.minute.toString().padLeft(2, '0');
    return '$hourStr.$minuteStr $period';
  }

  @override
  Widget build(BuildContext context) {
    // 1. FILTER BY STATUS CARD
    List<OrderModel> filteredList = _orders;
    if (_activeFilter != 'All') {
      filteredList = filteredList.where((o) => o.status == _activeFilter).toList();
    }

    // 2. FILTER BY SEARCH QUERY
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((o) => o.id.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // 3. FILTER BY ADVANCED FILTERS
    if (_currentFilters.paymentMethod != 'All') {
      filteredList = filteredList.where((o) => o.paymentMethod == _currentFilters.paymentMethod).toList();
    }
    if (_currentFilters.orderType != null) {
      filteredList = filteredList.where((o) => o.orderType == _currentFilters.orderType).toList();
    }
    if (_currentFilters.minAmount != null) {
      filteredList = filteredList.where((o) => o.total >= _currentFilters.minAmount!).toList();
    }
    if (_currentFilters.maxAmount != null) {
      filteredList = filteredList.where((o) => o.total <= _currentFilters.maxAmount!).toList();
    }

    // 4. SORT BY SELECTED CRITERIA
    if (_sortBy == 'Recent') {
      filteredList.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortBy == 'Total Item') {
      filteredList.sort((a, b) => b.qty.compareTo(a.qty));
    } else if (_sortBy == 'Highest Payment') {
      filteredList.sort((a, b) => b.total.compareTo(a.total));
    } else if (_sortBy == 'Lowest Payment') {
      filteredList.sort((a, b) => a.total.compareTo(b.total));
    }

    // Pagination calculations
    final int totalItems = filteredList.length;
    final int totalPages = (totalItems / _rowsPerPage).ceil();
    if (_currentPage > totalPages && totalPages > 0) {
      _currentPage = totalPages;
    }
    final int startIndex = (_currentPage - 1) * _rowsPerPage;
    final int endIndex = (startIndex + _rowsPerPage).clamp(0, totalItems);
    final List<OrderModel> paginatedList = totalItems > 0 
        ? filteredList.sublist(startIndex, endIndex)
        : [];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F6), // light gray background
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          // Search bar ID (Icon & Text perfectly aligned)
          Center(
            child: Container(
              width: 220,
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
                          _currentPage = 1; // Reset to page 1
                        });
                      },
                      style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                      decoration: InputDecoration(
                        hintText: 'Search order ID...',
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
          const SizedBox(width: 12),
          // Tombol Sort Dropdown
          Center(child: _buildSortButton()),
          const SizedBox(width: 12),
          // Tombol Filter Modal
          Center(child: _buildFilterButton()),
          const SizedBox(width: 24),
        ],
      ),
      drawer: PosNavigationDrawer(activeRoute: 'order'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // PANEL KIRI: Status Summary Cards (Filter)
            SizedBox(
              width: 240,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStatusCard(
                      title: 'All',
                      count: _orders.length,
                      icon: Icons.grid_view_outlined,
                      isActive: _activeFilter == 'All',
                      onTap: () => _setStatusFilter('All'),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusCard(
                      title: 'Open',
                      count: _orders.where((o) => o.status == 'Open').length,
                      icon: Icons.receipt_long_outlined,
                      isActive: _activeFilter == 'Open',
                      onTap: () => _setStatusFilter('Open'),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusCard(
                      title: 'In Progress',
                      count: _orders.where((o) => o.status == 'In Progress').length,
                      icon: Icons.access_time_outlined,
                      isActive: _activeFilter == 'In Progress',
                      onTap: () => _setStatusFilter('In Progress'),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusCard(
                      title: 'Completed',
                      count: _orders.where((o) => o.status == 'Completed').length,
                      icon: Icons.check_circle_outline,
                      isActive: _activeFilter == 'Completed',
                      onTap: () => _setStatusFilter('Completed'),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusCard(
                      title: 'Cancelled',
                      count: _orders.where((o) => o.status == 'Cancelled').length,
                      icon: Icons.cancel_outlined,
                      isActive: _activeFilter == 'Cancelled',
                      onTap: () => _setStatusFilter('Cancelled'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),

            // PANEL KANAN: Tabel Utama Pesanan
            Expanded(
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Data Table Headers
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        children: [
                          _buildColumnHead('ID', 2),
                          _buildColumnHead('STATUS', 2),
                          _buildColumnHead('ORDER DATE', 2),
                          _buildColumnHead('CUSTOMER', 3),
                          _buildColumnHead('ORDER TYPE', 2),
                          _buildColumnHead('QTY', 1),
                          _buildColumnHead('TOTAL', 2),
                          _buildColumnHead('', 1), // Action column
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

                    // Data Rows (List View)
                    Expanded(
                      child: totalItems == 0 
                          ? _buildEmptyState()
                          : ListView.separated(
                              itemCount: paginatedList.length,
                              separatorBuilder: (context, index) => const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.neutral100,
                              ),
                              itemBuilder: (context, index) {
                                final order = paginatedList[index];
                                return _buildOrderRow(order);
                              },
                            ),
                    ),

                    const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

                    // Footer Pagination
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Rows per page: 10
                          Row(
                            children: [
                              Text(
                                'Rows per page:',
                                style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.neutral300),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '$_rowsPerPage',
                                  style: AppTypography.bodyXsRegular.copyWith(
                                    color: AppColors.neutral800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Pagination controller
                          Row(
                            children: [
                              // Panah Kiri
                              IconButton(
                                onPressed: _currentPage > 1 
                                    ? () => setState(() => _currentPage--)
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                                color: AppColors.neutral800,
                                disabledColor: AppColors.neutral300,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(width: 8),
                              // Page numbers list
                              ...List.generate(totalPages.clamp(1, 5), (index) {
                                final pageNum = index + 1;
                                final bool isPageActive = _currentPage == pageNum;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentPage = pageNum;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isPageActive ? AppColors.primary500 : Colors.transparent,
                                      border: isPageActive ? null : Border.all(color: AppColors.neutral300),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$pageNum',
                                      style: AppTypography.bodyXsRegular.copyWith(
                                        color: isPageActive ? AppColors.white : AppColors.neutral600,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(width: 8),
                              // Panah Kanan
                              IconButton(
                                onPressed: _currentPage < totalPages 
                                    ? () => setState(() => _currentPage++)
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                                color: AppColors.neutral800,
                                disabledColor: AppColors.neutral300,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required int count,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? const Border(
                  left: BorderSide(color: Color(0xFF289656), width: 6),
                )
              : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Icon and Title
            Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.neutral800 : AppColors.neutral500,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTypography.bodySRegular.copyWith(
                      color: isActive ? AppColors.neutral800 : AppColors.neutral600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Bottom count: Large text
            Text(
              '$count',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnHead(String label, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: AppTypography.bodyXsRegular.copyWith(
          color: AppColors.neutral500,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildOrderRow(OrderModel order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          // 1. ID
          Expanded(
            flex: 2,
            child: Text(
              order.id,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          // 2. STATUS BADGE
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusBgColor(order.status),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      order.status,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTypography.bodyXsRegular.copyWith(
                        color: _getStatusTextColor(order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 3. ORDER DATE
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDateTime(order.date),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTimeOnly(order.date),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                ),
              ],
            ),
          ),
          // 4. CUSTOMER
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _showRenameCustomerDialog(order),
              behavior: HitTestBehavior.opaque,
              child: order.customerName.isEmpty 
                  ? Text('-', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    order.customerName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: AppTypography.bodySRegular.copyWith(
                                      color: AppColors.neutral800,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.open_in_new, size: 12, color: AppColors.neutral500),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          // 5. ORDER TYPE
          Expanded(
            flex: 2,
            child: Text(
              order.orderType,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 6. QTY
          Expanded(
            flex: 1,
            child: Text(
              '${order.qty}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 7. TOTAL
          Expanded(
            flex: 2,
            child: Text(
              _formatRupiah(order.total),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 8. ACTION (3 DOTS KEBAB)
          Expanded(
            flex: 1,
            child: Center(
              child: _buildActionDropdown(order),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionDropdown(OrderModel order) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.neutral700),
      tooltip: 'Actions',
      onSelected: (val) {
        if (val == 'details') {
          _showDetailsModal(order);
        } else if (val == 'receipt') {
          _showReceiptModal(order);
        } else if (val == 'delete') {
          _handleDeleteOrder(order);
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: 'details',
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, size: 18),
              SizedBox(width: 8),
              Text('View Details'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'status',
          child: PopupMenuButton<String>(
            child: const Row(
              children: [
                Icon(Icons.edit_outlined, size: 18),
                SizedBox(width: 8),
                Text('Edit Status'),
                Spacer(),
                Icon(Icons.chevron_right, size: 16),
              ],
            ),
            onSelected: (newStatus) {
              // Close kebab menu after sub-selection
              Navigator.pop(ctx);
              setState(() {
                order.status = newStatus;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Status updated to $newStatus successfully!'),
                  backgroundColor: AppColors.primary500,
                ),
              );
            },
            itemBuilder: (subCtx) => [
              const PopupMenuItem(value: 'Open', child: Text('Open')),
              const PopupMenuItem(value: 'In Progress', child: Text('In Progress')),
              const PopupMenuItem(value: 'Completed', child: Text('Completed')),
              const PopupMenuItem(value: 'Cancelled', child: Text('Cancelled')),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'receipt',
          child: Row(
            children: [
              Icon(Icons.print_outlined, size: 18),
              SizedBox(width: 8),
              Text('Print Receipt'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      onSelected: (val) {
        setState(() {
          _sortBy = val;
        });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.neutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.sort, size: 18, color: AppColors.neutral700),
            const SizedBox(width: 6),
            Text(
              'Sort: $_sortBy',
              style: AppTypography.bodyXsRegular.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 'Recent', child: Text('Recent')),
        const PopupMenuItem(value: 'Total Item', child: Text('Total Item')),
        const PopupMenuItem(value: 'Highest Payment', child: Text('Highest Payment')),
        const PopupMenuItem(value: 'Lowest Payment', child: Text('Lowest Payment')),
      ],
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: _showFiltersDialog,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.neutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.neutral700),
            const SizedBox(width: 6),
            Text(
              'Filter',
              style: AppTypography.bodyXsRegular.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.neutral400),
        const SizedBox(height: 12),
        Text(
          'No Orders Found',
          style: AppTypography.bodyMRegular.copyWith(
            color: AppColors.neutral600,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Coba ubah filter pencarian atau buat transaksi baru.',
          style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
        ),
      ],
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Open':
        return const Color(0xFFEFF6FF); // Blue bg
      case 'In Progress':
        return const Color(0xFFFEF3C7); // Yellow/Orange bg
      case 'Completed':
        return const Color(0xFFECFDF5); // Green bg
      case 'Cancelled':
        return const Color(0xFFFEF2F2); // Red bg
      default:
        return AppColors.neutral100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Open':
        return const Color(0xFF1D4ED8); // Blue text
      case 'In Progress':
        return const Color(0xFFD97706); // Yellow/Orange text
      case 'Completed':
        return const Color(0xFF047857); // Green text
      case 'Cancelled':
        return const Color(0xFFB91C1C); // Red text
      default:
        return AppColors.neutral800;
    }
  }

  void _setStatusFilter(String filter) {
    setState(() {
      _activeFilter = filter;
      _currentPage = 1;
    });
  }

  void _showRenameCustomerDialog(OrderModel order) async {
    final TextEditingController controller = TextEditingController(text: order.customerName);
    final String? newName = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            width: 360,
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
                  'Rename Customer',
                  style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neutral300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter customer name...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
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
                        onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Save'),
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

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        order.customerName = newName;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Customer renamed to $newName successfully!'),
            backgroundColor: AppColors.primary500,
          ),
        );
      }
    }
  }

  void _showFiltersDialog() async {
    final OrderFilters? newFilters = await showDialog<OrderFilters>(
      context: context,
      builder: (ctx) => _FilterDialog(initialFilters: _currentFilters),
    );
    if (newFilters != null) {
      setState(() {
        _currentFilters = newFilters;
        _currentPage = 1;
      });
    }
  }

  void _showDetailsModal(OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => _OrderDetailsDialog(order: order),
    );
  }

  void _showReceiptModal(OrderModel order) async {
    // Reconstruct list of OrderItem for receipt preview modal
    final List<OrderItem> items = order.items.map((i) {
      return OrderItem(
        product: Product(
          name: i['name'],
          price: i['price'],
          category: 'Food',
          icon: Icons.lunch_dining,
        ),
        quantity: i['qty'],
        size: i['size'],
        addons: i['addons'] != null ? List<String>.from(i['addons'] as Iterable) : null,
        notes: i['notes'],
      );
    }).toList();

    // Reconstruct discount, tax, subtotal
    double sub = 0;
    for (var item in items) {
      sub += item.product.price * item.quantity;
    }
    final double taxAmount = sub * 0.03;
    final double disc = (sub + taxAmount) - order.total;

    final bool? printed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ReceiptPreviewModal(
        orderId: order.id,
        customerName: order.customerName,
        cartItems: items,
        subtotal: sub,
        discountAmount: disc > 0 ? disc : 0.0,
        tax: taxAmount,
        total: order.total,
        paymentMethod: order.paymentMethod,
        paidAmount: order.total, // mockup equal
        changeAmount: 0.0,
      ),
    );

    if (printed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receipt printed successfully!'),
          backgroundColor: AppColors.primary500,
        ),
      );
    }
  }

  void _handleDeleteOrder(OrderModel order) async {
    final bool? confirm = await showDialog<bool>(
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
                child: const Icon(Icons.delete_outline, color: AppColors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Order?',
                style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete order ${order.id}? This action cannot be undone.',
                style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
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
                      child: const Text('Yes, Delete'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      setState(() {
        _orders.removeWhere((o) => o.id == order.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order ${order.id} has been deleted successfully!'),
            backgroundColor: AppColors.error500,
          ),
        );
      }
    }
  }

  // Generate 34 Mock Orders for the table review
  List<OrderModel> _generateMockOrders() {
    final List<OrderModel> list = [];
    
    // 2 Open Orders
    list.add(OrderModel(
      id: '#201OE10',
      status: 'Open',
      date: DateTime(2026, 7, 20, 9, 31),
      customerName: 'Dian Rahmani',
      orderType: 'Dine In',
      qty: 5,
      total: 34500,
      paymentMethod: 'Cash',
      tableName: 'Table 12',
      items: [
        {'name': 'Deluxe Crispy Burger', 'price': 6900.0, 'qty': 2, 'size': 'Large', 'addons': ['Extra Cheese'], 'notes': 'Extra spicy'},
        {'name': 'Vanilla Sundae', 'price': 3500.0, 'qty': 3, 'size': 'Regular', 'addons': [], 'notes': ''}
      ],
    ));
    list.add(OrderModel(
      id: '#201OE11',
      status: 'Open',
      date: DateTime(2026, 7, 20, 10, 15),
      customerName: 'Brian Susanto',
      orderType: 'Take Away',
      qty: 2,
      total: 15000,
      paymentMethod: 'QRIS',
      items: [
        {'name': 'Double Cheeseburger', 'price': 7500.0, 'qty': 2, 'size': 'Regular', 'addons': [], 'notes': ''}
      ],
    ));

    // 2 In Progress Orders
    list.add(OrderModel(
      id: '#201OE12',
      status: 'In Progress',
      date: DateTime(2026, 7, 20, 10, 20),
      customerName: 'Jonathan Joestar',
      orderType: 'Dine In',
      qty: 3,
      total: 22500,
      paymentMethod: 'Cash',
      tableName: 'Table 5',
      items: [
        {'name': 'Classic Crispyburger', 'price': 4750.0, 'qty': 1, 'size': 'Regular', 'addons': [], 'notes': ''},
        {'name': 'Sprite', 'price': 3000.0, 'qty': 2, 'size': 'Regular', 'addons': [], 'notes': ''}
      ],
    ));
    list.add(OrderModel(
      id: '#201OE13',
      status: 'In Progress',
      date: DateTime(2026, 7, 20, 10, 30),
      customerName: 'Olivia',
      orderType: 'Dine In',
      qty: 4,
      total: 28000,
      paymentMethod: 'QRIS',
      tableName: 'Table 8',
      items: [
        {'name': 'Deluxe Crispy Burger', 'price': 6900.0, 'qty': 2, 'size': 'Regular', 'addons': [], 'notes': ''},
        {'name': 'Sprite', 'price': 3000.0, 'qty': 2, 'size': 'Regular', 'addons': [], 'notes': ''}
      ],
    ));

    // 27 Completed Orders
    final List<String> completedCustomers = [
      'Noah', 'Sophia', 'Emma', 'Noah', 'Liam', 'Oliver', 'Mia', 'Lucas', 'Ella', 'Mason',
      'Ava', 'James', 'Isabella', 'Benjamin', 'Charlotte', 'William', 'Amelia', 'Alexander', 'Jane', 'Doe',
      'Bob', 'Alice', 'Stevan', 'Cornerlius', 'Rendra', 'Aditya', 'Sayyid'
    ];
    for (int i = 0; i < 27; i++) {
      final idNum = 14 + i;
      final cust = completedCustomers[i % completedCustomers.length];
      final isDine = i % 2 == 0;
      final qtyVal = 1 + (i % 6);
      final double totalVal = (12000.0 + (i * 3500.0));

      list.add(OrderModel(
        id: '#201OE$idNum',
        status: 'Completed',
        date: DateTime(2026, 7, 19 - (i ~/ 10), 12 + (i % 8), 10 + (i * 2) % 40),
        customerName: cust,
        orderType: isDine ? 'Dine In' : 'Take Away',
        qty: qtyVal,
        total: totalVal,
        paymentMethod: i % 3 == 0 ? 'QRIS' : 'Cash',
        tableName: isDine ? 'Table ${(i % 15) + 1}' : null,
        items: [
          {'name': 'Deluxe Crispy Burger', 'price': 6900.0, 'qty': qtyVal, 'size': 'Regular', 'addons': [], 'notes': ''}
        ],
      ));
    }

    // 3 Cancelled Orders
    list.add(OrderModel(
      id: '#201OE41',
      status: 'Cancelled',
      date: DateTime(2026, 7, 18, 14, 10),
      customerName: 'George',
      orderType: 'Take Away',
      qty: 1,
      total: 6900,
      paymentMethod: 'Cash',
      items: [
        {'name': 'Deluxe Crispy Burger', 'price': 6900.0, 'qty': 1, 'size': 'Regular', 'addons': [], 'notes': ''}
      ],
    ));
    list.add(OrderModel(
      id: '#201OE42',
      status: 'Cancelled',
      date: DateTime(2026, 7, 18, 15, 30),
      customerName: 'Harry',
      orderType: 'Dine In',
      qty: 6,
      total: 41500,
      paymentMethod: 'QRIS',
      tableName: 'Table 2',
      items: [
        {'name': '3 Cheese Wings', 'price': 3490.0, 'qty': 6, 'size': 'Regular', 'addons': [], 'notes': ''}
      ],
    ));
    list.add(OrderModel(
      id: '#201OE43',
      status: 'Cancelled',
      date: DateTime(2026, 7, 17, 11, 45),
      customerName: 'Ian',
      orderType: 'Take Away',
      qty: 3,
      total: 10470,
      paymentMethod: 'Cash',
      items: [
        {'name': '3 Cheese Wings', 'price': 3490.0, 'qty': 3, 'size': 'Regular', 'addons': [], 'notes': ''}
      ],
    ));

    return list;
  }
}

// ----------------------------------------------------
// DIALOG & MODAL SUB-WIDGETS
// ----------------------------------------------------

class _FilterDialog extends StatefulWidget {
  final OrderFilters initialFilters;
  const _FilterDialog({required this.initialFilters});

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late String _paymentMethod;
  String? _orderType;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _paymentMethod = widget.initialFilters.paymentMethod;
    _orderType = widget.initialFilters.orderType;
    if (widget.initialFilters.minAmount != null) {
      _minController.text = widget.initialFilters.minAmount!.toStringAsFixed(2);
    }
    if (widget.initialFilters.maxAmount != null) {
      _maxController.text = widget.initialFilters.maxAmount!.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        width: 440,
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
              // Header
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
                  'Filters',
                  style: AppTypography.bodyLBold.copyWith(
                    color: AppColors.neutral900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Method Dropdown
                    Text(
                      'Payment Method',
                      style: AppTypography.bodySRegular.copyWith(
                        color: AppColors.neutral700,
                        fontWeight: FontWeight.bold,
                      ),
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
                          value: _paymentMethod,
                          isExpanded: true,
                          style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                          items: [
                            DropdownMenuItem(value: 'All', child: Text('All', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800))),
                            DropdownMenuItem(value: 'Cash', child: Text('Cash', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800))),
                            DropdownMenuItem(value: 'QRIS', child: Text('QRIS', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800))),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _paymentMethod = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Order Type (Radio Buttons)
                    Text(
                      'Order Type',
                      style: AppTypography.bodySRegular.copyWith(
                        color: AppColors.neutral700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // All Radio
                        Radio<String?>(
                          value: null,
                          groupValue: _orderType,
                          onChanged: (val) {
                            setState(() {
                              _orderType = val;
                            });
                          },
                          activeColor: AppColors.primary500,
                        ),
                        Text('All', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800)),
                        const SizedBox(width: 12),
                        // Dine In Radio
                        Radio<String?>(
                          value: 'Dine In',
                          groupValue: _orderType,
                          onChanged: (val) {
                            setState(() {
                              _orderType = val;
                            });
                          },
                          activeColor: AppColors.primary500,
                        ),
                        Text('Dine In', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800)),
                        const SizedBox(width: 12),
                        // Take Away Radio
                        Radio<String?>(
                          value: 'Take Away',
                          groupValue: _orderType,
                          onChanged: (val) {
                            setState(() {
                              _orderType = val;
                            });
                          },
                          activeColor: AppColors.primary500,
                        ),
                        Text('Take Away', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Min Amount & Max Amount Textfields
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Min Amount',
                                style: AppTypography.bodySRegular.copyWith(
                                  color: AppColors.neutral700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.neutral300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _minController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(left: 12.0, right: 6.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Rp', style: TextStyle(color: AppColors.neutral500, fontWeight: FontWeight.bold, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                    hintText: '0',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    isDense: true,
                                  ),
                                  style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
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
                                'Max Amount',
                                style: AppTypography.bodySRegular.copyWith(
                                  color: AppColors.neutral700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.neutral300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _maxController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(left: 12.0, right: 6.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Rp', style: TextStyle(color: AppColors.neutral500, fontWeight: FontWeight.bold, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                    hintText: '0',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    isDense: true,
                                  ),
                                  style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

              // Footer Buttons
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
                        onPressed: () {
                          final double? minAmount = double.tryParse(_minController.text.trim());
                          final double? maxAmount = double.tryParse(_maxController.text.trim());
                          Navigator.pop(
                            context,
                            OrderFilters(
                              paymentMethod: _paymentMethod,
                              orderType: _orderType,
                              minAmount: minAmount,
                              maxAmount: maxAmount,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Apply',
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
}

class _OrderDetailsDialog extends StatelessWidget {
  final OrderModel order;
  const _OrderDetailsDialog({required this.order});

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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        width: 520,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
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
                'Order Details - ${order.id}',
                style: AppTypography.bodyLBold.copyWith(
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Body content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info block
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Customer Name', order.customerName.isEmpty ? '-' : order.customerName),
                          const SizedBox(height: 10),
                          _buildDetailRow('Order Type', order.orderType),
                          if (order.orderType == 'Dine In' && order.tableName != null) ...[
                            const SizedBox(height: 10),
                            _buildDetailRow('Table Number', order.tableName!),
                          ],
                          const SizedBox(height: 10),
                          _buildDetailRow('Payment Method', order.paymentMethod),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Items bought summary list
                    Text(
                      'Items Purchased',
                      style: AppTypography.bodySMedium.copyWith(
                        color: AppColors.neutral600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: List.generate(order.items.length, (index) {
                          final item = order.items[index];
                          final double itemTotal = (item['price'] as double) * (item['qty'] as int);

                          return Container(
                            decoration: BoxDecoration(
                              border: index < order.items.length - 1
                                  ? const Border(bottom: BorderSide(color: AppColors.neutral100))
                                  : null,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: AppTypography.bodySRegular.copyWith(
                                          color: AppColors.neutral800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (item['size'] != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Size: ${item['size']}${item['addons'] != null && (item['addons'] as List).isNotEmpty ? ' + ' + (item['addons'] as List).join(", ") : ""}',
                                          style: AppTypography.bodyXsRegular.copyWith(
                                            color: AppColors.neutral500,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                      if (item['notes'] != null && (item['notes'] as String).trim().isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Note: "${item['notes']}"',
                                          style: AppTypography.bodyXsRegular.copyWith(
                                            color: AppColors.neutral500,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Text(
                                  'x${item['qty']}',
                                  style: AppTypography.bodySRegular.copyWith(
                                    color: AppColors.neutral600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Text(
                                  _formatRupiah(itemTotal),
                                  style: AppTypography.bodySRegular.copyWith(
                                    color: AppColors.neutral900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Totals
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: AppTypography.bodyLBold.copyWith(color: AppColors.neutral900),
                          ),
                          Text(
                            _formatRupiah(order.total),
                            style: AppTypography.h4Bold.copyWith(color: AppColors.primary500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

            // Footer
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neutral800,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: Text(
                  'Close',
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
            color: AppColors.neutral800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
