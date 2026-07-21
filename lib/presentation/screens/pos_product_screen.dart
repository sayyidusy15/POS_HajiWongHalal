import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/pos_navigation_drawer.dart';
import '../widgets/custom_success_toast.dart';
import '../widgets/delete_confirmation_modal.dart';

class ProductModel {
  final String id;
  String name;
  String description;
  String category;
  int? stock;
  double price;
  String status; // 'Active', 'Draft', 'Inactive'
  IconData icon;
  Color iconBgColor;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.stock,
    required this.price,
    required this.status,
    this.icon = Icons.fastfood_outlined,
    this.iconBgColor = const Color(0xFFF1F5F9),
  });
}

class PosProductScreen extends StatefulWidget {
  const PosProductScreen({super.key});

  @override
  State<PosProductScreen> createState() => _PosProductScreenState();
}

class _PosProductScreenState extends State<PosProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // State Management
  String _searchQuery = '';
  String _sortOrder = 'Default'; // 'Default', 'Name (A-Z)', 'Price (Low to High)', 'Price (High to Low)'
  
  // Advanced Filter State
  String _filterCategory = 'All';
  double? _filterMinPrice;
  double? _filterMaxPrice;
  String _filterStock = 'All';

  // Pagination State
  int _rowsPerPage = 10;
  int _currentPage = 1;

  // Toast Notification state
  bool _showToast = false;
  String _toastTitle = '';
  String _toastSubtitle = '';
  bool _toastIsSuccess = true;

  // Mock Products Data
  late List<ProductModel> _products;

  @override
  void initState() {
    super.initState();
    _products = _generateMockProducts();
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
    // Filter Products
    List<ProductModel> filtered = _products.where((p) {
      // Search Query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = p.name.toLowerCase().contains(q);
        final matchesId = p.id.toLowerCase().contains(q);
        final matchesCat = p.category.toLowerCase().contains(q);
        if (!matchesName && !matchesId && !matchesCat) return false;
      }

      // Category Filter
      if (_filterCategory != 'All' && p.category != _filterCategory) return false;

      // Min Price
      if (_filterMinPrice != null && p.price < _filterMinPrice!) return false;

      // Max Price
      if (_filterMaxPrice != null && p.price > _filterMaxPrice!) return false;

      // Stock Filter
      if (_filterStock == 'In Stock' && (p.stock == null || p.stock! <= 0)) return false;
      if (_filterStock == 'Out of Stock' && (p.stock != null && p.stock! > 0)) return false;

      return true;
    }).toList();

    // Sort Products
    if (_sortOrder == 'Name (A-Z)') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortOrder == 'Price (Low to High)') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOrder == 'Price (High to Low)') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    // Pagination calculations
    final int totalItems = filtered.length;
    final int totalPages = (totalItems / _rowsPerPage).ceil().clamp(1, 999);
    final int startIndex = ((_currentPage - 1) * _rowsPerPage).clamp(0, totalItems);
    final int endIndex = (startIndex + _rowsPerPage).clamp(0, totalItems);
    final List<ProductModel> pageItems = startIndex < totalItems ? filtered.sublist(startIndex, endIndex) : [];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F6), // Light gray background
      appBar: AppBar(
        title: const Text('Product Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          // Search bar
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
                          _currentPage = 1;
                        });
                      },
                      style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                      decoration: InputDecoration(
                        hintText: 'Search product name...',
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
          Center(child: _buildSortButton()),
          const SizedBox(width: 12),
          Center(child: _buildFilterButton()),
          const SizedBox(width: 12),
          Center(child: _buildAddProductButton()),
          const SizedBox(width: 24),
        ],
      ),
      drawer: const PosNavigationDrawer(activeRoute: 'product'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
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
                        _buildColumnHead('PRODUCT NAME', 4),
                        _buildColumnHead('CATEGORY', 2),
                        _buildColumnHead('STOCK', 2),
                        _buildColumnHead('PRICE', 2),
                        _buildColumnHead('STATUS', 2),
                        _buildColumnHead('', 1), // Action column
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

                  // Data Rows (List View)
                  Expanded(
                    child: pageItems.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            itemCount: pageItems.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.neutral100,
                            ),
                            itemBuilder: (context, index) {
                              return _buildProductDataRow(pageItems[index]);
                            },
                          ),
                  ),

                  const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

                  // Footer Pagination
                  _buildTableFooter(totalItems, totalPages),
                ],
              ),
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

  // --- HEADER ACTION BUILDERS ---

  Widget _buildSortButton() {
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
          value: _sortOrder,
          icon: const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(Icons.swap_vert, size: 18, color: AppColors.neutral700),
          ),
          dropdownColor: AppColors.white,
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral800,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _sortOrder = val;
              });
            }
          },
          items: ['Default', 'Name (A-Z)', 'Price (Low to High)', 'Price (High to Low)']
              .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: AppColors.neutral800))))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return OutlinedButton.icon(
      onPressed: _showFilterModal,
      icon: const Icon(Icons.filter_list_outlined, size: 18, color: AppColors.neutral800),
      label: Text(
        'Filter',
        style: AppTypography.bodySRegular.copyWith(
          color: AppColors.neutral800,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.neutral300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      ),
    );
  }

  Widget _buildAddProductButton() {
    return ElevatedButton.icon(
      onPressed: _showAddProductModal,
      icon: const Icon(Icons.add, size: 18, color: AppColors.white),
      label: Text(
        'Add Product',
        style: AppTypography.bodySRegular.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // --- TABLE WIDGET BUILDERS ---

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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.neutral400),
          const SizedBox(height: 12),
          Text(
            'No products found',
            style: AppTypography.bodyMBold.copyWith(color: AppColors.neutral600),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your search or filter keywords',
            style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral400),
          ),
        ],
      ),
    );
  }

  // Data Row with Flex Alignment
  Widget _buildProductDataRow(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          // 1. ID
          Expanded(
            flex: 2,
            child: Text(
              product.id,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral900,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 2. Product Name (Thumbnail + Name + Description)
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: product.iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(product.icon, color: AppColors.neutral700, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.bodySRegular.copyWith(
                          color: AppColors.neutral900,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.description,
                        style: AppTypography.bodyXsRegular.copyWith(
                          color: AppColors.neutral400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Category
          Expanded(
            flex: 2,
            child: Text(
              product.category,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral700,
              ),
            ),
          ),

          // 4. Stock
          Expanded(
            flex: 2,
            child: Text(
              product.stock != null ? product.stock.toString() : '-',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: (product.stock == null || product.stock! <= 0) ? AppColors.neutral400 : AppColors.neutral800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // 5. Price
          Expanded(
            flex: 2,
            child: Text(
              _formatRupiah(product.price),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 6. Status Badge
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Flexible(
                  child: _buildStatusBadge(product.status),
                ),
              ],
            ),
          ),

          // 7. Kebab Menu Action
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.neutral500, size: 20),
                color: AppColors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onSelected: (val) {
                  if (val == 'edit') {
                    _showEditProductModal(product);
                  } else if (val == 'delete') {
                    _confirmDeleteProduct(product);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined, size: 16, color: AppColors.neutral700),
                        const SizedBox(width: 8),
                        Text('Edit', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline, size: 16, color: AppColors.error500),
                        const SizedBox(width: 8),
                        Text('Delete', style: AppTypography.bodySRegular.copyWith(color: AppColors.error500, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor = AppColors.neutral100;
    Color textColor = AppColors.neutral700;

    if (status == 'Active') {
      bgColor = const Color(0xFFDCFCE7); // Light pastel green
      textColor = const Color(0xFF15803D); // Deep green
    } else if (status == 'Draft') {
      bgColor = const Color(0xFFE0F2FE); // Light pastel blue
      textColor = const Color(0xFF0369A1); // Deep blue
    } else if (status == 'Inactive') {
      bgColor = AppColors.neutral200; // Light gray
      textColor = AppColors.neutral600; // Dark gray
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 3. Footer Pagination (Exact match with Order Screen)
  Widget _buildTableFooter(int totalItems, int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _rowsPerPage,
                    isDense: true,
                    dropdownColor: AppColors.white,
                    style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral800, fontWeight: FontWeight.bold),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _rowsPerPage = val;
                          _currentPage = 1;
                        });
                      }
                    },
                    items: [5, 10, 20, 50].map((countVal) => DropdownMenuItem(value: countVal, child: Text('$countVal'))).toList(),
                  ),
                ),
              ),
            ],
          ),

          // Pagination Buttons
          Row(
            children: [
              IconButton(
                onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                icon: const Icon(Icons.chevron_left),
                color: AppColors.neutral800,
                disabledColor: AppColors.neutral300,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 8),
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
              IconButton(
                onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
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
    );
  }

  // --- ACTIONS & MODALS ---

  // 1. Filter Overlay Modal
  void _showFilterModal() async {
    String tempCategory = _filterCategory;
    final TextEditingController minPriceCtrl = TextEditingController(text: _filterMinPrice?.toString() ?? '');
    final TextEditingController maxPriceCtrl = TextEditingController(text: _filterMaxPrice?.toString() ?? '');
    String tempStock = _filterStock;

    final bool? apply = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setModalState) => Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              width: 440,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Centered Header
                  Center(
                    child: Text(
                      'Filters',
                      style: AppTypography.bodyLBold.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.neutral200),
                  const SizedBox(height: 20),

                  // Category
                  Text('Category', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral700)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempCategory,
                        dropdownColor: AppColors.white,
                        isExpanded: true,
                        items: ['All', 'Burger', 'Fried Chicken', 'Drink', 'Snack']
                            .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: AppColors.neutral800))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => tempCategory = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Min & Max Price side-by-side
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Min Price', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral700)),
                            const SizedBox(height: 8),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text('Rp', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: minPriceCtrl,
                                      keyboardType: TextInputType.number,
                                      style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                                      decoration: const InputDecoration(
                                        hintText: '0.00',
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
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
                            Text('Max Price', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral700)),
                            const SizedBox(height: 8),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text('Rp', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: maxPriceCtrl,
                                      keyboardType: TextInputType.number,
                                      style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
                                      decoration: const InputDecoration(
                                        hintText: '0.00',
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stock
                  Text('Stock', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral700)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutral300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempStock,
                        dropdownColor: AppColors.white,
                        isExpanded: true,
                        items: ['All', 'In Stock', 'Out of Stock']
                            .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: AppColors.neutral800))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => tempStock = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Footer: Cancel & Apply
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
                          onPressed: () {
                            _filterCategory = tempCategory;
                            _filterMinPrice = double.tryParse(minPriceCtrl.text.trim());
                            _filterMaxPrice = double.tryParse(maxPriceCtrl.text.trim());
                            _filterStock = tempStock;
                            Navigator.pop(ctx, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (apply == true) {
      setState(() {
        _currentPage = 1;
      });
      _triggerToast('Filter Applied', 'Product list updated per filter criteria', isSuccess: true);
    }
  }

  // 2. Delete Confirmation Action
  void _confirmDeleteProduct(ProductModel product) async {
    final bool? confirm = await DeleteConfirmationModal.show(
      context,
      title: 'Delete Confirmation',
      message: 'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
    );

    if (confirm == true) {
      setState(() {
        _products.removeWhere((p) => p.id == product.id);
      });
      _triggerToast('Product Deleted', '${product.name} removed from inventory', isSuccess: true);
    }
  }

  // 3. Add Product Modal
  void _showAddProductModal() async {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    String categoryVal = 'Burger';
    String statusVal = 'Active';

    final ProductModel? newProduct = await showDialog<ProductModel>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setModalState) => Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              width: 460,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Add New Product', style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),
                  Text('Product Name', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                    child: TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'e.g. Classic Crispyburger', border: InputBorder.none)),
                  ),
                  const SizedBox(height: 14),
                  Text('Description', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                    child: TextField(controller: descCtrl, decoration: const InputDecoration(hintText: 'Short item summary...', border: InputBorder.none)),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: categoryVal,
                                  isExpanded: true,
                                  dropdownColor: AppColors.white,
                                  items: ['Burger', 'Fried Chicken', 'Drink', 'Snack'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                  onChanged: (v) => setModalState(() => categoryVal = v!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: statusVal,
                                  isExpanded: true,
                                  dropdownColor: AppColors.white,
                                  items: ['Active', 'Draft', 'Inactive'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                  onChanged: (v) => setModalState(() => statusVal = v!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price (Rp)', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                              child: TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '45000', border: InputBorder.none)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Stock', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                              child: TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '120', border: InputBorder.none)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, null),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.neutral300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final String name = nameCtrl.text.trim();
                            final double? price = double.tryParse(priceCtrl.text.trim());
                            if (name.isNotEmpty && price != null) {
                              Navigator.pop(
                                ctx,
                                ProductModel(
                                  id: '#BP' + (100 + _products.length).toString(),
                                  name: name,
                                  description: descCtrl.text.trim().isEmpty ? 'Freshly prepared item' : descCtrl.text.trim(),
                                  category: categoryVal,
                                  price: price,
                                  stock: int.tryParse(stockCtrl.text.trim()),
                                  status: statusVal,
                                  icon: _getIconForCategory(categoryVal),
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
                          child: const Text('Add Product'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (newProduct != null) {
      setState(() {
        _products.insert(0, newProduct);
      });
      _triggerToast('Product Added', '${newProduct.name} successfully created', isSuccess: true);
    }
  }

  // 4. Edit Product Modal
  void _showEditProductModal(ProductModel product) async {
    final nameCtrl = TextEditingController(text: product.name);
    final descCtrl = TextEditingController(text: product.description);
    final priceCtrl = TextEditingController(text: product.price.toInt().toString());
    final stockCtrl = TextEditingController(text: product.stock?.toString() ?? '');
    String categoryVal = product.category;
    String statusVal = product.status;

    final ProductModel? updated = await showDialog<ProductModel>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setModalState) => Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              width: 460,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Edit Product', style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),
                  Text('Product Name', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                    child: TextField(controller: nameCtrl, decoration: const InputDecoration(border: InputBorder.none)),
                  ),
                  const SizedBox(height: 14),
                  Text('Description', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                    child: TextField(controller: descCtrl, decoration: const InputDecoration(border: InputBorder.none)),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: categoryVal,
                                  isExpanded: true,
                                  dropdownColor: AppColors.white,
                                  items: ['Burger', 'Fried Chicken', 'Drink', 'Snack'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                  onChanged: (v) => setModalState(() => categoryVal = v!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: statusVal,
                                  isExpanded: true,
                                  dropdownColor: AppColors.white,
                                  items: ['Active', 'Draft', 'Inactive'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                  onChanged: (v) => setModalState(() => statusVal = v!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price (Rp)', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                              child: TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: InputBorder.none)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Stock', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.neutral300), borderRadius: BorderRadius.circular(8)),
                              child: TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: InputBorder.none)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, null),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.neutral300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final String name = nameCtrl.text.trim();
                            final double? price = double.tryParse(priceCtrl.text.trim());
                            if (name.isNotEmpty && price != null) {
                              Navigator.pop(
                                ctx,
                                ProductModel(
                                  id: product.id,
                                  name: name,
                                  description: descCtrl.text.trim(),
                                  category: categoryVal,
                                  price: price,
                                  stock: int.tryParse(stockCtrl.text.trim()),
                                  status: statusVal,
                                  icon: _getIconForCategory(categoryVal),
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
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (updated != null) {
      setState(() {
        final idx = _products.indexWhere((p) => p.id == product.id);
        if (idx != -1) {
          _products[idx] = updated;
        }
      });
      _triggerToast('Product Updated', '${updated.name} details saved', isSuccess: true);
    }
  }

  IconData _getIconForCategory(String category) {
    if (category == 'Burger') return Icons.lunch_dining_outlined;
    if (category == 'Fried Chicken') return Icons.kebab_dining_outlined;
    if (category == 'Drink') return Icons.local_drink_outlined;
    if (category == 'Snack') return Icons.cookie_outlined;
    return Icons.fastfood_outlined;
  }

  // Default Mock Products
  List<ProductModel> _generateMockProducts() {
    return [
      ProductModel(
        id: '#BP089N',
        name: 'Classic Crispyburger',
        description: 'Crispy chicken patty with lettuce and mayonnaise',
        category: 'Burger',
        stock: 120,
        price: 47500,
        status: 'Active',
        icon: Icons.lunch_dining_outlined,
        iconBgColor: const Color(0xFFFEF3C7),
      ),
      ProductModel(
        id: '#BP090N',
        name: 'Spicy Cheese Crispyburger',
        description: 'Crispy chicken with melted cheddar and jalapeño sauce',
        category: 'Burger',
        stock: 90,
        price: 52000,
        status: 'Active',
        icon: Icons.lunch_dining_outlined,
        iconBgColor: const Color(0xFFFDE68A),
      ),
      ProductModel(
        id: '#FC012A',
        name: 'Fried Chicken Bucket (6 Pcs)',
        description: 'Golden fried halal chicken with secret Asian spices',
        category: 'Fried Chicken',
        stock: 45,
        price: 115000,
        status: 'Active',
        icon: Icons.kebab_dining_outlined,
        iconBgColor: const Color(0xFFFFEDD5),
      ),
      ProductModel(
        id: '#FC015B',
        name: 'Hot & Spicy Chicken Wings',
        description: 'Marinated spicy chicken wings served with ranch dip',
        category: 'Fried Chicken',
        stock: 65,
        price: 42000,
        status: 'Draft',
        icon: Icons.kebab_dining_outlined,
        iconBgColor: const Color(0xFFFFD6A5),
      ),
      ProductModel(
        id: '#DR001X',
        name: 'Iced Green Tea Lemonade',
        description: 'Refreshing jasmine green tea infused with real lemon juice',
        category: 'Drink',
        stock: 200,
        price: 22000,
        status: 'Active',
        icon: Icons.local_drink_outlined,
        iconBgColor: const Color(0xFFDCFCE7),
      ),
      ProductModel(
        id: '#DR004Y',
        name: 'Hong Kong Milk Tea',
        description: 'Authentic rich black tea with condensed sweet milk',
        category: 'Drink',
        stock: 150,
        price: 25000,
        status: 'Active',
        icon: Icons.local_drink_outlined,
        iconBgColor: const Color(0xFFE0E7FF),
      ),
      ProductModel(
        id: '#SN088Z',
        name: 'Golden French Fries',
        description: 'Crispy salted potatoes served with garlic dip',
        category: 'Snack',
        stock: null, // Unlimited / Not tracked
        price: 18000,
        status: 'Active',
        icon: Icons.cookie_outlined,
        iconBgColor: const Color(0xFFFEF08A),
      ),
      ProductModel(
        id: '#SN092K',
        name: 'Crispy Onion Rings',
        description: 'Battered onion rings with sweet chili glaze',
        category: 'Snack',
        stock: 0,
        price: 20000,
        status: 'Inactive',
        icon: Icons.cookie_outlined,
        iconBgColor: const Color(0xFFF1F5F9),
      ),
    ];
  }
}
