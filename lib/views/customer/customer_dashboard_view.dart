import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_theme.dart';
import '../../models/quick_commerce_models.dart';
import 'category_products_view.dart';

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

  // Interactive UI states
  String selectedAddress = "Home (Salt Lake AE Block)";
  String? appliedCoupon;
  late final TextEditingController _searchController;
  String selectedInstruction = "Leave at gate";
  int liveDeliveryStage = 2; // 0: Placed, 1: Packed, 2: Out for Delivery, 3: Delivered

  final List<Map<String, String>> quickSearchTags = [
    {'emoji': '🥛', 'label': 'Milk', 'query': 'Milk'},
    {'emoji': '🍌', 'label': 'Bananas', 'query': 'banana'},
    {'emoji': '🍿', 'label': 'Chips', 'query': 'Lays'},
    {'emoji': '🍫', 'label': 'Chocolate', 'query': 'Silk'},
    {'emoji': '🥤', 'label': 'Beverages', 'query': 'Coca-Cola'},
    {'emoji': '🍞', 'label': 'Bread', 'query': 'Bread'},
  ];

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
    // Supplements
    {'name': 'Optimum Nutrition Whey 1kg', 'category': 'Supplements', 'price': 3499, 'originalPrice': 3899, 'unit': '1 kg', 'image': '💪'},
    {'name': 'MuscleBlaze Creatine 250g', 'category': 'Supplements', 'price': 649, 'originalPrice': 799, 'unit': '250 g', 'image': '⚡'},
    {'name': 'Yogabar Protein Bar 6pcs', 'category': 'Supplements', 'price': 320, 'originalPrice': 400, 'unit': '6 pcs', 'image': '🍫'},
    {'name': 'HealthKart Multivitamins', 'category': 'Supplements', 'price': 450, 'originalPrice': 550, 'unit': '60 tabs', 'image': '💊'},
    // Decorations
    {'name': 'Metallic Birthday Balloons', 'category': 'Decorations', 'price': 120, 'originalPrice': 199, 'unit': '50 pcs', 'image': '🎈'},
    {'name': 'Golden Happy Birthday Banner', 'category': 'Decorations', 'price': 99, 'originalPrice': 149, 'unit': '1 pc', 'image': '🎉'},
    {'name': 'LED Fairy String Lights', 'category': 'Decorations', 'price': 180, 'originalPrice': 299, 'unit': '10 m', 'image': '💡'},
    {'name': 'Lavender Scented Candle', 'category': 'Decorations', 'price': 240, 'originalPrice': 349, 'unit': '1 pc', 'image': '🕯️'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: searchQuery);
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get selectedAddressEta {
    if (selectedAddress.contains("Office")) {
      return "⚡ 12 mins ETA • Dark Store #109";
    } else if (selectedAddress.contains("Gym")) {
      return "⚡ 15 mins ETA • Dark Store #112";
    }
    return "⚡ 8 mins ETA • Dark Store #104";
  }

  double get totalCartPrice {
    double total = 0;
    cartItems.forEach((name, qty) {
      final product = allProductsList.firstWhere((p) => p['name'] == name, orElse: () => {'price': 0});
      final double price = (product['price'] as num).toDouble();
      total += price * qty;
    });
    return total;
  }

  double get couponDiscount {
    if (appliedCoupon == null) return 0.0;
    if (appliedCoupon == "FLASH100") {
      return totalCartPrice >= 500 ? 100.0 : 0.0;
    }
    if (appliedCoupon == "SUPERMILK") {
      bool hasDairy = false;
      cartItems.forEach((name, qty) {
        final p = allProductsList.firstWhere((prod) => prod['name'] == name, orElse: () => {});
        if (p.isNotEmpty && p['category'] == 'Dairy & Eggs') {
          hasDairy = true;
        }
      });
      return hasDairy ? 35.0 : 0.0; // Waives delivery fee
    }
    if (appliedCoupon == "FRESH20") {
      double freshTotal = 0.0;
      cartItems.forEach((name, qty) {
        final p = allProductsList.firstWhere((prod) => prod['name'] == name, orElse: () => {});
        if (p.isNotEmpty && (p['category'] == 'Veggies' || p['category'] == 'Fresh Fruits')) {
          freshTotal += (p['price'] as num).toDouble() * qty;
        }
      });
      return freshTotal * 0.20;
    }
    return 0.0;
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

                    const SizedBox(height: 12),

                    // Fast Search Tag Chips
                    _buildSearchSuggestionChips(isDark),

                    const SizedBox(height: 24),

                    // Quick Categories Selector
                    _buildCategoriesGrid(isDark),

                    const SizedBox(height: 24),

                    // Active Coupons Carousel
                    _buildCouponsCarousel(isDark),

                    const SizedBox(height: 24),

                    // Trending Section
                    _buildTrendingProductsRow(isDark),

                    const SizedBox(height: 28),

                    // Product Grid Section
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isSmallScreen = constraints.maxWidth < 450;
                        if (isSmallScreen) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "10-Minute Express Catalog",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "245 SKUs Available",
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          );
                        }
                        return Row(
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
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Products Grid
                    _buildProductGrid(isDark),

                    const SizedBox(height: 28),

                    // Active Order Tracking Banner (Stepper Tracker)
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 480;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 24,
            vertical: 16,
          ),
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
                  if (constraints.maxWidth >= 400) ...[
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
                  ],
                  InkWell(
                    onTap: () => _showAddressSelector(isDark),
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Delivering to ",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              selectedAddress.length > 20 && isSmallScreen
                                  ? "${selectedAddress.substring(0, 15)}..."
                                  : selectedAddress,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Icon(LucideIcons.chevronDown, size: 14, color: AppTheme.primary),
                          ],
                        ),
                        Text(
                          selectedAddressEta,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
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
                  const SizedBox(width: 4),
                  isSmallScreen
                      ? IconButton(
                          onPressed: widget.onLogout,
                          icon: const Icon(LucideIcons.arrowLeft),
                          tooltip: "Portals",
                        )
                      : OutlinedButton.icon(
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
      },
    );
  }

  void _showAddressSelector(bool isDark) {
    final addresses = [
      {
        'title': 'Home',
        'details': 'Home (Salt Lake AE Block)',
        'eta': '⚡ 8 mins ETA • Dark Store #104',
        'icon': LucideIcons.home,
      },
      {
        'title': 'Office',
        'details': 'Office (Sector V, DLF 2)',
        'eta': '⚡ 12 mins ETA • Dark Store #109',
        'icon': LucideIcons.building,
      },
      {
        'title': 'Gym',
        'details': 'Gym (Salt Lake Block CJ)',
        'eta': '⚡ 15 mins ETA • Dark Store #112',
        'icon': LucideIcons.dumbbell,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Delivery Address",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...addresses.map((addr) {
                final isSelected = selectedAddress == addr['details'];
                return Card(
                  color: isSelected
                      ? AppTheme.primary.withOpacity(0.1)
                      : (isDark ? AppTheme.cardDarkElevated : const Color(0xFFF1F5F9)),
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      addr['icon'] as IconData,
                      color: isSelected ? AppTheme.primary : (isDark ? Colors.white60 : Colors.black54),
                    ),
                    title: Text(
                      addr['title'] as String,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addr['details'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        Text(
                          addr['eta'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    trailing: isSelected
                        ? const Icon(LucideIcons.checkCircle2, color: AppTheme.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedAddress = addr['details'] as String;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Address updated to ${addr['title']}"),
                          backgroundColor: AppTheme.primary,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchSuggestionChips(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: quickSearchTags.map((tag) {
          final isMatching = searchQuery.toLowerCase() == tag['query']!.toLowerCase();
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isMatching) {
                  _searchController.clear();
                  searchQuery = "";
                } else {
                  _searchController.text = tag['query']!;
                  searchQuery = tag['query']!;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isMatching
                    ? AppTheme.primary
                    : (isDark ? AppTheme.cardDarkElevated : const Color(0xFFEDF2F7)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isMatching
                      ? AppTheme.primary
                      : (isDark ? AppTheme.borderDark : const Color(0xFFCBD5E1)),
                ),
              ),
              child: Row(
                children: [
                  Text(tag['emoji']!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    tag['label']!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isMatching ? FontWeight.bold : FontWeight.w500,
                      color: isMatching
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF2D3748)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCouponsCarousel(bool isDark) {
    final coupons = QuickCommerceData.activeCoupons;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Active Coupons & Offers",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (appliedCoupon != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    appliedCoupon = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Coupon removed successfully")),
                  );
                },
                child: Text(
                  "Clear Applied",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              final cp = coupons[index];
              final isApplied = appliedCoupon == cp.code;
              final Color badgeColor = Color(cp.colorValue);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isApplied) {
                      appliedCoupon = null;
                    } else {
                      appliedCoupon = cp.code;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isApplied
                            ? "Coupon removed"
                            : "Coupon '${cp.code}' applied! Checkout to view discount.",
                      ),
                      backgroundColor: AppTheme.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isApplied ? AppTheme.primary : (isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0)),
                      width: isApplied ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: badgeColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          cp.code,
                          style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: badgeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cp.description,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              cp.usage,
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isApplied)
                        const Icon(LucideIcons.checkCircle2, color: AppTheme.primary, size: 20),
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

  Widget _buildTrendingProductsRow(bool isDark) {
    final trendingNames = [
      'Fresh Blueberries 125g',
      'Cadbury Dairy Milk Silk',
      'Mother Dairy Paneer 200g',
      'Kwality Walls Choco Feast',
    ];

    final trendingProducts = allProductsList.where((p) => trendingNames.contains(p['name'])).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.flame, color: AppTheme.danger, size: 20),
            const SizedBox(width: 6),
            Text(
              "Trending Near You",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 165,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trendingProducts.length,
            itemBuilder: (context, index) {
              final item = trendingProducts[index];
              final String name = item['name'] as String;
              final double price = (item['price'] as num).toDouble();
              final String unit = item['unit'] as String;
              final String image = item['image'] as String;
              final int qty = cartItems[name] ?? 0;

              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(image, style: const TextStyle(fontSize: 34)),
                      ),
                    ),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      unit,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${price.toStringAsFixed(0)}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        qty == 0
                            ? SizedBox(
                                height: 26,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() => cartItems[name] = 1);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text("ADD", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              )
                            : Container(
                                height: 26,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (qty > 1) {
                                            cartItems[name] = qty - 1;
                                          } else {
                                            cartItems.remove(name);
                                          }
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                                        child: Icon(LucideIcons.minus, size: 10, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "$qty",
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() => cartItems[name] = qty + 1);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                                        child: Icon(LucideIcons.plus, size: 10, color: Colors.white),
                                      ),
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
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 450;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
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
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Fresh Groceries Delivered in 8-10 Mins",
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Up to 50% OFF on Dairy, Eggs & Daily Breakfast Essentials",
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? 11 : 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSmallScreen) ...[
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
            ],
          ),
        );
      },
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
        controller: _searchController,
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
      {'name': 'Supplements', 'icon': '💪', 'color': const Color(0xFFF5F3FF)},
      {'name': 'Decorations', 'icon': '🎈', 'color': const Color(0xFFFFF1F2)},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                final cat = categoriesList[index];
                final String name = cat['name'] as String;
                final String icon = cat['icon'] as String;
                final Color color = cat['color'] as Color;
                final bool isSelected = selectedCategory == name;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsView(
                          categoryName: name,
                          products: allProductsList,
                          cartItems: cartItems,
                          isDark: isDark,
                          onUpdateCart: (productName, qty) {
                            setState(() {
                              if (qty > 0) {
                                cartItems[productName] = qty;
                              } else {
                                cartItems.remove(productName);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 76,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary
                                : (isDark ? AppTheme.cardDarkElevated : color.withOpacity(0.35)),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : (isDark ? AppTheme.borderDarkActive : color.withOpacity(0.55)),
                              width: 1.5,
                            ),
                          ),
                          child: Text(icon, style: const TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppTheme.primary
                                : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        final int crossAxisCount = constraints.maxWidth > 800 ? 10 : 5;
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryProductsView(
                      categoryName: name,
                      products: allProductsList,
                      cartItems: cartItems,
                      isDark: isDark,
                      onUpdateCart: (productName, qty) {
                        setState(() {
                          if (qty > 0) {
                            cartItems[productName] = qty;
                          } else {
                            cartItems.remove(productName);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
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
        final double childAspectRatio = constraints.maxWidth < 360 ? 0.64 : (constraints.maxWidth < 480 ? 0.68 : 0.75);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
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
            if (item['category'] == 'Supplements') tintColor = const Color(0xFF8B5CF6);
            if (item['category'] == 'Decorations') tintColor = const Color(0xFFEC4899);

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

    final stages = [
      {'title': 'Placed', 'icon': LucideIcons.fileCheck},
      {'title': 'Packed', 'icon': LucideIcons.package},
      {'title': 'On Way', 'icon': LucideIcons.bike},
      {'title': 'Delivered', 'icon': LucideIcons.checkSquare},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 400;

        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
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
                      const Icon(LucideIcons.navigation, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Track Order ${order.id}",
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 13 : 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        liveDeliveryStage = (liveDeliveryStage + 1) % 4;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Simulate",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(LucideIcons.play, size: 10, color: AppTheme.primary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: List.generate(stages.length, (idx) {
                  final isDone = idx <= liveDeliveryStage;
                  final isCurrent = idx == liveDeliveryStage;
                  final color = isDone ? AppTheme.primary : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));
                  final textColor = isDone ? (isDark ? Colors.white : Colors.black87) : const Color(0xFF64748B);

                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if (idx > 0)
                              Expanded(
                                child: Container(
                                  height: 2.5,
                                  color: idx <= liveDeliveryStage ? AppTheme.primary : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                                ),
                              ),

                            Container(
                              padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
                              decoration: BoxDecoration(
                                color: isCurrent ? AppTheme.primary.withOpacity(0.2) : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: color,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                stages[idx]['icon'] as IconData,
                                size: isSmallScreen ? 12 : 16,
                                color: isDone ? AppTheme.primary : (isDark ? Colors.white24 : Colors.black26),
                              ),
                            ),

                            if (idx < stages.length - 1)
                              Expanded(
                                child: Container(
                                  height: 2.5,
                                  color: idx < liveDeliveryStage ? AppTheme.primary : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stages[idx]['title'] as String,
                          style: GoogleFonts.inter(
                            fontSize: isSmallScreen ? 9 : 11,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          radius: 16,
                          child: const Icon(LucideIcons.user, size: 16, color: AppTheme.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.riderName,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "EV Rider • ${order.riderPhone}",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFF64748B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "OTP: ${order.deliveryOtp}",
                      style: GoogleFonts.robotoMono(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 11 : 13,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
            onPressed: () => _showCartBottomSheet(isDark),
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

  Widget _buildInstructionChip(String text, IconData icon, StateSetter sheetState) {
    final isSelected = selectedInstruction == text;
    final isDark = widget.isDark;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedInstruction = text;
        });
        sheetState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.15)
              : (isDark ? AppTheme.cardDarkElevated : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? AppTheme.primary : (isDark ? Colors.white60 : Colors.black54),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppTheme.primary
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, bool isDark, {bool isPrimaryColor = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: isPrimaryColor
                ? AppTheme.primary
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showCartBottomSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter sheetState) {
            final double itemTotal = totalCartPrice;
            final double deliveryFee = (appliedCoupon == "SUPERMILK" && couponDiscount > 0) ? 0.0 : 35.0;
            const double platformFee = 2.0;
            final double taxes = (itemTotal * 0.05).roundToDouble();
            final double discount = couponDiscount;
            final double grandTotal = (itemTotal + deliveryFee + platformFee + taxes - discount).clamp(0.0, double.infinity);

            if (cartItems.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.shoppingBag, size: 64, color: Color(0xFF64748B)),
                    const SizedBox(height: 16),
                    Text(
                      "Your cart is empty",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Go Back"),
                    ),
                  ],
                ),
              );
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Basket Summary",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            "${cartItems.values.fold(0, (sum, q) => sum + q)} items",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final name = cartItems.keys.elementAt(index);
                          final qty = cartItems[name]!;
                          final product = allProductsList.firstWhere((p) => p['name'] == name);
                          final double price = (product['price'] as num).toDouble();
                          final String image = product['image'] as String;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.cardDark : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(image, style: const TextStyle(fontSize: 28)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "₹${price.toStringAsFixed(0)} each",
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(LucideIcons.minusSquare, color: AppTheme.primary, size: 22),
                                      onPressed: () {
                                        setState(() {
                                          if (qty > 1) {
                                            cartItems[name] = qty - 1;
                                          } else {
                                            cartItems.remove(name);
                                          }
                                        });
                                        sheetState(() {});
                                      },
                                    ),
                                    Text(
                                      "$qty",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.plusSquare, color: AppTheme.primary, size: 22),
                                      onPressed: () {
                                        setState(() {
                                          cartItems[name] = qty + 1;
                                        });
                                        sheetState(() {});
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "₹${(price * qty).toStringAsFixed(0)}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      Text(
                        "Delivery Partner Instructions",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildInstructionChip("Leave at gate", LucideIcons.shieldAlert, sheetState),
                            _buildInstructionChip("Avoid calling", LucideIcons.phoneOff, sheetState),
                            _buildInstructionChip("Don't ring bell", LucideIcons.bellOff, sheetState),
                            _buildInstructionChip("Hand over directly", LucideIcons.hand, sheetState),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: appliedCoupon != null ? AppTheme.primary : (isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.ticket, color: AppTheme.accent),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appliedCoupon != null ? "Coupon: $appliedCoupon" : "Apply promo code",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      appliedCoupon != null
                                          ? "Discount of ₹${discount.toStringAsFixed(0)} active"
                                          : "Savings up to ₹100 on your order",
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: appliedCoupon != null ? AppTheme.primary : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (appliedCoupon != null)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    appliedCoupon = null;
                                  });
                                  sheetState(() {});
                                },
                                child: const Text("Remove", style: TextStyle(color: AppTheme.danger)),
                              )
                            else
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (itemTotal >= 500) {
                                      appliedCoupon = "FLASH100";
                                    } else {
                                      appliedCoupon = "SUPERMILK";
                                    }
                                  });
                                  sheetState(() {});
                                },
                                child: const Text("Apply Best", style: TextStyle(color: AppTheme.primary)),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        "Bill Details",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildBillRow("Item Total", "₹${itemTotal.toStringAsFixed(0)}", isDark),
                            const Divider(height: 16),
                            _buildBillRow("Delivery Partner Fee", deliveryFee == 0 ? "FREE" : "₹${deliveryFee.toStringAsFixed(0)}", isDark, isPrimaryColor: deliveryFee == 0),
                            const Divider(height: 16),
                            _buildBillRow("Platform Fee", "₹${platformFee.toStringAsFixed(0)}", isDark),
                            const Divider(height: 16),
                            _buildBillRow("Taxes & Charges", "₹${taxes.toStringAsFixed(0)}", isDark),
                            if (discount > 0) ...[
                              const Divider(height: 16),
                              _buildBillRow("Coupon Discount", "-₹${discount.toStringAsFixed(0)}", isDark, isPrimaryColor: true),
                            ],
                            const Divider(height: 24, thickness: 1.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "To Pay",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                Text(
                                  "₹${grandTotal.toStringAsFixed(0)}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showOrderSuccessOverlay(isDark);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Place Order • ₹${grandTotal.toStringAsFixed(0)}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(LucideIcons.arrowRight, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showOrderSuccessOverlay(bool isDark) {
    final int generatedOrderId = 125000 + (1000 + (cartItems.hashCode.abs() % 1000));
    final String addressEta = selectedAddressEta.split(" • ")[0].replaceAll("⚡ ", "");

    setState(() {
      cartItems.clear();
      appliedCoupon = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? AppTheme.cardDarkElevated : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.checkCircle2,
                    color: AppTheme.primary,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Order Placed!",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your items will be dispatched instantly in 10-Min SLA.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.cardDark : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order ID", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                          Text("#ORD$generatedOrderId", style: GoogleFonts.robotoMono(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ETA", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                          Text(addressEta, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rider Assigned", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                          Text("Rohan Kumar", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Awesome",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
