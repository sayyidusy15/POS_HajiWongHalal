import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/app_button.dart';

class Product {
  final String name;
  final double price;
  final String category;
  final IconData icon;

  const Product({
    required this.name,
    required this.price,
    required this.category,
    required this.icon,
  });
}

class OrderItem {
  final Product product;
  int quantity;

  OrderItem({
    required this.product,
    this.quantity = 1,
  });
}

class PosDashboardScreen extends StatefulWidget {
  const PosDashboardScreen({super.key});

  @override
  State<PosDashboardScreen> createState() => _PosDashboardScreenState();
}

class _PosDashboardScreenState extends State<PosDashboardScreen> {
  String _activeCategory = 'All Menu';
  String _searchQuery = '';
  bool _isDineIn = true;
  
  // Keranjang Belanja Dinamis
  final List<OrderItem> _cart = [];

  // Daftar Produk (Dikonversi ke mata uang Rupiah)
  final List<Product> _products = [
    const Product(name: 'Deluxe Crispy Burger', price: 45000, category: 'Burger', icon: Icons.lunch_dining_outlined),
    const Product(name: 'Classic Crispy Burger', price: 30000, category: 'Burger', icon: Icons.lunch_dining_outlined),
    const Product(name: 'Special Crispy Burger', price: 38000, category: 'Burger', icon: Icons.lunch_dining_outlined),
    const Product(name: 'Special Burger', price: 42000, category: 'Burger', icon: Icons.lunch_dining_outlined),
    const Product(name: 'Spicy Chicken Burger', price: 35000, category: 'Burger', icon: Icons.lunch_dining_outlined),
    const Product(name: 'Cheeseburger', price: 32000, category: 'Burger', icon: Icons.lunch_dining_outlined),
    const Product(name: 'Combo Drumstick', price: 55000, category: 'Fried Chicken', icon: Icons.restaurant_outlined),
    const Product(name: 'Double Cheeseburger', price: 48000, category: 'Burger', icon: Icons.lunch_dining_outlined),
    const Product(name: 'Coca Cola', price: 12000, category: 'Drink', icon: Icons.local_drink_outlined),
    const Product(name: 'Classic Cheeseburger', price: 33000, category: 'Burger', icon: Icons.lunch_dining_outlined),
    const Product(name: '3 Cheese Wings', price: 28000, category: 'Fried Chicken', icon: Icons.restaurant_outlined),
    const Product(name: 'Sprite', price: 12000, category: 'Drink', icon: Icons.local_drink_outlined),
    const Product(name: 'Chocolate Milkshake', price: 22000, category: 'Drink', icon: Icons.local_drink_outlined),
    const Product(name: '3 Drumstick', price: 35000, category: 'Fried Chicken', icon: Icons.restaurant_outlined),
    const Product(name: 'Cappuccino', price: 25000, category: 'Coffee', icon: Icons.coffee_outlined),
  ];

