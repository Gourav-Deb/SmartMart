import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_theme.dart';
import '../../models/quick_commerce_models.dart';

class CustomerDashboardView extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const CustomerDashboardView({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  State<CustomerDashboardView> createState() => _CustomerDashboardViewState();
}

class _CustomerDashboardViewState extends State<CustomerDashboardView> {
  String selectedCategory = "All";
  final Map<String, int> cartItems = {};
  String searchQuery = "";

  final List<Map<String, dynamic>> allProductsList = [
    // Dairy & Eggs
    {'name': 'Amul Taaza Milk 1L', 'category': 'Dairy & Eggs', 'price': 72, 'originalPrice': 78, 'unit': '1 L', 'image': '🥛'},
    {'name': 'Amul Butter 100g', 'category': 'Dairy & Eggs', 'price': 58, 'originalPrice': 62, 'unit': '100 g', 'image': '🧈'},
    {'name': 'Mother Dairy Paneer 200g', 'category': 'Dairy & Eggs', 'price': 90, 'originalPrice': 100, 'unit': '200 g', 'image': '🧀'},
    {'name': 'Fresh Farm Eggs 6pcs', 'category': 'Dairy & Eggs', 'price': 48, 'originalPrice': 55, 'unit': '6 pcs', 'image': '🥚'},
    // Fruits
    {'name': 'Robusta Bananas 6pcs', 'category': 'Fresh Fruits', 'price': 39, 'originalPrice': 50, 'unit': '6 pcs', 'image': '🍌'},
    {'name': 'Shimla Red Apples 4pcs', 'category': 'Fresh Fruits', 'price': 149, 'originalPrice': 179, 'unit': '4 pcs', 'image': '🍎'},
    {'name': 'Sweet Orange 1kg', 'category': 'Fresh Fruits', 'price': 120, 'originalPrice': 140, 'unit': '1 kg', 'image': '🍊'},
    {'name': 'Fresh Blueberries 125g', 'category': 'Fresh Fruits', 'price': 220, 'originalPrice': 280, 'unit': '125 g', 'image': '🫐'},
    // Veggies
    {'name': 'Fresh Potatoes 1kg', 'category': 'Veggies', 'price': 32, 'originalPrice': 40, 'unit': '1 kg', 'image': '🥔'},
    {'name': 'Organic Tomatoes 500g', 'category': 'Veggies', 'price': 28, 'originalPrice': 35, 'unit': '500 g', 'image': '🍅'},
    {'name': 'Fresh Onions 1kg', 'category': 'Veggies', 'price': 45, 'originalPrice': 55, 'unit': '1 kg', 'image': '🧅'},
    {'name': 'Green Broccoli 1pc', 'category': 'Veggies', 'price': 59, 'originalPrice': 70, 'unit': '1 pc', 'image': '🥦'},
    // Snacks
    {'name': 'Lays Potato Chips Classic', 'category': 'Snacks', 'price': 20, 'originalPrice': 20, 'unit': '50 g', 'image': '🍿'},
    {'name': 'Cadbury Dairy Milk Silk', 'category': 'Snacks', 'price': 80, 'originalPrice': 80, 'unit': '60 g', 'image': '🍫'},
    {'name': 'Oreo Chocolate Biscuits', 'category': 'Snacks', 'price': 30, 'originalPrice': 35, 'unit': '120 g', 'image': '🍪'},
    // Beverages
    {'name': 'Coca-Cola Can 300ml', 'category': 'Beverages', 'price': 40, 'originalPrice': 40, 'unit': '300 ml', 'image': '🥤'},
    {'name': 'Sprite Can 300ml', 'category': 'Beverages', 'price': 40, 'originalPrice': 40, 'unit': '300 ml', 'image': '🥤'},
    {'name': 'Nescafe Gold Coffee 50g', 'category': 'Beverages', 'price': 280, 'originalPrice': 310, 'unit': '50 g', 'image': '☕'},
    {'name': 'Tropicana Orange Juice 1L', 'category': 'Beverages', 'price': 110, 'originalPrice': 120, 'unit': '1 L', 'image': '🧃'},
    // Bakery
    {'name': 'Britannia Wheat Bread', 'category': 'Bakery', 'price': 45, 'originalPrice': 48, 'unit': '400 g', 'image': '🍞'},
    {'name': 'Chocolate Croissant 2pcs', 'category': 'Bakery', 'price': 120, 'originalPrice': 150, 'unit': '2 pcs', 'image': '🥐'},
    // Instant Food
    {'name': 'Maggi Masala Noodles 4pack', 'category': 'Instant Food', 'price': 56, 'originalPrice': 60, 'unit': '280 g', 'image': '🍜'},
    {'name': 'Pringles Sour Cream & Onion', 'category': 'Instant Food', 'price': 99, 'originalPrice': 109, 'unit': '100 g', 'image': '🥔'},
    // Ice Creams
    {'name': 'Kwality Walls Choco Feast', 'category': 'Ice Creams', 'price': 40, 'originalPrice': 45, 'unit': '1 pc', 'image': '🍦'},
    {'name': 'Amul Vanilla Gold Tub 1L', 'category': 'Ice Creams', 'price': 220, 'originalPrice': 240, 'unit': '1 L', 'image': '🍨'},
  ];

  double get totalCartPrice {
    double total = 0;
    cartItems.forEach((name, qty) {
      final product = allProductsList.firstWhere((p) => p['name'] == name, orElse: () => {'price': 0});
      final double price = (product['price'] as num).toDouble();
      total += price * qty;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Address Header
            _buildTopHeader(isDark),

            // Main Content Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flash Delivery Promo Banner
                    _buildPromoBanner(isDark),

                    const SizedBox(height: 24),

                    // Search Bar
                    _buildSearchBar(isDark),

                    const SizedBox(height: 24),

                    // Quick Categories Selector
                    _buildCategoriesGrid(isDark),

                    const SizedBox(height: 28),

                    // Product Grid Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "10-Minute Express Catalog",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          "245 SKUs Available",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Products Grid
                    _buildProductGrid(isDark),

                    const SizedBox(height: 28),

                    // Active Order Tracking Banner
                    _buildLiveOrderTrackingCard(isDark),
                  ],
                ),
              ),
            ),

            // Bottom Cart Checkout Bar
            if (cartItems.isNotEmpty) _buildCartCheckoutBar(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.shoppingBag, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Delivering to ",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        "Home (Salt Lake AE Block)",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const Icon(LucideIcons.chevronDown, size: 14, color: AppTheme.primary),
                    ],
                  ),
                  Text(
                    "⚡ 8 mins ETA • Dark Store #104",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  isDark ? LucideIcons.sun : LucideIcons.moon,
                  color: isDark ? AppTheme.accent : const Color(0xFF0F172A),
                ),
                tooltip: "Toggle Theme",
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: widget.onLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  side: BorderSide(
                    color: isDark ? AppTheme.borderDark : const Color(0xFFCBD5E1),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(LucideIcons.arrowLeft, size: 16),
                label: const Text("Portals"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF059669), Color(0xFF10B981), Color(0xFF047857)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "INSTANT 10-MIN SLA",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Fresh Groceries Delivered in 8-10 Mins",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Up to 50% OFF on Dairy, Eggs & Daily Breakfast Essentials",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.zap, color: Colors.yellowAccent, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: TextField(
        onChanged: (val) => setState(() => searchQuery = val),
        style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(
            LucideIcons.search,
            size: 20,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
          hintText: "Search milk, bread, bananas, chips, beverages...",
          hintStyle: GoogleFonts.inter(
            fontSize: 13.5,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(bool isDark) {
    final categoriesList = [
      {'name': 'Dairy & Eggs', 'icon': '🥛', 'color': const Color(0xFFE0F2FE)},
      {'name': 'Fresh Fruits', 'icon': '🍎', 'color': const Color(0xFFFEE2E2)},
      {'name': 'Veggies', 'icon': '🥦', 'color': const Color(0xFFDCFCE7)},
      {'name': 'Snacks', 'icon': '🍿', 'color': const Color(0xFFFEF3C7)},
      {'name': 'Beverages', 'icon': '🥤', 'color': const Color(0xFFF3E8FF)},
      {'name': 'Bakery', 'icon': '🍞', 'color': const Color(0xFFE2E8F0)},
      {'name': 'Instant Food', 'icon': '🍜', 'color': const Color(0xFFFCE7F3)},
      {'name': 'Ice Cream', 'icon': '🍨', 'color': const Color(0xFFFFE4E6)},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth > 800 ? 8 : 4;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemCount: categoriesList.length,
          itemBuilder: (context, index) {
            final cat = categoriesList[index];
            final String name = cat['name'] as String;
            final String icon = cat['icon'] as String;
            final Color color = cat['color'] as Color;
            final bool isSelected = selectedCategory == name;

            return InkWell(
              onTap: () => setState(() => selectedCategory = isSelected ? "All" : name),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary
                      : (isDark ? AppTheme.cardDarkElevated : color.withOpacity(0.35)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary
                        : (isDark ? AppTheme.borderDarkActive : color.withOpacity(0.55)),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductGrid(bool isDark) {
    final filteredProducts = allProductsList.where((p) {
      final matchesCategory = selectedCategory == "All" || p['category'] == selectedCategory;
      final matchesSearch = searchQuery.isEmpty || p['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              const Icon(LucideIcons.searchCode, size: 48, color: AppTheme.danger),
              const SizedBox(height: 12),
              Text(
                "No products found",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              ),
              Text(
                "Try checking your search query or category filters",
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 3 : 2);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final item = filteredProducts[index];
            final String name = item['name'] as String;
            final double price = (item['price'] as num).toDouble();
            final double originalPrice = (item['originalPrice'] as num).toDouble();
            final String unit = item['unit'] as String;
            final String image = item['image'] as String;
            final int qty = cartItems[name] ?? 0;

            Color tintColor = const Color(0xFF10B981);
            if (item['category'] == 'Dairy & Eggs') tintColor = const Color(0xFF0284C7);
            if (item['category'] == 'Fresh Fruits') tintColor = const Color(0xFFEF4444);
            if (item['category'] == 'Snacks') tintColor = const Color(0xFFF97316);

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: tintColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(image, style: const TextStyle(fontSize: 42)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    unit,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹${price.toStringAsFixed(0)}",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                          if (originalPrice > price)
                            Text(
                              "₹${originalPrice.toStringAsFixed(0)}",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                            ),
                        ],
                      ),
                      qty == 0
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() => cartItems[name] = 1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("ADD"),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(LucideIcons.minus, size: 14, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        if (qty > 1) {
                                          cartItems[name] = qty - 1;
                                        } else {
                                          cartItems.remove(name);
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    "$qty",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(LucideIcons.plus, size: 14, color: Colors.white),
                                    onPressed: () {
                                      setState(() => cartItems[name] = qty + 1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLiveOrderTrackingCard(bool isDark) {
    final order = QuickCommerceData.recentOrders.first;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.bike, color: AppTheme.primary, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    "Live Delivery Stream: ${order.id}",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rider: ${order.riderName} (${order.riderPhone})",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                ),
              ),
              Text(
                "Delivery OTP: ${order.deliveryOtp}",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartCheckoutBar(bool isDark) {
    final count = cartItems.values.fold(0, (sum, q) => sum + q);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$count items selected",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                "₹${totalCartPrice.toStringAsFixed(0)}",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Order Dispatched! Rider is assigned in 10-Min SLA."),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Text(
                  "Checkout Order",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.arrowRight, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
