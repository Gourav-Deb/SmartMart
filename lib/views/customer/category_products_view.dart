import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_theme.dart';

class CategoryProductsView extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> products;
  final Map<String, int> cartItems;
  final bool isDark;
  final Function(String name, int qty) onUpdateCart;

  const CategoryProductsView({
    super.key,
    required this.categoryName,
    required this.products,
    required this.cartItems,
    required this.isDark,
    required this.onUpdateCart,
  });

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  double get totalCartPrice {
    double total = 0;
    widget.cartItems.forEach((name, qty) {
      final product = widget.products.firstWhere((p) => p['name'] == name, orElse: () => {'price': 0});
      final double price = (product['price'] as num).toDouble();
      total += price * qty;
    });
    return total;
  }

  String? appliedCoupon;
  String selectedInstruction = "Leave at gate";

  double get couponDiscount {
    if (appliedCoupon == null) return 0.0;
    if (appliedCoupon == "FLASH100") {
      return totalCartPrice >= 500 ? 100.0 : 0.0;
    }
    if (appliedCoupon == "SUPERMILK") {
      bool hasDairy = false;
      widget.cartItems.forEach((name, qty) {
        final p = widget.products.firstWhere((prod) => prod['name'] == name, orElse: () => {});
        if (p.isNotEmpty && p['category'] == 'Dairy & Eggs') {
          hasDairy = true;
        }
      });
      return hasDairy ? 35.0 : 0.0;
    }
    if (appliedCoupon == "FRESH20") {
      double freshTotal = 0.0;
      widget.cartItems.forEach((name, qty) {
        final p = widget.products.firstWhere((prod) => prod['name'] == name, orElse: () => {});
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
    final filteredProducts = widget.products.where((p) {
      final matchesCategory = p['category'] == widget.categoryName;
      final matchesSearch = searchQuery.isEmpty || p['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    Color categoryThemeColor = const Color(0xFF10B981);
    if (widget.categoryName == 'Dairy & Eggs') categoryThemeColor = const Color(0xFF0284C7);
    if (widget.categoryName == 'Fresh Fruits') categoryThemeColor = const Color(0xFFEF4444);
    if (widget.categoryName == 'Snacks') categoryThemeColor = const Color(0xFFF97316);
    if (widget.categoryName == 'Supplements') categoryThemeColor = const Color(0xFF8B5CF6);
    if (widget.categoryName == 'Decorations') categoryThemeColor = const Color(0xFFEC4899);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: categoryThemeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${filteredProducts.length} items",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: categoryThemeColor,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
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
                    hintText: "Search in ${widget.categoryName}...",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.5,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.searchCode, size: 48, color: AppTheme.danger),
                          const SizedBox(height: 12),
                          Text(
                            "No products found",
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                          ),
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 3 : 2);
                        final double childAspectRatio = constraints.maxWidth < 360 ? 0.64 : (constraints.maxWidth < 480 ? 0.68 : 0.75);
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            final int qty = widget.cartItems[name] ?? 0;

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
                                        color: categoryThemeColor.withOpacity(0.08),
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
                                                setState(() {
                                                  widget.onUpdateCart(name, 1);
                                                });
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
                                                        widget.onUpdateCart(name, qty - 1);
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
                                                      setState(() {
                                                        widget.onUpdateCart(name, qty + 1);
                                                      });
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
                    ),
            ),

            if (widget.cartItems.isNotEmpty) _buildCartCheckoutBar(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildCartCheckoutBar(bool isDark) {
    final count = widget.cartItems.values.fold(0, (sum, q) => sum + q);

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

            if (widget.cartItems.isEmpty) {
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
                            "${widget.cartItems.values.fold(0, (sum, q) => sum + q)} items",
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
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final name = widget.cartItems.keys.elementAt(index);
                          final qty = widget.cartItems[name]!;
                          final product = widget.products.firstWhere((p) => p['name'] == name);
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
                                          widget.onUpdateCart(name, qty - 1);
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
                                          widget.onUpdateCart(name, qty + 1);
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

  void _showOrderSuccessOverlay(bool isDark) {
    final int generatedOrderId = 125000 + (1000 + (widget.cartItems.hashCode.abs() % 1000));
    const String addressEta = "8 mins";

    setState(() {
      widget.cartItems.clear();
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
