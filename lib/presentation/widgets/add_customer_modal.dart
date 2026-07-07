import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AddCustomerModal extends StatefulWidget {
  const AddCustomerModal({super.key});

  @override
  State<AddCustomerModal> createState() => _AddCustomerModalState();
}

class _AddCustomerModalState extends State<AddCustomerModal> {
  String _activeTab = 'New'; // 'New' atau 'Existing'
  final TextEditingController _nameController = TextEditingController();
  
  // Tab New State
  String _selectedGender = 'Men'; // Default terpilih

  // Tab Existing State
  String _searchQuery = '';
  String _selectedCustomerName = 'Olivia'; // Olivia terpilih sebagai default highlight

  // Data Pelanggan Terdaftar
  final List<Map<String, String>> _existingCustomers = [
    {'name': 'Liam', 'gender': 'Male'},
    {'name': 'Olivia', 'gender': 'Female'},
    {'name': 'Emma', 'gender': 'Female'},
    {'name': 'Noah', 'gender': 'Male'},
    {'name': 'Sophia', 'gender': 'Female'},
    {'name': 'Oliver', 'gender': 'Male'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      // Menghapus Center pembungkus agar dialog tidak terkompresi secara kasar oleh keyboard
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        // Membungkus seluruh dialog ke dalam SingleChildScrollView agar scrollable saat keyboard muncul
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. HEADER
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                child: Center(
                  child: Text(
                    'Add Customer',
                    style: AppTypography.bodyLBold.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 2. TAB NAVIGATION (Pill Toggle Opsi)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabPill('New'),
                      ),
                      Expanded(
                        child: _buildTabPill('Existing'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. BODY CONTENT (New vs Existing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _activeTab == 'New' ? _buildNewTabContent() : _buildExistingTabContent(),
              ),
              const SizedBox(height: 12),

              const Divider(height: 1, thickness: 1, color: AppColors.neutral200),

              // 4. FOOTER / AKSI
              Padding(
                padding: const EdgeInsets.all(24.0),
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
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          String customerName = '';
                          if (_activeTab == 'New') {
                            customerName = _nameController.text.trim();
                            if (customerName.isEmpty) {
                              customerName = 'Stevan Cornerlius';
                            }
                          } else {
                            customerName = _selectedCustomerName;
                          }
                          Navigator.pop(context, customerName);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildTabPill(String tabName) {
    final bool isActive = _activeTab == tabName;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = tabName;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          tabName,
          style: AppTypography.bodySRegular.copyWith(
            color: isActive ? AppColors.primary500 : AppColors.neutral500,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Konten Tab New Customer
  Widget _buildNewTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Nama
        Text(
          'Name *',
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral800,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Misal: Stevan Cornerlius',
            hintStyle: AppTypography.bodySRegular.copyWith(color: AppColors.neutral400),
            fillColor: AppColors.neutral100,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.neutral200, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.neutral200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Pilihan Gender (Men, Women, Prefer not saying)
        Text(
          'Gender',
          style: AppTypography.bodySRegular.copyWith(
            color: AppColors.neutral800,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildGenderCard('Men')),
            const SizedBox(width: 8),
            Expanded(child: _buildGenderCard('Women')),
            const SizedBox(width: 8),
            Expanded(child: _buildGenderCard('Prefer not saying')),
          ],
        ),
        const SizedBox(height: 32), // Padding seimbang
      ],
    );
  }

  Widget _buildGenderCard(String gender) {
    final bool isSelected = _selectedGender == gender;
    final Color strokeColor = isSelected ? AppColors.primary500 : AppColors.neutral200;
    final Color bgColor = isSelected ? AppColors.primary500.withValues(alpha: 0.1) : AppColors.white;
    final Color contentColor = isSelected ? AppColors.primary500 : AppColors.neutral800;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: strokeColor, width: isSelected ? 1.8 : 1.2),
        ),
        alignment: Alignment.center,
        child: Text(
          gender,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: AppTypography.bodyXsRegular.copyWith(
            color: contentColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Konten Tab Existing Customer
  Widget _buildExistingTabContent() {
    final filteredList = _existingCustomers.where((customer) {
      final name = customer['name']?.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        // Search Bar kecil
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.neutral200, width: 1.5),
          ),
          child: TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: AppColors.neutral400, size: 18),
              hintText: 'Search...',
              hintStyle: AppTypography.bodySRegular.copyWith(color: AppColors.neutral400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // List Pelanggan
        Container(
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final customer = filteredList[index];
              final String name = customer['name'] ?? '';
              final String gender = customer['gender'] ?? '';
              final bool isSelected = _selectedCustomerName == name;

              final Color bgColor = isSelected ? AppColors.primary500.withValues(alpha: 0.1) : Colors.transparent;
              final Color strokeColor = isSelected ? AppColors.primary500 : Colors.transparent;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCustomerName = name;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border(
                      bottom: const BorderSide(color: AppColors.neutral200),
                      left: BorderSide(color: strokeColor, width: isSelected ? 4 : 0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: AppTypography.bodySRegular.copyWith(
                          color: AppColors.neutral900,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            gender == 'Male' ? Icons.male : Icons.female,
                            size: 16,
                            color: gender == 'Male' ? Colors.blue : Colors.pink,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            gender,
                            style: AppTypography.bodyXsRegular.copyWith(
                              color: AppColors.neutral500,
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
        ),
      ],
    );
  }
}
