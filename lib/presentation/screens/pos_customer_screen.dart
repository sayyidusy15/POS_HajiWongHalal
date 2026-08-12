import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/pos_navigation_drawer.dart';
import '../widgets/custom_success_toast.dart';

class CustomerModel {
  final String id;
  String firstName;
  String lastName;
  String gender; // 'Male', 'Female'
  String phoneNumber;
  bool isMember; // true = Yes, false = No
  String expiryType; // 'Lifetime', '1 Year', '6 Months', '1 Month', '3 Weeks', '5 Days', 'Custom'
  DateTime? expiryDate;
  DateTime dateAdded;

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phoneNumber,
    required this.isMember,
    this.expiryType = 'Lifetime',
    this.expiryDate,
    required this.dateAdded,
  });

  String get fullName => '$firstName $lastName';

  String get memberExpiryFormatted {
    if (!isMember) return '-';
    if (expiryType == 'Lifetime' || expiryDate == null) return 'Lifetime';

    final now = DateTime.now();
    if (expiryDate!.isBefore(now)) return 'Expired';

    final diff = expiryDate!.difference(now);
    if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).round();
      return '$months month${months > 1 ? 's' : ''} left';
    } else if (diff.inDays >= 7) {
      final weeks = (diff.inDays / 7).round();
      return '$weeks week${weeks > 1 ? 's' : ''} left';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} left';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} left';
    } else {
      return '${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} left';
    }
  }
}

class PosCustomerScreen extends StatefulWidget {
  const PosCustomerScreen({super.key});

  @override
  State<PosCustomerScreen> createState() => _PosCustomerScreenState();
}

