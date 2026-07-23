import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class PortalSelectionView extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final Function(String role) onSelectRole;

  const PortalSelectionView({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onSelectRole,
  });

  @override
  State<PortalSelectionView> createState() => _PortalSelectionViewState();
}

class _PortalSelectionViewState extends State<PortalSelectionView> {
  String? hoveredRole;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bgGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A0C), Color(0xFF000000), Color(0xFF0A0A0C)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
          );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: Column(
          children: [
            // Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
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
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(LucideIcons.zap, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SmartMart",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            "Next-Gen 10-Min Quick Commerce Ecosystem",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "245 Dark Stores Online",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: widget.onToggleTheme,
                        icon: Icon(
                          isDark ? LucideIcons.sun : LucideIcons.moon,
                          color: isDark ? AppTheme.accent : const Color(0xFF0F172A),
                          size: 20,
                        ),
                        tooltip: "Toggle Light/Dark Theme",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Gateway Selection Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Column(
                  children: [
                    Text(
                      "Select Platform Gateway",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Choose your dedicated workspace dashboard to continue",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Cards Layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cards = [
                          _buildRoleCard(
                            roleId: "ADMIN",
                            title: "Super Admin Portal",
                            subtitle: "Desktop Executive Control Center",
                            badge: "FULL WEB DASHBOARD",
                            badgeColor: AppTheme.accent,
                            icon: LucideIcons.layoutDashboard,
                            description:
                                "Complete 360° visibility over dark stores, live rider telemetry, SKU inventory heatmaps, automated AI demand forecasting, and real-time SLA metrics.",
                            features: [
                              "Executive BI & Realtime Analytics",
                              "Dark Store Fleet & Rider Telemetry Map",
                              "Inventory Stock & SKU Catalog Control",
                              "AI Copilot Assistant & Order Management",
                            ],
                            buttonLabel: "Launch Super Admin Portal",
                            accentColor: AppTheme.primary,
                          ),
                          _buildRoleCard(
                            roleId: "RIDER",
                            title: "Rider Operations Portal",
                            subtitle: "Delivery Partner Operations",
                            badge: "DESKTOP & MOBILE WEB",
                            badgeColor: const Color(0xFF10B981),
                            icon: LucideIcons.bike,
                            description:
                                "Responsive web & mobile workspace for delivery partners. Manage instant order dispatch, turn-by-turn route navigation, OTP proof of delivery, live map telemetry, and earnings payouts.",
                            features: [
                              "Instant Order Request Overlay & Accept/Decline",
                              "OTP Verification Handshake & Proof of Delivery",
                              "Live Route Map & Fleet Telemetry Panel",
                              "Daily & Weekly Earnings Payout Stats",
                            ],
                            buttonLabel: "Launch Rider Portal",
                            accentColor: const Color(0xFF10B981),
                          ),
                          _buildRoleCard(
                            roleId: "CUSTOMER",
                            title: "Customer Storefront",
                            subtitle: "10-Minute Express Grocery Shop",
                            badge: "MOBILE & WEB APP",
                            badgeColor: const Color(0xFF8B5CF6),
                            icon: LucideIcons.shoppingBag,
                            description:
                                "Ultra-fast customer quick-commerce experience. Browse curated product categories, instant search, dynamic cart checkout, live order tracking, and Firebase auth integration.",
                            features: [
                              "10-Min Flash Delivery Catalog & Categories",
                              "Realtime Cart Checkout & UPI / Card Gateway",
                              "Live Delivery Order Tracking & ETA Map",
                              "Account Profile & Order History",
                            ],
                            buttonLabel: "Launch Customer Shop",
                            accentColor: const Color(0xFF8B5CF6),
                          ),
                        ];

                        if (constraints.maxWidth > 1100) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: cards[0]),
                              const SizedBox(width: 24),
                              Expanded(child: cards[1]),
                              const SizedBox(width: 24),
                              Expanded(child: cards[2]),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              cards[0],
                              const SizedBox(height: 24),
                              cards[1],
                              const SizedBox(height: 24),
                              cards[2],
                            ],
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 60),

                    // Bottom Telemetry Strip
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.cardDarkElevated.withOpacity(0.6) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTelemetryItem("12.4k", "Daily Orders Dispatched", LucideIcons.shoppingBag),
                          _buildTelemetryItem("94.8%", "10-Min SLA Fulfillment", LucideIcons.clock),
                          _buildTelemetryItem("1,840", "Active On-Duty Riders", LucideIcons.bike),
                          _buildTelemetryItem("\$148.2k", "Today Gross Revenue", LucideIcons.dollarSign),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String roleId,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required String description,
    required List<String> features,
    required String buttonLabel,
    required Color accentColor,
  }) {
    final isDark = widget.isDark;
    final isHovered = hoveredRole == roleId;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredRole = roleId),
      onExit: (_) => setState(() => hoveredRole = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered
                ? accentColor
                : (isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0)),
            width: isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? accentColor.withOpacity(0.2)
                  : Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: isHovered ? 24 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: accentColor, size: 30),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: badgeColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            Column(
              children: features.map((feat) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Icon(LucideIcons.checkCircle2, size: 16, color: accentColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feat,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => widget.onSelectRole(roleId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: isHovered ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.arrowRight, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryItem(String value, String label, IconData icon) {
    final isDark = widget.isDark;
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