  // Daftar Kategori beserta Ikonnya
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All Menu', 'icon': Icons.flatware_outlined},
    {'name': 'Burger', 'icon': Icons.lunch_dining_outlined},
    {'name': 'Fried Chicken', 'icon': Icons.restaurant_outlined},
    {'name': 'Drink', 'icon': Icons.local_drink_outlined},
    {'name': 'Coffee', 'icon': Icons.coffee_outlined},
    {'name': 'Dessert', 'icon': Icons.icecream_outlined},
    {'name': 'Other Menu', 'icon': Icons.grid_view_outlined},
  ];

  // Format angka ke format Rupiah (contoh: Rp 45.000)
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

  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.name == product.name);
      if (index >= 0) {
        _cart[index].quantity++;
      } else {
        _cart.add(OrderItem(product: product));
      }
    });
  }

  void _removeFromCart(OrderItem item) {
    setState(() {
      _cart.removeWhere((cartItem) => cartItem.product.name == item.product.name);
    });
  }

  void _updateQuantity(OrderItem item, int delta) {
    setState(() {
      final index = _cart.indexWhere((cartItem) => cartItem.product.name == item.product.name);
      if (index >= 0) {
        _cart[index].quantity += delta;
        if (_cart[index].quantity <= 0) {
          _cart.removeAt(index);
        }
      }
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }

  double get _subtotal {
    return _cart.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double get _tax {
    return _subtotal * 0.1; // Pajak 10%
  }

  double get _total {
    return _subtotal + _tax;
  }

  // Mendapatkan kuantitas item produk tertentu yang ada di keranjang
  int _getProductQuantityInCart(Product product) {
    final index = _cart.indexWhere((item) => item.product.name == product.name);
    if (index >= 0) {
      return _cart[index].quantity;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products.where((p) {
      final matchesCategory = _activeCategory == 'All Menu' || p.category == _activeCategory;
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false, // Mencegah keyboard memicu overflow vertikal
      backgroundColor: AppColors.neutral100,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SISI KIRI & AREA TENGAH: Dibungkus Column agar Nav Bar di atas tidak menutupi Sidebar Kanan
            Expanded(
              child: Column(
                children: [
                  // 1. TOP NAVIGATION BAR (Hanya membentang di kiri & tengah)
                  _buildTopNavBar(),
                  
                  // 2. AREA SIDEBAR KATEGORI & GRID PRODUK
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSidebarLeft(),
                        Expanded(
                          flex: 6,
                          child: _buildProductArea(filteredProducts),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // SISI KANAN: Panel Order Details (Keranjang memanjang penuh dari paling atas ke bawah layar)
            _buildSidebarRight(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.neutral200, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.neutral800),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary500.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront,
              color: AppColors.primary500,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Haji Wong Halal',
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyLBold.copyWith(color: AppColors.neutral900),
            ),
          ),
          const Spacer(), // Mendorong search bar ke ujung kanan navbar
          Container(
            width: 340, // Lebar ideal agar tidak kependekan
            height: 44, // Tinggi standar agar simetris
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.neutral200, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.neutral400, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral900),
                    decoration: InputDecoration(
                      hintText: 'Search Product...',
                      hintStyle: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral400),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero, // Teks & Ikon simetris sempurna di tengah secara vertikal!
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarLeft() {
    return Container(
      width: 110,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(color: AppColors.neutral200, width: 1),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final bool isActive = _activeCategory == cat['name'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _activeCategory = cat['name'];
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              height: 80,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary500.withValues(alpha: 0.1) : AppColors.neutral100,
                borderRadius: BorderRadius.circular(12),
                border: isActive
                    ? Border.all(color: AppColors.primary500.withValues(alpha: 0.3), width: 1)
                    : null,
              ),
              child: Stack(
                children: [
                  if (isActive)
                    Positioned(
                      left: 0,
                      top: 16,
                      bottom: 16,
                      width: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary500,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          color: isActive ? AppColors.primary500 : AppColors.neutral500,
                          size: 24,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['name'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyXsRegular.copyWith(
                            color: isActive ? AppColors.primary500 : AppColors.neutral700,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductArea(List<Product> products) {
    if (products.isEmpty) {
      return Container(
        color: AppColors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.find_in_page_outlined,
                  size: 48,
                  color: AppColors.neutral400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No Product Found',
                style: AppTypography.bodyLBold.copyWith(color: AppColors.neutral900),
              ),
              const SizedBox(height: 8),
              Text(
                'Product from your store will show here.',
                style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Menggunakan 3 kolom agar visual produk lebih longgar
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          final quantityInCart = _getProductQuantityInCart(p);

          return GestureDetector(
            onTap: () => _addToCart(p),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: quantityInCart > 0 ? AppColors.primary500 : AppColors.neutral200,
                  width: quantityInCart > 0 ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Gambar produk placeholder (Wireframe)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              p.icon,
                              color: AppColors.neutral400,
                              size: 32,
                            ),
                          ),
                          // Badge kuantitas produk terpilih (seperti di screenshot)
                          if (quantityInCart > 0)
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary500,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'x $quantityInCart',
                                  style: AppTypography.bodyXsRegular.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySRegular.copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatRupiah(p.price),
                          style: AppTypography.bodyXsRegular.copyWith(
                            color: AppColors.primary500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSidebarRight() {
    return Container(
      width: 290, // Dikurangi dari 330 agar area produk lebih luas
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          left: BorderSide(color: AppColors.neutral200, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // A. Panel Atas (Grid Aksi 2x2)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5, // Disesuaikan aspek rasionya agar tidak overflow di lebar 290px
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildActionGridButton('Customer', Icons.people_outline),
                _buildActionGridButton('Tables', Icons.table_restaurant_outlined),
                _buildActionGridButton('Discount', Icons.local_offer_outlined),
                _buildActionGridButton('Save Bill', Icons.file_download_outlined),
              ],
            ),
          ),

          // B. Toggle Order Details (Dine In / Take Away) & Clear All
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Details',
                      style: AppTypography.bodyLBold.copyWith(color: AppColors.neutral800),
                    ),
                    if (_cart.isNotEmpty)
                      TextButton(
                        onPressed: _clearCart,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Clear All',
                          style: AppTypography.bodySRegular.copyWith(
                            color: AppColors.error500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTogglePill('Dine In', _isDineIn),
                      ),
                      Expanded(
                        child: _buildTogglePill('Take Away', !_isDineIn),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 24, thickness: 1),

          // C. Keranjang Items Area (Scrollable / List Divider Outline Bottom)
          Expanded(
            child: _cart.isEmpty ? _buildEmptyCartState() : _buildCartListWidget(),
          ),

          const Divider(height: 20, thickness: 1),

          // D. Ringkasan Pembayaran & Tombol Bayar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildReceiptRow('Subtotal', _formatRupiah(_subtotal)),
                const SizedBox(height: 8),
                _buildReceiptRow('Tax (10%)', _formatRupiah(_tax)),
                const SizedBox(height: 8),
                _buildReceiptRow('Voucher', _formatRupiah(0)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTypography.bodyLBold.copyWith(color: AppColors.neutral900),
                    ),
                    Text(
                      _formatRupiah(_total),
                      style: AppTypography.h4Bold.copyWith(color: AppColors.neutral900),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Process Transaction
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: AppButton(
              text: 'Process Transaction',
              variant: _cart.isEmpty ? AppButtonVariant.solid : AppButtonVariant.gradient,
              isEnabled: _cart.isNotEmpty,
              onPressed: _cart.isEmpty
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Konfirmasi Pembayaran'),
                          content: Text('Proses transaksi total ${_formatRupiah(_total)}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                setState(() {
                                  _cart.clear();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Transaksi Berhasil Diproses!'),
                                    backgroundColor: AppColors.primary500,
                                  ),
                                );
                              },
                              child: const Text('Proses'),
                            ),
                          ],
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGridButton(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.neutral200, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.neutral800, size: 18),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.bodyXsRegular.copyWith(
                  color: AppColors.neutral800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTogglePill(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDineIn = text == 'Dine In';
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
                    color: AppColors.neutral900.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          text,
          style: AppTypography.bodySRegular.copyWith(
            color: isActive ? AppColors.primary500 : AppColors.neutral500, // Warna hijau saat aktif, tanpa garis bawah
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCartState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 38,
                color: AppColors.neutral400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Order',
              style: AppTypography.bodyLBold.copyWith(color: AppColors.neutral900),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the product to add into order',
              textAlign: TextAlign.center,
              style: AppTypography.bodySRegular.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartListWidget() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _cart.length,
      itemBuilder: (context, index) {
        final item = _cart[index];
        final double itemTotal = item.product.price * item.quantity;
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.neutral200, width: 1.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.product.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySRegular.copyWith(
                              color: AppColors.neutral900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          _formatRupiah(itemTotal),
                          style: AppTypography.bodySRegular.copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'X${item.quantity}   ${_formatRupiah(item.product.price)}',
                          style: AppTypography.bodyXsRegular.copyWith(
                            color: AppColors.neutral500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _updateQuantity(item, -1),
                          child: const Icon(
                            Icons.remove_circle_outline,
                            size: 16,
                            color: AppColors.error500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value) {
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
            color: AppColors.neutral900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Custom Painter untuk visual wireframe diagonal X
class WireframeBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF282828)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
