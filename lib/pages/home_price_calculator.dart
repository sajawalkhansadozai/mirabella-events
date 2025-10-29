// lib/pages/home_price_calculator.dart
import 'package:flutter/material.dart';
import '../theme.dart';

// ===================== PRICE CALCULATOR =====================
class PriceCalculator extends StatefulWidget {
  const PriceCalculator({Key? key}) : super(key: key);

  @override
  State<PriceCalculator> createState() => _PriceCalculatorState();
}

class _PriceCalculatorState extends State<PriceCalculator>
    with TickerProviderStateMixin {
  final _guestsController = TextEditingController(text: '');
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // ---- Item prices for each menu (original food prices) ----
  static const Map<String, Map<String, double>> menuDataWithPrices = {
    'MENU 1': {
      'CHICKEN QORMA': 690.0,
      'CHANNAY': 200.0,
      'RUSSIAN SALAD + FRESH SALAD': 160.0,
      'KACHUMMAR SALAD + RED BEANS SALAD': 120.0,
      'NAAN + PURI': 200.0,
      'HALWA SUJI': 240.0,
      'GREEN TEA': 20.0,
      'DRINKS + MINERAL WATER': 160.0,
    },
    'MENU 2': {
      'CHICKEN QORMA': 740.0,
      'CHICKEN BIRYANI / PULAO': 475.0,
      'CHICKEN BOTTI': 240.0,
      'MIX VEGETABLE SALAD': 120.0,
      'RUSSIAN SALAD + FRESH SALAD': 240.0,
      'KACHUMMAR SALAD + RED BEANS SALAD': 130.0,
      'NAAN': 120.0,
      'RAITA': 80.0,
      'KHEER + TRIFLE': 355.0,
      'GREEN TEA': 70.0,
      'DRINKS + MINERAL WATER': 165.0,
    },
    'MENU 3': {
      'CHICKEN QORMA': 790.0,
      'CHICKEN BIRYANI / PULAO': 525.0,
      'CHICKEN BOTTI': 250.0,
      'SEEKH KABAB': 250.0,
      'RUSSIAN SALAD + FRESH SALAD': 250.0,
      'KACHUMMAR SALAD + RED BEANS SALAD': 140.0,
      'NAAN': 125.0,
      'RAITA': 85.0,
      'KHEER + TRIFLE': 405.0,
      'GREEN TEA': 115.0,
      'DRINKS + MINERAL WATER': 200.0,
    },
    'MENU 4': {
      'MUTTON QORMA': 955.0,
      'CHICKEN BIRYANI / PULAO': 575.0,
      'CHICKEN BOTTI': 320.0,
      'FISH + CHIPS': 320.0,
      'RUSSIAN SALAD + FRESH SALADS': 255.0,
      'KACHUMMAR SALAD + RED BEANS SALAD': 160.0,
      'NAAN': 160.0,
      'RAITA': 90.0,
      'KHEER + TRIFLE': 455.0,
      'GREEN TEA': 150.0,
      'DRINKS + MINERAL WATER': 225.0,
    },
  };

  // Package prices for complete menus
  static const Map<String, double> packagePrices = {
    'MENU 1': 1980.0,
    'MENU 2': 2380.0,
    'MENU 3': 2480.0,
    'MENU 4': 3180.0,
  };

  // Service charges per menu
  static const Map<String, double> serviceCharges = {
    'MENU 1': 190.0,
    'MENU 2': 245.0,
    'MENU 3': 230.0,
    'MENU 4': 335.0,
  };

  /// Selected: 'MENU X - ITEM' -> price per person
  Map<String, double> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  double get guests {
    final input = _guestsController.text.trim();
    if (input.isEmpty) return 0;
    return double.tryParse(input) ?? 0;
  }

  // Check if a complete menu is selected
  bool _isCompleteMenuSelected(String menuName) {
    final menuItems = menuDataWithPrices[menuName];
    if (menuItems == null) return false;

    return menuItems.keys.every(
      (itemName) => selectedItems.containsKey('$menuName - $itemName'),
    );
  }

  // Per-person cost with smart calculation
  double _perPersonCost() {
    double totalCost = 0;

    // Group selections by menu
    Map<String, List<String>> menuSelections = {};
    for (final key in selectedItems.keys) {
      final parts = key.split(' - ');
      if (parts.length == 2) {
        final menuName = parts[0];
        if (!menuSelections.containsKey(menuName)) {
          menuSelections[menuName] = [];
        }
        menuSelections[menuName]!.add(parts[1]);
      }
    }

    // Calculate cost for each menu
    for (final menuEntry in menuSelections.entries) {
      final menuName = menuEntry.key;

      if (_isCompleteMenuSelected(menuName)) {
        // Use package price if complete menu is selected
        totalCost += packagePrices[menuName] ?? 0;
      } else {
        // Calculate individual items + proportional service charges
        double itemsTotal = 0;
        for (final itemName in menuEntry.value) {
          itemsTotal += menuDataWithPrices[menuName]?[itemName] ?? 0;
        }

        // Add service charges proportionally
        final menuItemsCount = menuDataWithPrices[menuName]?.length ?? 1;
        final selectedCount = menuEntry.value.length;
        final serviceCharge =
            (serviceCharges[menuName] ?? 0) * (selectedCount / menuItemsCount);

        totalCost += itemsTotal + serviceCharge;
      }
    }

    return totalCost;
  }

  // Calculate base food cost (without service charges)
  double _baseFoodCost() {
    double baseCost = 0;

    // Group selections by menu
    Map<String, List<String>> menuSelections = {};
    for (final key in selectedItems.keys) {
      final parts = key.split(' - ');
      if (parts.length == 2) {
        final menuName = parts[0];
        if (!menuSelections.containsKey(menuName)) {
          menuSelections[menuName] = [];
        }
        menuSelections[menuName]!.add(parts[1]);
      }
    }

    // Calculate base food cost
    for (final menuEntry in menuSelections.entries) {
      final menuName = menuEntry.key;

      if (_isCompleteMenuSelected(menuName)) {
        // Use package price minus service charges
        baseCost +=
            (packagePrices[menuName] ?? 0) - (serviceCharges[menuName] ?? 0);
      } else {
        // Sum individual item prices
        for (final itemName in menuEntry.value) {
          baseCost += menuDataWithPrices[menuName]?[itemName] ?? 0;
        }
      }
    }

    return baseCost;
  }

  // Calculate service charges amount
  double _serviceChargesAmount() {
    return _perPersonCost() - _baseFoodCost();
  }

  // Get average service charge percentage for selected items
  double _averageServiceChargePercentage() {
    if (selectedItems.isEmpty) return 0;

    final baseCost = _baseFoodCost();
    final serviceChargeAmount = _serviceChargesAmount();

    if (baseCost == 0) return 0;
    return (serviceChargeAmount / baseCost) * 100;
  }

  double calculateTotal() => guests <= 0 ? 0 : _perPersonCost() * guests;

  void clearAllSelections() {
    setState(() {
      selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calculate,
                  color: AppColors.primaryGold,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Event Cost Calculator',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 600
                          ? 20
                          : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBurgundy,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select individual items from any menu. All prices include food, decoration, hall, catering management, stage setup, and service staff charges.',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                _buildMenuSection(),
                const SizedBox(height: 32),
                _buildCalculatorPanel(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) => Row(
              children: [
                const Icon(
                  Icons.restaurant_menu,
                  color: AppColors.primaryGold,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Select Menu Items - Mix & Match from Any Menu',
                    style: TextStyle(
                      fontSize: c.maxWidth < 400
                          ? 12
                          : (c.maxWidth < 600 ? 14 : 20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBurgundy,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (selectedItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGold.withOpacity(0.1),
                    AppColors.primaryGold.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGold.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.shopping_cart,
                        color: AppColors.primaryGold,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Selected items from multiple menus',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepBurgundy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          SizedBox(height: selectedItems.isNotEmpty ? 16 : 8),

          LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth > 800;
              if (isWide) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildMenuCard(
                        'MENU 1',
                        'RS. 1980',
                        menuDataWithPrices['MENU 1']!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMenuCard(
                        'MENU 2',
                        'RS. 2380',
                        menuDataWithPrices['MENU 2']!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMenuCard(
                        'MENU 3',
                        'RS. 2480',
                        menuDataWithPrices['MENU 3']!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMenuCard(
                        'MENU 4',
                        'RS. 3180',
                        menuDataWithPrices['MENU 4']!,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _buildMenuCard(
                    'MENU 1',
                    'RS. 1980',
                    menuDataWithPrices['MENU 1']!,
                  ),
                  const SizedBox(height: 8),
                  _buildMenuCard(
                    'MENU 2',
                    'RS. 2380',
                    menuDataWithPrices['MENU 2']!,
                  ),
                  const SizedBox(height: 8),
                  _buildMenuCard(
                    'MENU 3',
                    'RS. 2480',
                    menuDataWithPrices['MENU 3']!,
                  ),
                  const SizedBox(height: 8),
                  _buildMenuCard(
                    'MENU 4',
                    'RS. 3180',
                    menuDataWithPrices['MENU 4']!,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title, String price, Map<String, double> items) {
    final hasSelectedItems = items.keys.any(
      (i) => selectedItems.containsKey('$title - $i'),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E3A5F), Color(0xFF2C4A6B)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: hasSelectedItems
            ? Border.all(color: AppColors.primaryGold, width: 3)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width < 600 ? 16 : 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  // Check if all items are selected
                  final allSelected = items.keys.every(
                    (it) => selectedItems.containsKey('$title - $it'),
                  );

                  if (allSelected) {
                    // Deselect all items from this menu
                    for (final it in items.keys) {
                      selectedItems.remove('$title - $it');
                    }
                  } else {
                    // Select all items from this menu
                    for (final e in items.entries) {
                      selectedItems['$title - ${e.key}'] = e.value;
                    }
                  }
                });
              },
              child: Row(
                children: [
                  Icon(
                    items.keys.every(
                          (it) => selectedItems.containsKey('$title - $it'),
                        )
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: AppColors.primaryGold,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Select Complete Menu',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                if (hasSelectedItems)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${items.keys.where((i) => selectedItems.containsKey('$title - $i')).length}/${items.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$price (Package)',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(height: 16),

            // Items
            ...items.entries.map((entry) {
              final itemName = entry.key;
              final itemPrice = entry.value;
              final key = '$title - $itemName';
              final selected = selectedItems.containsKey(key);

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    setState(() {
                      if (selected) {
                        selectedItems.remove(key);
                      } else {
                        selectedItems[key] = itemPrice;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryGold.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: selected
                          ? Border.all(color: AppColors.primaryGold, width: 1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: AppColors.primaryGold,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            itemName,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.9),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          'RS.${itemPrice.toInt()}',
                          style: const TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorPanel() {
    final total = calculateTotal();
    final perPerson = _perPersonCost();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.deepBurgundy, Color(0xFF8B1538)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.receipt_long, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Bill Calculator',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Enter Guest Count:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _guestsController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Number of guests',
              hintStyle: const TextStyle(color: Color(0x99FFFFFF)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),

          _infoRow('Number of Guests:', guests > 0 ? '${guests.toInt()}' : '0'),
          const SizedBox(height: 16),
          _infoRow('Selected Items:', '${selectedItems.length} items'),
          const SizedBox(height: 24),

          if (selectedItems.isNotEmpty) ...[
            const Text(
              'Selected Items with Prices:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Food items
                    ...selectedItems.entries.map((entry) {
                      final price = entry.value;
                      final itemTotal = guests > 0 ? price * guests : 0.0;
                      return _selectedLine(
                        title: entry.key,
                        subtitle:
                            'RS. ${price.toInt()} × ${guests.toInt()} = RS. ${itemTotal.toInt()}',
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryGold,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGold.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Total Event Cost',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'RS. ${total.toInt()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (guests > 0 && selectedItems.isNotEmpty)
                  Text(
                    'Per Person: RS. ${perPerson.toInt()}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                if (guests > 0 && selectedItems.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '📊 Price Breakdown',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Food Items Cost:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              'RS. ${(_baseFoodCost() * guests).toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Service Charges (${_averageServiceChargePercentage().toStringAsFixed(2)}%):',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              'RS. ${(_serviceChargesAmount() * guests).toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '(Decoration, Hall, Catering Management, Stage, Staff)',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'RS. ${total.toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '💡 Note:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'All prices include decoration, hall, catering management, stage setup, and service staff charges distributed proportionally across menu items.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/contact'),
                  icon: const Icon(Icons.phone),
                  label: const Text('Contact'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: clearAllSelections,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white70),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedLine({required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.primaryGold,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
