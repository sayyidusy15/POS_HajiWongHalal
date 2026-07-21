import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../screens/pos_product_screen.dart';
import 'add_product_confirmation_modal.dart';

class AddProductModal extends StatefulWidget {
  final ProductModel? initialProduct;
  final List<String>? categories;

  const AddProductModal({
    super.key,
    this.initialProduct,
    this.categories,
  });

  static Future<ProductModel?> show(
    BuildContext context, {
    ProductModel? initialProduct,
    List<String>? categories,
  }) {
    return showDialog<ProductModel>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      barrierDismissible: false,
      builder: (ctx) => AddProductModal(
        initialProduct: initialProduct,
        categories: categories,
      ),
    );
  }

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  int _currentStep = 1; // 1: Info, 2: Pricing, 3: Variants & Add-Ons

  // Step 1: Product Info Fields
  bool _hasImage = false;
  bool _statusEnabled = true;
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _descController;
  
  String? _nameError;
  String? _skuError;

  // Category
  late List<String> _categories;
  String _selectedCategory = 'Burger';
  bool _isAddingNewCategory = false;
  final TextEditingController _newCategoryController = TextEditingController();

  // Step 2: Pricing Fields
  late TextEditingController _priceController;
  late TextEditingController _takeawayPriceController;
  String? _priceError;

  // Step 3: Variants & Add-Ons
  final List<Map<String, dynamic>> _sizeVariants = [
    {'enabled': true, 'ctrl': TextEditingController(text: 'Regular'), 'priceCtrl': TextEditingController(text: '0')},
    {'enabled': true, 'ctrl': TextEditingController(text: 'Medium'), 'priceCtrl': TextEditingController(text: '5000')},
    {'enabled': true, 'ctrl': TextEditingController(text: 'Large'), 'priceCtrl': TextEditingController(text: '10000')},
  ];

  final List<Map<String, dynamic>> _addonsList = [
    {'enabled': true, 'ctrl': TextEditingController(text: 'Extra Cheese'), 'priceCtrl': TextEditingController(text: '8000')},
    {'enabled': true, 'ctrl': TextEditingController(text: 'Extra Patty'), 'priceCtrl': TextEditingController(text: '15000')},
  ];

  @override
  void initState() {
    super.initState();
    _categories = widget.categories != null ? List.from(widget.categories!) : ['Burger', 'Fried Chicken', 'Drink', 'Snack'];

    final p = widget.initialProduct;
    if (p != null) {
      _hasImage = true;
      _nameController = TextEditingController(text: p.name);
      _skuController = TextEditingController(text: p.id);
      _descController = TextEditingController(text: p.description);
      if (!_categories.contains(p.category)) {
        _categories.add(p.category);
      }
      _selectedCategory = p.category;
      _priceController = TextEditingController(text: p.price.toInt().toString());
      _takeawayPriceController = TextEditingController(text: (p.price * 1.1).toInt().toString());
      _statusEnabled = p.status == 'Active';
    } else {
      // Clean / Empty Initial State for New Product
      _hasImage = false;
      _nameController = TextEditingController(text: '');
      _skuController = TextEditingController(text: '');
      _descController = TextEditingController(text: '');
      _priceController = TextEditingController(text: '');
      _takeawayPriceController = TextEditingController(text: '');
      _statusEnabled = true;
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _takeawayPriceController.dispose();
    _newCategoryController.dispose();
    for (var v in _sizeVariants) {
      (v['ctrl'] as TextEditingController).dispose();
      (v['priceCtrl'] as TextEditingController).dispose();
    }
    for (var a in _addonsList) {
      (a['ctrl'] as TextEditingController).dispose();
      (a['priceCtrl'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _handleNextOrSubmit() async {
    // Validate Step 1
    if (_currentStep == 1) {
      bool valid = true;
      setState(() {
        if (_nameController.text.trim().isEmpty) {
          _nameError = 'Product Name is required';
          valid = false;
        } else {
          _nameError = null;
        }

        if (_skuController.text.trim().isEmpty) {
          _skuError = 'SKU is required';
          valid = false;
        } else {
          _skuError = null;
        }
      });

      if (!valid) return;
      setState(() => _currentStep = 2);
      return;
    }

    // Validate Step 2
    if (_currentStep == 2) {
      if (_priceController.text.trim().isEmpty || double.tryParse(_priceController.text.trim()) == null) {
        setState(() {
          _priceError = 'Valid Price is required';
        });
        return;
      } else {
        setState(() {
          _priceError = null;
        });
      }
      setState(() => _currentStep = 3);
      return;
    }

    // Step 3 Submit
    if (_currentStep == 3) {
      final bool isEdit = widget.initialProduct != null;
      final bool? confirm = await AddProductConfirmationModal.show(
        context,
        title: isEdit ? 'Update Product Confirmation' : 'Add Product Confirmation',
        message: isEdit
            ? 'Are you sure you want to save changes to this product?'
            : 'Are you sure you want to add this new product to the menu?',
      );

      if (confirm == true && mounted) {
        final double priceVal = double.tryParse(_priceController.text.trim()) ?? 0;
        final String nameVal = _nameController.text.trim();
        final String idVal = _skuController.text.trim();

        IconData iconData = Icons.lunch_dining_outlined;
        if (_selectedCategory == 'Fried Chicken') iconData = Icons.kebab_dining_outlined;
        if (_selectedCategory == 'Drink') iconData = Icons.local_drink_outlined;
        if (_selectedCategory == 'Snack') iconData = Icons.cookie_outlined;

        Navigator.pop(
          context,
          ProductModel(
            id: idVal,
            name: nameVal,
            description: _descController.text.trim(),
            category: _selectedCategory,
            price: priceVal,
            stock: 50,
            status: _statusEnabled ? 'Active' : 'Inactive',
            icon: iconData,
            iconBgColor: const Color(0xFFFEF3C7),
          ),
        );
      }
    }
  }

  void _handleSaveAsDraft() async {
    final bool? confirm = await AddProductConfirmationModal.show(
      context,
      title: 'Save as Draft',
      message: 'Save this product configuration as a Draft item?',
    );

    if (confirm == true && mounted) {
      final double priceVal = double.tryParse(_priceController.text.trim()) ?? 0;
      final String nameVal = _nameController.text.trim().isEmpty ? 'Draft Product' : _nameController.text.trim();
      final String idVal = _skuController.text.trim().isEmpty ? '#SKU-DRAFT' : _skuController.text.trim();

      IconData iconData = Icons.lunch_dining_outlined;
      if (_selectedCategory == 'Fried Chicken') iconData = Icons.kebab_dining_outlined;
      if (_selectedCategory == 'Drink') iconData = Icons.local_drink_outlined;
      if (_selectedCategory == 'Snack') iconData = Icons.cookie_outlined;

      Navigator.pop(
        context,
        ProductModel(
          id: idVal,
          name: nameVal,
          description: _descController.text.trim(),
          category: _selectedCategory,
          price: priceVal,
          stock: 0,
          status: 'Draft',
          icon: iconData,
          iconBgColor: const Color(0xFFE0F2FE),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Container(
          width: 720,
          constraints: const BoxConstraints(maxHeight: 780),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // 1. HEADER TITLE SECTION (With Close Button)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: const Color(0xFFF9FAFB),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initialProduct != null ? 'Edit Product' : 'Add Product',
                      style: AppTypography.bodyLBold.copyWith(
                        color: AppColors.neutral900,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.neutral500),
                      onPressed: () => Navigator.pop(context, null),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.neutral200),

              // 2. FLOW INDICATOR SECTION (Circle on top, text below)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: AppColors.white,
                child: Center(
                  child: SizedBox(
                    width: 580,
                    child: _buildStepper(),
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.neutral200),

              // 3. STEPPER BODY CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildStepBody(),
                ),
              ),

              const Divider(height: 1, color: AppColors.neutral200),

              // 4. FOOTER MODAL (Action Buttons)
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // --- STEPPER NAVIGATION WIDGET (Circle on top, Title below) ---

  Widget _buildStepper() {
    final steps = [
      'Product Info',
      'Pricing',
      'Variants & Add-Ons',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final stepNum = index + 1;
        final bool isCompleted = stepNum < _currentStep;
        final bool isActive = stepNum == _currentStep;
        final bool isLast = index == steps.length - 1;

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circle Indicator + Connecting Line Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == 0 ? Colors.transparent : (isCompleted || isActive ? AppColors.primary500 : AppColors.neutral200),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.primary500
                          : (isActive ? AppColors.white : AppColors.white),
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.primary500
                            : (isActive ? AppColors.primary500 : AppColors.neutral300),
                        width: isActive ? 2.5 : 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: AppColors.white)
                        : (isActive
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary500,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : Text(
                                '$stepNum',
                                style: AppTypography.bodyXsRegular.copyWith(
                                  color: AppColors.neutral400,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isLast ? Colors.transparent : (isCompleted ? AppColors.primary500 : AppColors.neutral200),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title Text Below (100% readable & non-overlapping)
              Text(
                steps[index],
                textAlign: TextAlign.center,
                style: AppTypography.bodyXsRegular.copyWith(
                  color: isActive || isCompleted ? AppColors.neutral900 : AppColors.neutral400,
                  fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // --- STEP CONTENT SWITCHER ---

  Widget _buildStepBody() {
    switch (_currentStep) {
      case 1:
        return _buildStep1ProductInfo();
      case 2:
        return _buildStep2Pricing();
      case 3:
        return _buildStep3VariantsAndAddons();
      default:
        return _buildStep1ProductInfo();
    }
  }

  // --- STEP 1: PRODUCT INFO ---

  Widget _buildStep1ProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image Upload Area
        Text('Product Image', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _hasImage = !_hasImage;
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hasImage ? AppColors.neutral300 : AppColors.primary500,
                width: 1.2,
              ),
            ),
            child: _hasImage
                ? Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.lunch_dining_outlined, color: AppColors.neutral800, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameController.text.isNotEmpty ? '${_nameController.text.toLowerCase().replaceAll(' ', '_')}.png' : 'product_image.png',
                              style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text('873.1 kb', style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral400)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error500),
                        onPressed: () {
                          setState(() {
                            _hasImage = false;
                          });
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined, color: AppColors.primary500, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Click to upload JPG, PNG (Max 2 MB)',
                        style: AppTypography.bodySRegular.copyWith(color: AppColors.primary500, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),

        // Status Toggle Switch
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Enable and show this product in menu', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.w600, color: AppColors.neutral800)),
            Switch(
              value: _statusEnabled,
              activeTrackColor: AppColors.primary500,
              onChanged: (val) => setState(() => _statusEnabled = val),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Product Name *
        Row(
          children: [
            Text('Product Name ', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800)),
            Text('*', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.error500)),
          ],
        ),
        const SizedBox(height: 6),
        _buildTextField(_nameController, hint: 'e.g. Double Cheeseburger', errorText: _nameError),
        const SizedBox(height: 16),

        // SKU (Stock Keeping Unit) *
        Row(
          children: [
            Text('SKU (Stock Keeping Unit) ', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800)),
            Text('*', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.error500)),
          ],
        ),
        const SizedBox(height: 6),
        _buildTextField(_skuController, hint: 'e.g. 003021M', errorText: _skuError),
        const SizedBox(height: 16),

        // Description
        Text('Description', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800)),
        const SizedBox(height: 6),
        _buildTextField(_descController, hint: 'Write product description...', maxLines: 3),
        const SizedBox(height: 16),

        // Category Selection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Category', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800)),
            if (!_isAddingNewCategory)
              TextButton.icon(
                onPressed: () => setState(() => _isAddingNewCategory = true),
                icon: const Icon(Icons.add, size: 16, color: AppColors.primary500),
                label: const Text('Add New Category', style: TextStyle(color: AppColors.primary500, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 6),

        if (_isAddingNewCategory) ...[
          Row(
            children: [
              Expanded(
                child: _buildTextField(_newCategoryController, hint: 'Enter new category name'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final newCat = _newCategoryController.text.trim();
                  if (newCat.isNotEmpty) {
                    setState(() {
                      if (!_categories.contains(newCat)) {
                        _categories.add(newCat);
                      }
                      if (widget.categories != null && !widget.categories!.contains(newCat)) {
                        widget.categories!.add(newCat);
                      }
                      _selectedCategory = newCat;
                      _newCategoryController.clear();
                      _isAddingNewCategory = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary500, elevation: 0),
                child: const Text('Save', style: TextStyle(color: AppColors.white)),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.neutral500),
                onPressed: () => setState(() => _isAddingNewCategory = false),
              ),
            ],
          ),
        ] else ...[
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutral300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                dropdownColor: AppColors.white,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(color: AppColors.neutral800))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  // --- STEP 2: PRICING ---

  Widget _buildStep2Pricing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price *
        Row(
          children: [
            Text('Price ', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800)),
            Text('*', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.error500)),
          ],
        ),
        const SizedBox(height: 6),
        _buildTextFieldWithPrefix(_priceController, prefix: 'Rp', hint: 'e.g. 45000', errorText: _priceError),
        const SizedBox(height: 20),

        // Takeaway Price
        Text('Takeaway Price', style: AppTypography.bodySRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral800)),
        const SizedBox(height: 6),
        _buildTextFieldWithPrefix(_takeawayPriceController, prefix: 'Rp', hint: 'e.g. 50000'),
      ],
    );
  }

  // --- STEP 3: VARIANTS & ADD-ONS (Consistent Form Layout) ---

  Widget _buildStep3VariantsAndAddons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. SIZE VARIANTS ---
        Text('Size Variants', style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.neutral900)),
        const SizedBox(height: 4),
        Text('Define size choices and their additional price adjustment', style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            children: [
              // Column Headers
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 40.0, right: 36.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text('SIZE NAME', style: AppTypography.bodyXsRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral500)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Text('ADDITIONAL PRICE (Rp)', style: AppTypography.bodyXsRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral500)),
                    ),
                  ],
                ),
              ),

              // Size Rows
              ..._sizeVariants.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Switch(
                        value: item['enabled'],
                        activeTrackColor: AppColors.primary500,
                        onChanged: (v) => setState(() => item['enabled'] = v),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 4,
                        child: _buildFormInputCell(
                          controller: item['ctrl'],
                          hintText: 'e.g. Medium',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: _buildFormPriceInputCell(
                          controller: item['priceCtrl'],
                          hintText: '0',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error500, size: 20),
                        onPressed: () => setState(() => _sizeVariants.removeAt(idx)),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _sizeVariants.add({
                        'enabled': true,
                        'ctrl': TextEditingController(text: 'Extra Large'),
                        'priceCtrl': TextEditingController(text: '15000'),
                      });
                    });
                  },
                  icon: const Icon(Icons.add, size: 16, color: AppColors.primary500),
                  label: const Text('Add Size Variant', style: TextStyle(color: AppColors.primary500, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary500)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // --- 2. ADD-ONS ---
        Text('Add-Ons', style: AppTypography.bodyLBold.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.neutral900)),
        const SizedBox(height: 4),
        Text('Define extra customizable options cashier/customer can add', style: AppTypography.bodyXsRegular.copyWith(color: AppColors.neutral500)),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            children: [
              // Column Headers
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 40.0, right: 36.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text('ADD-ON NAME', style: AppTypography.bodyXsRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral500)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Text('PRICE (Rp)', style: AppTypography.bodyXsRegular.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral500)),
                    ),
                  ],
                ),
              ),

              // Add-On Rows
              ..._addonsList.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Switch(
                        value: item['enabled'],
                        activeTrackColor: AppColors.primary500,
                        onChanged: (v) => setState(() => item['enabled'] = v),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 4,
                        child: _buildFormInputCell(
                          controller: item['ctrl'],
                          hintText: 'e.g. Extra Sauce',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: _buildFormPriceInputCell(
                          controller: item['priceCtrl'],
                          hintText: '0',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error500, size: 20),
                        onPressed: () => setState(() => _addonsList.removeAt(idx)),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _addonsList.add({
                        'enabled': true,
                        'ctrl': TextEditingController(text: 'Extra Sauce'),
                        'priceCtrl': TextEditingController(text: '3000'),
                      });
                    });
                  },
                  icon: const Icon(Icons.add, size: 16, color: AppColors.primary500),
                  label: const Text('Add Add-On Option', style: TextStyle(color: AppColors.primary500, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary500)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- FOOTER BUTTONS ---

  Widget _buildFooter() {
    final bool isEdit = widget.initialProduct != null;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Row(
        children: [
          // Cancel
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(
              'Cancel',
              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral600),
            ),
          ),
          const Spacer(),

          // Save as Draft
          OutlinedButton(
            onPressed: _handleSaveAsDraft,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.neutral300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Save as Draft',
              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),

          // Back Button
          if (_currentStep > 1)
            OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.neutral300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Back',
                style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral800, fontWeight: FontWeight.w600),
              ),
            ),
          if (_currentStep > 1) const SizedBox(width: 10),

          // Next / Add Button
          ElevatedButton(
            onPressed: _handleNextOrSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              _currentStep == 3 ? (isEdit ? 'Save Changes' : 'Add') : 'Next',
              style: AppTypography.bodySRegular.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER FIELD BUILDERS ---

  Widget _buildFormInputCell({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.neutral300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.bodySRegular.copyWith(color: AppColors.neutral400),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildFormPriceInputCell({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.neutral300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text('Rp', style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.bodySRegular.copyWith(color: AppColors.neutral400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl, {
    required String hint,
    int maxLines = 1,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySRegular.copyWith(color: AppColors.neutral400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.neutral300)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? AppColors.error500 : AppColors.neutral300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? AppColors.error500 : AppColors.primary500, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(errorText, style: AppTypography.bodyXsRegular.copyWith(color: AppColors.error500)),
        ],
      ],
    );
  }

  Widget _buildTextFieldWithPrefix(
    TextEditingController ctrl, {
    required String prefix,
    required String hint,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: errorText != null ? AppColors.error500 : AppColors.neutral300),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(prefix, style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral500, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.number,
                  style: AppTypography.bodySRegular.copyWith(color: AppColors.neutral900),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTypography.bodySRegular.copyWith(color: AppColors.neutral400),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(errorText, style: AppTypography.bodyXsRegular.copyWith(color: AppColors.error500)),
        ],
      ],
    );
  }
}
