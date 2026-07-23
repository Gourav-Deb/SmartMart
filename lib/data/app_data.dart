import 'package:flutter/material.dart';

class ProductItem {
  final String id;
  final String name;
  final String category;
  final String price;
  final String originalPrice;
  final String image;
  final String icon;
  final String unit;
  final Color color;

  const ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.image,
    this.icon = '🥦',
    required this.unit,
    this.color = const Color(0xFF10B981),
  });
}

class ShopCategory {
  final String id;
  final String name;
  final String title;
  final String icon;
  final Color tint;
  final String topTab;
  final List<ProductItem> products;

  const ShopCategory({
    required this.id,
    required this.name,
    String? title,
    required this.icon,
    this.tint = const Color(0xFFECFDF5),
    this.topTab = 'All',
    this.products = const [],
  }) : title = title ?? name;
}

class AppStore {
  final String name;
  final String address;
  final String distance;
  final String timing;
  final bool isOpen;

  const AppStore({
    required this.name,
    required this.address,
    required this.distance,
    required this.timing,
    this.isOpen = true,
  });
}

class AppData {
  static const List<ShopCategory> categories = [
    ShopCategory(
      id: 'dairy',
      name: 'Dairy & Eggs',
      icon: '🥛',
      tint: Color(0xFFE0F2FE),
      topTab: 'Dairy & Breakfast',
      products: [
        ProductItem(id: 'p1', name: 'Amul Taaza Milk 500ml', category: 'dairy', price: '₹27', originalPrice: '₹30', image: '🥛', icon: '🥛', unit: '500 ml', color: Color(0xFF0284C7)),
        ProductItem(id: 'p2', name: 'Amul Butter 500g', category: 'dairy', price: '₹275', originalPrice: '₹290', image: '🧈', icon: '🧈', unit: '500 g', color: Color(0xFFEAB308)),
      ],
    ),
    ShopCategory(
      id: 'fruits',
      name: 'Fresh Fruits',
      icon: '🍎',
      tint: Color(0xFFFEE2E2),
      topTab: 'Fruits & Veggies',
      products: [
        ProductItem(id: 'p3', name: 'Robusta Bananas 1kg', category: 'fruits', price: '₹45', originalPrice: '₹55', image: '🍌', icon: '🍌', unit: '1 kg', color: Color(0xFFEAB308)),
        ProductItem(id: 'p4', name: 'Shimla Apples 1kg', category: 'fruits', price: '₹180', originalPrice: '₹210', image: '🍎', icon: '🍎', unit: '1 kg', color: Color(0xFFEF4444)),
      ],
    ),
    ShopCategory(
      id: 'veg',
      name: 'Veggies',
      icon: '🥦',
      tint: Color(0xFFDCFCE7),
      topTab: 'Fruits & Veggies',
      products: [
        ProductItem(id: 'p5', name: 'Fresh Potatoes 1kg', category: 'veg', price: '₹32', originalPrice: '₹40', image: '🥔', icon: '🥔', unit: '1 kg', color: Color(0xFF84CC16)),
        ProductItem(id: 'p6', name: 'Hybrid Tomatoes 500g', category: 'veg', price: '₹28', originalPrice: '₹35', image: '🍅', icon: '🍅', unit: '500 g', color: Color(0xFFEF4444)),
      ],
    ),
    ShopCategory(
      id: 'supplements',
      name: 'Supplements',
      icon: '💪',
      tint: Color(0xFFF5F3FF),
      topTab: 'Supplements',
      products: [
        ProductItem(id: 'p_supp1', name: 'Optimum Nutrition Whey 1kg', category: 'supplements', price: '₹3,499', originalPrice: '₹3,899', image: '💪', icon: '💪', unit: '1 kg', color: Color(0xFF8B5CF6)),
        ProductItem(id: 'p_supp2', name: 'MuscleBlaze Creatine 250g', category: 'supplements', price: '₹649', originalPrice: '₹799', image: '⚡', icon: '⚡', unit: '250 g', color: Color(0xFF8B5CF6)),
      ],
    ),
    ShopCategory(
      id: 'decorations',
      name: 'Decorations',
      icon: '🎈',
      tint: Color(0xFFFFF1F2),
      topTab: 'Decorations',
      products: [
        ProductItem(id: 'p_dec1', name: 'Metallic Birthday Balloons', category: 'decorations', price: '₹120', originalPrice: '₹199', image: '🎈', icon: '🎈', unit: '50 pcs', color: Color(0xFFEC4899)),
        ProductItem(id: 'p_dec2', name: 'LED Fairy String Lights', category: 'decorations', price: '₹180', originalPrice: '₹299', image: '💡', icon: '💡', unit: '10 m', color: Color(0xFFEC4899)),
      ],
    ),
  ];

  static const List<ProductItem> featuredProducts = [
    ProductItem(id: 'p1', name: 'Amul Taaza Milk 500ml', category: 'dairy', price: '₹27', originalPrice: '₹30', image: '🥛', icon: '🥛', unit: '500 ml', color: Color(0xFF0284C7)),
    ProductItem(id: 'p2', name: 'Fresh Robusta Bananas 1kg', category: 'fruits', price: '₹45', originalPrice: '₹55', image: '🍌', icon: '🍌', unit: '1 kg', color: Color(0xFFEAB308)),
    ProductItem(id: 'p3', name: 'Harvest Gold Bread', category: 'bakery', price: '₹40', originalPrice: '₹45', image: '🍞', icon: '🍞', unit: '400 g', color: Color(0xFFF97316)),
  ];

  static List<ProductItem> get allProducts => featuredProducts;

  static const List<String> promoBanners = [
    '⚡ 10-Minute Express Delivery Guarantee',
    '🎉 Up to 50% OFF on Dairy & Breakfast Essentials',
    '🛵 Zero Delivery Fee on Orders Above ₹199',
  ];

  static List<String> get banners => promoBanners;

  static const List<String> locations = [
    'Salt Lake Sector 1, Kolkata',
    'Ballygunge Gariahat, Kolkata',
    'Park Street, Kolkata',
  ];

  static const List<String> locationAddresses = [
    'AE Block, Salt Lake, Kolkata - 700064',
    'Gariahat Crossing, Ballygunge, Kolkata - 700019',
    'Park Street, Near Metro, Kolkata - 700016',
  ];

  static const List<AppStore> stores = [
    AppStore(name: 'FreshMart Salt Lake', address: 'DF Block, Salt Lake, Kolkata', distance: '1.2 km', timing: '6 AM - 11 PM'),
    AppStore(name: 'DailyNeeds Gariahat', address: 'Ballygunge Circular Rd, Kolkata', distance: '2.5 km', timing: '6 AM - 11 PM'),
  ];

  static const List<String> topTabs = [
    'All Categories',
    'Dairy & Breakfast',
    'Fruits & Veggies',
    'Snacks & Munchies',
  ];

  static List<ShopCategory> categoriesForTab(String tab) {
    if (tab == 'All Categories' || tab == 'All') return categories;
    return categories.where((c) => c.topTab == tab).toList();
  }
}
