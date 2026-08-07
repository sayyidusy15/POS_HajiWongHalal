import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/pos_navigation_drawer.dart';
import '../widgets/custom_success_toast.dart';

class PosRecentOrdersScreen extends StatefulWidget {
  const PosRecentOrdersScreen({super.key});

  @override
  State<PosRecentOrdersScreen> createState() => _PosRecentOrdersScreenState();
}

class _PosRecentOrdersScreenState extends State<PosRecentOrdersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Pagination State
  int _rowsPerPage = 10;
  int _currentPage = 1;

  // State untuk Toast Notification (Konsisten dengan page lain)
  bool _showToast = false;
  String _toastTitle = '';
  String _toastSubtitle = '';
  bool _toastIsSuccess = true;

  // Mock data untuk 30 transaksi
  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '#201OE10',
      'status': 'In Progress',
      'statusColor': AppColors.warning500,
      'date': 'Oct 16, 2024 09:31 AM',
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
      'date': 'Oct 16, 2024 11:32 AM',
      'customer': 'Sinta Dewi',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '-',
      'total': '-',
    },
    {
      'id': '#201OE11',
      'status': 'In Progress',
      'statusColor': AppColors.warning500,
      'date': 'Oct 16, 2024 11:17 AM',
      'customer': '-',
      'type': 'Take Away',
      'payment': 'Cash',
      'qty': '12',
      'total': 'Rp 110.800',
    },
    {
      'id': '#926MN68',
      'status': 'Open',
      'statusColor': AppColors.info500,
      'date': 'Oct 16, 2024 10:54 AM',
      'customer': 'Adi Nugroho',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '-',
      'total': '-',
    },
    {
      'id': '#201OE12',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 11:15 AM',
      'customer': 'Lia Wijaya',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '3',
      'total': 'Rp 11.000',
    },
    {
      'id': '#201OE13',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 12:05 PM',
      'customer': 'Budi Santoso',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '4',
      'total': 'Rp 45.000',
    },
    {
      'id': '#926MN69',
      'status': 'Open',
      'statusColor': AppColors.info500,
      'date': 'Oct 16, 2024 12:10 PM',
      'customer': 'Ani Wijaya',
      'type': 'Take Away',
      'payment': 'Cash',
      'qty': '-',
      'total': '-',
    },
    {
      'id': '#201OE14',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 12:20 PM',
      'customer': 'Hendra',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '8',
      'total': 'Rp 98.000',
    },
    {
      'id': '#201OE15',
      'status': 'In Progress',
      'statusColor': AppColors.warning500,
      'date': 'Oct 16, 2024 12:35 PM',
      'customer': 'Rina Lestari',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '2',
      'total': 'Rp 22.000',
    },
    {
      'id': '#201OE16',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 12:45 PM',
      'customer': 'Eko Prasetyo',
      'type': 'Take Away',
      'payment': 'QRIS',
      'qty': '6',
      'total': 'Rp 67.500',
    },
    // Halaman 2 data
    {
      'id': '#201OE17',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 01:10 PM',
      'customer': 'Dewi Sartika',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '3',
      'total': 'Rp 33.000',
    },
    {
      'id': '#926MN70',
      'status': 'Open',
      'statusColor': AppColors.info500,
      'date': 'Oct 16, 2024 01:15 PM',
      'customer': 'Joko Widodo',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '-',
      'total': '-',
    },
    {
      'id': '#201OE18',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 01:30 PM',
      'customer': 'Megawati',
      'type': 'Take Away',
      'payment': 'Cash',
      'qty': '5',
      'total': 'Rp 55.000',
    },
    {
      'id': '#926MN71',
      'status': 'Open',
      'statusColor': AppColors.info500,
      'date': 'Oct 16, 2024 01:45 PM',
      'customer': 'SBY',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '-',
      'total': '-',
    },
    {
      'id': '#201OE19',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 02:00 PM',
      'customer': 'Prabowo',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '10',
      'total': 'Rp 150.000',
    },
    {
      'id': '#201OE20',
      'status': 'In Progress',
      'statusColor': AppColors.warning500,
      'date': 'Oct 16, 2024 02:15 PM',
      'customer': 'Gibran',
      'type': 'Take Away',
      'payment': 'QRIS',
      'qty': '1',
      'total': 'Rp 15.000',
    },
    {
      'id': '#201OE21',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 02:30 PM',
      'customer': 'Anies Baswedan',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '7',
      'total': 'Rp 88.000',
    },
    {
      'id': '#926MN72',
      'status': 'Open',
      'statusColor': AppColors.info500,
      'date': 'Oct 16, 2024 02:40 PM',
      'customer': 'Ganjar Pranowo',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '-',
      'total': '-',
    },
    {
      'id': '#201OE22',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 03:00 PM',
      'customer': 'Mahfud MD',
      'type': 'Take Away',
      'payment': 'Cash',
      'qty': '4',
      'total': 'Rp 48.000',
    },
    {
      'id': '#201OE23',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 03:15 PM',
      'customer': 'Muhaimin',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '2',
      'total': 'Rp 25.000',
    },
    // Halaman 3 data
    {
      'id': '#201OE24',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 03:30 PM',
      'customer': 'Ridwan Kamil',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '6',
      'total': 'Rp 75.000',
    },
    {
      'id': '#201OE25',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 03:45 PM',
      'customer': 'Sandiaga Uno',
      'type': 'Take Away',
      'payment': 'Cash',
      'qty': '3',
      'total': 'Rp 36.000',
    },
    {
      'id': '#926MN73',
      'status': 'Open',
      'statusColor': AppColors.info500,
      'date': 'Oct 16, 2024 04:00 PM',
      'customer': 'Erick Thohir',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '-',
      'total': '-',
    },
    {
      'id': '#201OE26',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 04:15 PM',
      'customer': 'Luhut Binsar',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '15',
      'total': 'Rp 220.000',
    },
    {
      'id': '#201OE27',
      'status': 'In Progress',
      'statusColor': AppColors.warning500,
      'date': 'Oct 16, 2024 04:30 PM',
      'customer': 'Sri Mulyani',
      'type': 'Take Away',
      'payment': 'Cash',
      'qty': '4',
      'total': 'Rp 44.000',
    },
    {
      'id': '#201OE28',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 04:45 PM',
      'customer': 'Retno Marsudi',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '5',
      'total': 'Rp 65.000',
    },
    {
      'id': '#926MN74',
      'status': 'Open',
      'statusColor': AppColors.info500,
      'date': 'Oct 16, 2024 05:00 PM',
      'customer': 'Basuki H.',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '-',
      'total': '-',
    },
    {
      'id': '#201OE29',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 05:15 PM',
      'customer': 'Ahok',
      'type': 'Take Away',
      'payment': 'QRIS',
      'qty': '3',
      'total': 'Rp 39.000',
    },
    {
      'id': '#201OE30',
      'status': 'Completed',
      'statusColor': AppColors.primary500,
      'date': 'Oct 16, 2024 05:30 PM',
      'customer': 'Djarot Saiful',
      'type': 'Dine In',
      'payment': 'Cash',
      'qty': '2',
      'total': 'Rp 24.000',
    },
    {
      'id': '#926MN75',
      'status': 'Open',
      'statusColor': AppColors.info500,
      'date': 'Oct 16, 2024 05:45 PM',
      'customer': 'Tri Rismaharini',
      'type': 'Dine In',
      'payment': 'QRIS',
      'qty': '-',
      'total': '-',
    },
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

  @override
  Widget build(BuildContext context) {
    final int totalItems = _allOrders.length;
    final int totalPages = (totalItems / _rowsPerPage).ceil();
    _currentPage = _currentPage.clamp(1, totalPages);

    final int startIndex = (_currentPage - 1) * _rowsPerPage;
    final int endIndex = (startIndex + _rowsPerPage).clamp(0, totalItems);
    final List<Map<String, dynamic>> displayedOrders = _allOrders.sublist(startIndex, endIndex);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
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
          'Recent Orders',
          style: AppTypography.h4Bold.copyWith(color: AppColors.neutral900),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
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
                        'Order Log',
                        style: AppTypography.bodyLBold.copyWith(
                          color: AppColors.neutral900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total $totalItems Records',
                        style: AppTypography.bodyXsRegular.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Responsive Table
                  LayoutBuilder(
                    builder: (context, constraints) {
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
                              ...displayedOrders.map((ord) {
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
                                    // Perbaikan: Menghilangkan background color dari payment method
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
                  const SizedBox(height: 24),
                  
                  // Pagination Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rows per page dropdown
                      Row(
                        children: [
                          Text(
                            'Rows per page:',
                            style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.neutral300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _rowsPerPage,
                                icon: const Icon(Icons.arrow_drop_down, size: 18),
                                style: AppTypography.bodyXsBold.copyWith(color: AppColors.neutral800),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _rowsPerPage = newValue;
                                      _currentPage = 1; // reset page
                                    });
                                  }
                                },
                                items: [10, 20, 30].map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text('$value'),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Nav buttons
                      Row(
                        children: [
                          Text(
                            'Page $_currentPage of $totalPages',
                            style: AppTypography.bodyXsMedium.copyWith(color: AppColors.neutral600),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: _currentPage > 1
                                ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.chevron_left),
                            style: IconButton.styleFrom(
                              side: const BorderSide(color: AppColors.neutral300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _currentPage < totalPages
                                ? () {
                                    setState(() {
                                      _currentPage++;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.chevron_right),
                            style: IconButton.styleFrom(
                              side: const BorderSide(color: AppColors.neutral300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
}
