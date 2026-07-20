import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../main.dart';
import '../screens/login_screen.dart';
import '../screens/pos_tables_screen.dart';
import '../screens/pos_order_screen.dart';

class PosNavigationDrawer extends StatelessWidget {
  final Function(String)? onTableSelected;
  final String activeRoute;

  const PosNavigationDrawer({
    super.key,
    this.onTableSelected,
    this.activeRoute = 'pos',
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFEBEBEB), // Warna abu-abu muda sesuai mockup gambar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. BARIS PALING ATAS: Ikon Close saja
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.neutral500),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 4),

              // 2. LOGO DAN NAMA TOKO (Haji Wong Halal & Storefront Icon)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront,
                      color: AppColors.primary500,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Haji Wong Halal',
                      style: AppTypography.bodyLBold.copyWith(
                        color: AppColors.neutral900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Garis pembatas di bawah nama toko
              const Divider(color: AppColors.neutral300, thickness: 1.2),
              const SizedBox(height: 16),

              // 3. BAGIAN NAVIGASI UTAMA (TENGAH)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Menu Aktif: Point of Sale (Home icon)
                      _buildMenuItem(
                        icon: Icons.home_outlined,
                        label: 'Point of Sale',
                        isActive: activeRoute == 'pos',
                        onTap: activeRoute == 'pos' 
                            ? () => Navigator.pop(context) 
                            : () {
                                Navigator.pop(context); // Close drawer
                                Navigator.pop(context); // Pop back to dashboard
                              },
                      ),
                      const SizedBox(height: 12),
                      
                      // Menu-Menu Inaktif / Aktif: Order
                      _buildMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Order',
                        isActive: activeRoute == 'order',
                        onTap: activeRoute == 'order'
                            ? () => Navigator.pop(context)
                            : () {
                                Navigator.pop(context); // Close drawer
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PosOrderScreen()),
                                );
                              },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.people_outline,
                        label: 'Customer',
                        isActive: false,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.table_restaurant_outlined,
                        label: 'Tables',
                        isActive: false,
                        onTap: () async {
                          Navigator.pop(context); // Close drawer
                          final String? selectedTable = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(builder: (context) => const PosTablesScreen()),
                          );
                          if (selectedTable != null && onTableSelected != null) {
                            onTableSelected!(selectedTable);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.inventory_2_outlined,
                        label: 'Product',
                        isActive: false,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.analytics_outlined,
                        label: 'Report',
                        isActive: false,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.warehouse_outlined,
                        label: 'Inventory',
                        isActive: false,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        label: 'Setting',
                        isActive: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              // 4. BAGIAN FOOTER (BAWAH)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Garis pembatas di atas Logout
                  const Divider(color: AppColors.neutral300, thickness: 1.2),
                  const SizedBox(height: 12),

                  // Tombol Logout (Menjadi elemen paling bawah di drawer)
                  _buildMenuItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    isActive: false,
                    textColor: AppColors.neutral900,
                    onTap: () {
                      isStaffLoggedIn = false; // Reset status login global
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    final Color itemColor = isActive ? AppColors.white : AppColors.neutral800;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF333333) : Colors.transparent, // Hitam/abu gelap saat aktif
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: itemColor,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTypography.bodyMRegular.copyWith(
                    color: textColor ?? itemColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