class _PosCustomerScreenState extends State<PosCustomerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // State Management
  String _searchQuery = '';
  String _sortOrder = 'Default'; // 'Default', 'First Name (A-Z)', 'First Name (Z-A)', 'Last Name (A-Z)', 'Last Name (Z-A)'

  // Filter State
  String _filterGender = 'All'; // 'All', 'Male', 'Female'
  String _filterMemberStatus = 'All'; // 'All', 'Yes', 'No'

  // Pagination State
  int _rowsPerPage = 10;
  int _currentPage = 1;

  // Toast Notification State
  bool _showToast = false;
  String _toastTitle = '';
  String _toastSubtitle = '';
  bool _toastIsSuccess = true;

  // Mock Customers Data
  late List<CustomerModel> _customers;

  @override
  void initState() {
    super.initState();
    _customers = _generateMockCustomers();
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

  List<CustomerModel> _generateMockCustomers() {
    final now = DateTime.now();
    return [
      CustomerModel(
        id: '#CST-001',
        firstName: 'Dian',
        lastName: 'Rahmani',
        gender: 'Female',
        phoneNumber: '+62 812-3456-7890',
        isMember: true,
        expiryType: 'Lifetime',
        dateAdded: DateTime(2026, 6, 12, 10, 30),
      ),
      CustomerModel(
        id: '#CST-002',
        firstName: 'Brian',
        lastName: 'Susanto',
        gender: 'Male',
        phoneNumber: '+62 813-9876-5432',
        isMember: true,
        expiryType: '1 Month',
        expiryDate: now.add(const Duration(days: 28)),
        dateAdded: DateTime(2026, 6, 15, 14, 20),
      ),
      CustomerModel(
        id: '#CST-003',
        firstName: 'Jonathan',
        lastName: 'Joestar',
        gender: 'Male',
        phoneNumber: '+62 811-2233-4455',
        isMember: false,
        expiryType: 'None',
        dateAdded: DateTime(2026, 6, 20, 16, 45),
      ),
      CustomerModel(
        id: '#CST-004',
        firstName: 'Olivia',
        lastName: 'Wong',
        gender: 'Female',
        phoneNumber: '+62 857-1122-3344',
        isMember: true,
        expiryType: '3 Weeks',
        expiryDate: now.add(const Duration(days: 19)),
        dateAdded: DateTime(2026, 7, 1, 9, 15),
      ),
      CustomerModel(
        id: '#CST-005',
        firstName: 'Stevan',
        lastName: 'Cornerlius',
        gender: 'Male',
        phoneNumber: '+62 818-7766-5544',
        isMember: true,
        expiryType: '5 Days',
        expiryDate: now.add(const Duration(days: 4)),
        dateAdded: DateTime(2026, 7, 5, 11, 0),
      ),
      CustomerModel(
        id: '#CST-006',
        firstName: 'Alice',
        lastName: 'Subandono',
        gender: 'Female',
        phoneNumber: '+62 819-3344-5566',
        isMember: false,
        expiryType: 'None',
        dateAdded: DateTime(2026, 7, 10, 15, 30),
      ),
      CustomerModel(
        id: '#CST-007',
        firstName: 'Alexander',
        lastName: 'Halim',
        gender: 'Male',
        phoneNumber: '+62 812-9988-7766',
        isMember: true,
        expiryType: '1 Year',
        expiryDate: now.add(const Duration(days: 340)),
        dateAdded: DateTime(2026, 7, 12, 13, 10),
      ),
      CustomerModel(
        id: '#CST-008',
        firstName: 'Charlotte',
        lastName: 'Aditya',
        gender: 'Female',
        phoneNumber: '+62 856-4455-6677',
        isMember: true,
        expiryType: '6 Months',
        expiryDate: now.add(const Duration(days: 160)),
        dateAdded: DateTime(2026, 7, 15, 17, 25),
      ),
    ];
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    // Apply Filter & Search (Search by name only)
    List<CustomerModel> filtered = _customers.where((c) {
      // 1. Search Query (First Name or Last Name)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchFirst = c.firstName.toLowerCase().contains(query);
        final matchLast = c.lastName.toLowerCase().contains(query);
        if (!matchFirst && !matchLast) return false;
      }

      // 2. Gender Filter
      if (_filterGender != 'All' && c.gender != _filterGender) {
        return false;
      }

      // 3. Member Status Filter
      if (_filterMemberStatus == 'Yes' && !c.isMember) return false;
      if (_filterMemberStatus == 'No' && c.isMember) return false;

      return true;
    }).toList();

    // Apply Sorting (First Name / Last Name)
    if (_sortOrder == 'First Name (A-Z)') {
      filtered.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
    } else if (_sortOrder == 'First Name (Z-A)') {
      filtered.sort((a, b) => b.firstName.toLowerCase().compareTo(a.firstName.toLowerCase()));
    } else if (_sortOrder == 'Last Name (A-Z)') {
      filtered.sort((a, b) => a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase()));
    } else if (_sortOrder == 'Last Name (Z-A)') {
      filtered.sort((a, b) => b.lastName.toLowerCase().compareTo(a.lastName.toLowerCase()));
    }

    // Pagination calculations
    final int totalItems = filtered.length;
    final int totalPages = (totalItems / _rowsPerPage).ceil().clamp(1, 999);
    final int startIndex = ((_currentPage - 1) * _rowsPerPage).clamp(0, totalItems);
    final int endIndex = (startIndex + _rowsPerPage).clamp(0, totalItems);
    final List<CustomerModel> pageItems = startIndex < totalItems
        ? filtered.sublist(startIndex, endIndex)
        : [];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Customer Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          // Search bar (by Customer Name only)
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
                  const Icon(
                    Icons.search,
                    size: 18,
                    color: AppColors.neutral500,
                  ),
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
                        hintText: 'Search name...',
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
          Center(child: _buildAddCustomerButton()),
          const SizedBox(width: 24),
        ],
      ),
      drawer: const PosNavigationDrawer(activeRoute: 'customer'),
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
                  ),
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
                        _buildColumnHead('FIRST NAME', 2),
                        _buildColumnHead('LAST NAME', 2),
                        _buildColumnHead('GENDER', 2),
                        _buildColumnHead('PHONE NUMBER', 3),
                        _buildColumnHead('MEMBER STATUS', 2),
                        _buildColumnHead('MEMBER EXPIRY DATE', 3),
                        _buildColumnHead('DATE ADDED', 3),
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
                              return _buildCustomerRow(pageItems[index]);
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: _currentPage > 1
                                  ? () => setState(() => _currentPage--)
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                              color: AppColors.neutral800,
                            ),
                            Text(
                              '$_currentPage of $totalPages',
                              style: AppTypography.bodySRegular.copyWith(
                                color: AppColors.neutral800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: _currentPage < totalPages
                                  ? () => setState(() => _currentPage++)
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                              color: AppColors.neutral800,
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

          // Toast Notification Overlay
          if (_showToast)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: CustomSuccessToast(
                  title: _toastTitle,
                  subtitle: _toastSubtitle,
                  highlightText: '',
                  isSuccess: _toastIsSuccess,
                  onDismiss: () {
                    setState(() {
                      _showToast = false;
                    });
                  },
                ),
              ),
            ),
        ],
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

  Widget _buildCustomerRow(CustomerModel customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          // 1. ID
          Expanded(
            flex: 2,
            child: Text(
              customer.id,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          // 2. FIRST NAME
          Expanded(
            flex: 2,
            child: Text(
              customer.firstName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // 3. LAST NAME
          Expanded(
            flex: 2,
            child: Text(
              customer.lastName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // 4. GENDER
          Expanded(
            flex: 2,
            child: Text(
              customer.gender,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
            ),
          ),

          // 5. PHONE NUMBER
          Expanded(
            flex: 3,
            child: Text(
              customer.phoneNumber,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800),
            ),
          ),

          // 6. MEMBER STATUS (Yes / No badge)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: customer.isMember ? const Color(0xFFF0FDF4) : AppColors.neutral100,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: customer.isMember ? const Color(0xFFBBF7D0) : AppColors.neutral300,
                    ),
                  ),
                  child: Text(
                    customer.isMember ? 'Yes' : 'No',
                    style: AppTypography.bodyXsRegular.copyWith(
                      color: customer.isMember ? const Color(0xFF15803D) : AppColors.neutral600,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 7. MEMBER EXPIRY DATE
          Expanded(
            flex: 3,
            child: Text(
              customer.memberExpiryFormatted,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(
                color: customer.isMember && customer.memberExpiryFormatted != 'Expired'
                    ? AppColors.primary500
                    : customer.memberExpiryFormatted == 'Expired'
                        ? AppColors.error500
                        : AppColors.neutral500,
                fontWeight: customer.isMember ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          // 8. DATE ADDED
          Expanded(
            flex: 3,
            child: Text(
              _formatDateTime(customer.dateAdded),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral700),
            ),
          ),

          // 9. ACTION (3 DOTS KEBAB)
          Expanded(
            flex: 1,
            child: Center(
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.neutral700),
                tooltip: 'Actions',
                onSelected: (val) {
                  if (val == 'edit') {
                    _showAddEditCustomerModal(customer: customer);
                  } else if (val == 'delete') {
                    _confirmDeleteCustomer(customer);
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18, color: AppColors.neutral700),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: AppColors.error500),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppColors.error500)),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_search_outlined, size: 48, color: AppColors.neutral400),
          ),
          const SizedBox(height: 16),
          Text(
            'No Customers Found',
            style: AppTypography.bodyLBold.copyWith(color: AppColors.neutral800),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search query or filter options.',
            style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      onSelected: (val) {
        setState(() {
          _sortOrder = val;
        });
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 'Default', child: Text('Default')),
        const PopupMenuItem(value: 'First Name (A-Z)', child: Text('First Name (A-Z)')),
        const PopupMenuItem(value: 'First Name (Z-A)', child: Text('First Name (Z-A)')),
        const PopupMenuItem(value: 'Last Name (A-Z)', child: Text('Last Name (A-Z)')),
        const PopupMenuItem(value: 'Last Name (Z-A)', child: Text('Last Name (Z-A)')),
      ],
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.neutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.swap_vert, size: 18, color: AppColors.neutral700),
            const SizedBox(width: 6),
            Text(
              _sortOrder == 'Default' ? 'Sort' : _sortOrder,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    final bool isFiltered = _filterGender != 'All' || _filterMemberStatus != 'All';
    return OutlinedButton.icon(
      onPressed: _showFilterDialog,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
        side: BorderSide(
          color: isFiltered ? AppColors.primary500 : AppColors.neutral300,
          width: isFiltered ? 1.5 : 1.0,
        ),
        backgroundColor: isFiltered ? AppColors.primary500.withValues(alpha: 0.05) : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(
        Icons.filter_list,
        size: 18,
        color: isFiltered ? AppColors.primary500 : AppColors.neutral700,
      ),
      label: Text(
        'Filter',
        style: AppTypography.bodySRegular.copyWith(
          color: isFiltered ? AppColors.primary500 : AppColors.neutral800,
          fontWeight: isFiltered ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAddCustomerButton() {
    return ElevatedButton.icon(
      onPressed: () => _showAddEditCustomerModal(),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 40),
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.add, size: 18),
      label: Text(
        'Add Customer',
        style: AppTypography.bodySRegular.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showFilterDialog() {
    String tempGender = _filterGender;
    String tempMemberStatus = _filterMemberStatus;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Customers',
                        style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, color: AppColors.neutral500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Gender Filter
                  Text(
                    'Gender',
                    style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['All', 'Male', 'Female'].map((g) {
                      final isSelected = tempGender == g;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(g),
                          selected: isSelected,
                          selectedColor: AppColors.primary500.withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary500 : AppColors.neutral800,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (sel) {
                            if (sel) setModalState(() => tempGender = g);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Member Status Filter
                  Text(
                    'Member Status',
                    style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['All', 'Yes', 'No'].map((m) {
                      final isSelected = tempMemberStatus == m;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(m == 'Yes' ? 'Member (Yes)' : m == 'No' ? 'Non-Member (No)' : 'All'),
                          selected: isSelected,
                          selectedColor: AppColors.primary500.withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary500 : AppColors.neutral800,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (sel) {
                            if (sel) setModalState(() => tempMemberStatus = m);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filterGender = 'All';
                              _filterMemberStatus = 'All';
                              _currentPage = 1;
                            });
                            Navigator.pop(ctx);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _filterGender = tempGender;
                              _filterMemberStatus = tempMemberStatus;
                              _currentPage = 1;
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            backgroundColor: AppColors.primary500,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Apply Filter', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddEditCustomerModal({CustomerModel? customer}) {
    final bool isEdit = customer != null;
    final firstNameController = TextEditingController(text: customer?.firstName ?? '');
    final lastNameController = TextEditingController(text: customer?.lastName ?? '');
    final phoneController = TextEditingController(text: customer?.phoneNumber ?? '');
    String selectedGender = customer?.gender ?? 'Male';
    bool isMember = customer?.isMember ?? false;
    String selectedExpiryType = customer?.expiryType ?? 'Lifetime';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 480,
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
                      Text(
                        isEdit ? 'Edit Customer' : 'Add New Customer',
                        style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, color: AppColors.neutral500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // First Name & Last Name
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('First Name *', style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                hintText: 'Enter first name',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                            Text('Last Name *', style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                hintText: 'Enter last name',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Gender & Phone Number
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Gender', style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: selectedGender,
                              items: const [
                                DropdownMenuItem(value: 'Male', child: Text('Male')),
                                DropdownMenuItem(value: 'Female', child: Text('Female')),
                              ],
                              onChanged: (val) {
                                if (val != null) setModalState(() => selectedGender = val);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                            Text('Phone Number', style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '+62 812...',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Member Status Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Member Status', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold)),
                          Text(
                            isMember ? 'Customer is a registered member' : 'Customer is a regular guest',
                            style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                          ),
                        ],
                      ),
                      Switch(
                        value: isMember,
                        activeColor: AppColors.primary500,
                        onChanged: (val) {
                          setModalState(() {
                            isMember = val;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  // Member Expiry Option (If Member is Yes)
                  if (isMember) ...[
                    const SizedBox(height: 16),
                    Text('Member Expiry Duration', style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral700, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedExpiryType,
                      items: const [
                        DropdownMenuItem(value: 'Lifetime', child: Text('Lifetime (Never Expires)')),
                        DropdownMenuItem(value: '1 Year', child: Text('1 Year')),
                        DropdownMenuItem(value: '6 Months', child: Text('6 Months')),
                        DropdownMenuItem(value: '1 Month', child: Text('1 Month')),
                        DropdownMenuItem(value: '3 Weeks', child: Text('3 Weeks')),
                        DropdownMenuItem(value: '5 Days', child: Text('5 Days')),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedExpiryType = val);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final first = firstNameController.text.trim();
                          final last = lastNameController.text.trim();
                          if (first.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('First Name is required!')),
                            );
                            return;
                          }

                          DateTime? expDate;
                          final now = DateTime.now();
                          if (isMember) {
                            if (selectedExpiryType == '1 Year') {
                              expDate = now.add(const Duration(days: 365));
                            } else if (selectedExpiryType == '6 Months') {
                              expDate = now.add(const Duration(days: 180));
                            } else if (selectedExpiryType == '1 Month') {
                              expDate = now.add(const Duration(days: 30));
                            } else if (selectedExpiryType == '3 Weeks') {
                              expDate = now.add(const Duration(days: 21));
                            } else if (selectedExpiryType == '5 Days') {
                              expDate = now.add(const Duration(days: 5));
                            }
                          }

                          setState(() {
                            if (isEdit) {
                              customer.firstName = first;
                              customer.lastName = last;
                              customer.gender = selectedGender;
                              customer.phoneNumber = phoneController.text.trim();
                              customer.isMember = isMember;
                              customer.expiryType = isMember ? selectedExpiryType : 'None';
                              customer.expiryDate = expDate;
                              _triggerToast('Customer Updated', '$first $last details updated successfully.');
                            } else {
                              final newId = '#CST-00${_customers.length + 1}';
                              _customers.insert(
                                0,
                                CustomerModel(
                                  id: newId,
                                  firstName: first,
                                  lastName: last,
                                  gender: selectedGender,
                                  phoneNumber: phoneController.text.trim(),
                                  isMember: isMember,
                                  expiryType: isMember ? selectedExpiryType : 'None',
                                  expiryDate: expDate,
                                  dateAdded: DateTime.now(),
                                ),
                              );
                              _triggerToast('Customer Created', '$first $last added to customer list.');
                            }
                          });

                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          backgroundColor: AppColors.primary500,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          isEdit ? 'Save Changes' : 'Add Customer',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteCustomer(CustomerModel customer) {
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
                child: const Icon(Icons.delete_outline, color: AppColors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Customer?',
                style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete ${customer.fullName}? This action cannot be undone.',
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
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _customers.removeWhere((c) => c.id == customer.id);
                          _triggerToast('Customer Deleted', '${customer.fullName} removed from database.', isSuccess: false);
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        backgroundColor: AppColors.error500,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
