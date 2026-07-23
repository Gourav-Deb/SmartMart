import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_theme.dart';
import '../../models/quick_commerce_models.dart';
import 'widgets/admin_sidebar.dart';
import 'widgets/admin_header.dart';
import 'widgets/admin_kpis.dart';
import 'widgets/admin_charts.dart';
import 'widgets/admin_fleet_map.dart';
import 'widgets/admin_orders_table.dart';
import 'widgets/admin_ai_drawer.dart';
import 'widgets/admin_quick_actions.dart';
import 'widgets/admin_tab_views.dart';
import 'widgets/admin_ai_analytics.dart';
import 'widgets/admin_rider_analytics.dart';

class AdminDashboardView extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback? onLogout;

  const AdminDashboardView({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    this.onLogout,
  });

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  String? _activeTab;
  String? _selectedTimeframe;
  String? _selectedStoreFilter;
  bool isAiDrawerOpen = false;
  OrderModel? selectedOrder;
  String dashboardMode = "Overview"; // "Overview", "AI Analytics", "Rider Cohorts"

  String get activeTab => _activeTab ?? "Dashboard";
  String get selectedTimeframe => _selectedTimeframe ?? "Realtime Today";
  String get selectedStoreFilter => _selectedStoreFilter ?? "Dark Store #14 - Delhi NCR";

  @override
  void initState() {
    super.initState();
    _activeTab = "Dashboard";
    _selectedTimeframe = "Realtime Today";
    _selectedStoreFilter = "Dark Store #14 - Delhi NCR";
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth <= 900;

    final Widget sidebar = AdminSidebar(
      activeTab: activeTab,
      onSelectTab: (tab) {
        setState(() => _activeTab = tab);
        if (isMobile) {
          Navigator.of(context).pop(); // Close drawer on mobile selection
        }
      },
      isDark: widget.isDark,
      onLogout: widget.onLogout,
    );

    return Scaffold(
      backgroundColor: widget.isDark ? AppTheme.bgDark : AppTheme.bgLight,
      drawer: isMobile ? Drawer(child: sidebar) : null,
      body: Stack(
        children: [
          Row(
            children: [
              // Left Sidebar (only shown inline on desktop)
              if (!isMobile) sidebar,

              // Main Body Content Area
              Expanded(
                child: Column(
                  children: [
                    // Top Header Bar
                    AdminHeader(
                      isDark: widget.isDark,
                      onToggleTheme: widget.onToggleTheme,
                      onOpenAiCopilot: () => setState(() => isAiDrawerOpen = true),
                      onLogout: widget.onLogout,
                    ),

                    // Scrollable Dynamic Tab Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: activeTab == "Dashboard"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Data Analytics Header Banner
                                  Flex(
                                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                                    crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            spacing: 10,
                                            runSpacing: 6,
                                            children: [
                                              Text(
                                                "Dark Store Management Hub",
                                                style: GoogleFonts.poppins(
                                                  fontSize: isMobile ? 18.5 : 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.primary.withOpacity(0.15),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "LIVE STREAMING",
                                                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Real-time local fulfillment telemetry, inventory levels, local fleet stats, and order fulfillment diagnostic tools",
                                            style: GoogleFonts.inter(
                                              fontSize: isMobile ? 11.5 : 12.5,
                                              color: widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isMobile) const SizedBox(height: 16),

                                      // Timeframe & Store Selector Bar
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          // Store Selector Dropdown Pill
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: widget.isDark ? AppTheme.cardDarkElevated : Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: widget.isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(LucideIcons.store, size: 14, color: AppTheme.primary),
                                                const SizedBox(width: 8),
                                                Text(
                                                  selectedStoreFilter,
                                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: widget.isDark ? Colors.white : Colors.black),
                                                ),
                                                const SizedBox(width: 6),
                                                const Icon(LucideIcons.chevronDown, size: 14, color: Color(0xFF64748B)),
                                              ],
                                            ),
                                          ),

                                          // Timeframe Pills
                                          Wrap(
                                            spacing: 4,
                                            children: ["Realtime Today", "7 Days", "30 Days", "YTD"].map((tf) {
                                              final bool isActive = selectedTimeframe == tf;
                                              return InkWell(
                                                onTap: () => setState(() => _selectedTimeframe = tf),
                                                borderRadius: BorderRadius.circular(8),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                                  decoration: BoxDecoration(
                                                    color: isActive
                                                        ? AppTheme.primary
                                                        : (widget.isDark ? AppTheme.cardDarkElevated : const Color(0xFFF1F5F9)),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    tf,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 11,
                                                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                                      color: isActive ? Colors.white : (widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Dashboard View Mode Segmented Selector
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        _dashboardModePill("Overview", LucideIcons.lineChart),
                                        const SizedBox(width: 10),
                                        _dashboardModePill("AI Analytics", LucideIcons.brainCircuit),
                                        const SizedBox(width: 10),
                                        _dashboardModePill("Rider Cohorts", LucideIcons.bike),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  if (dashboardMode == "Overview") ...[
                                    // Data Analytics KPI Cards Grid
                                    AdminKPIs(isDark: widget.isDark),
                                    const SizedBox(height: 20),

                                    // Multi-Chart Data Analytics Visualizations
                                    AdminCharts(isDark: widget.isDark),
                                    const SizedBox(height: 20),

                                    // Live Fleet & Order Canvas Map
                                    AdminFleetMap(isDark: widget.isDark),
                                    const SizedBox(height: 20),

                                    // Orders Stream & Telemetry Table
                                    AdminOrdersTable(
                                      isDark: widget.isDark,
                                      onSelectOrder: (order) {
                                        setState(() => selectedOrder = order);
                                        _showOrderTelemetryModal(context, order);
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Quick Actions Operations Bar
                                    AdminQuickActions(
                                      isDark: widget.isDark,
                                      onTriggerAction: (actionName) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Triggered operational action: $actionName"),
                                            backgroundColor: AppTheme.primary,
                                          ),
                                        );
                                      },
                                    ),
                                  ] else if (dashboardMode == "AI Analytics") ...[
                                    AdminAiAnalytics(isDark: widget.isDark),
                                  ] else ...[
                                    AdminRiderAnalytics(isDark: widget.isDark),
                                  ],
                                ],
                              )
                            : AdminTabViews.buildTabView(
                                context: context,
                                activeTab: activeTab,
                                isDark: widget.isDark,
                                onSelectOrder: (order) {
                                  setState(() => selectedOrder = order);
                                  _showOrderTelemetryModal(context, order);
                                },
                                onRefresh: () {
                                  setState(() {});
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Slide-out AI Analytics Drawer
          if (isAiDrawerOpen)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: AdminAiDrawer(
                isDark: widget.isDark,
                onClose: () => setState(() => isAiDrawerOpen = false),
              ),
            ),
        ],
      ),
    );
  }

  void _showOrderTelemetryModal(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: widget.isDark ? const Color(0xFF1E293B) : Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.activity, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Telemetry Inspector: ${order.id}",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 16),
                  ),
                ],
              ),
              IconButton(icon: const Icon(LucideIcons.x), onPressed: () => Navigator.pop(context)),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Customer: ${order.customerName}", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    Text("Phone: ${order.customerPhone}", style: GoogleFonts.inter(fontSize: 12)),
                  ],
                ),
                Text("Address: ${order.customerAddress}", style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B))),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dark Store: ${order.storeName}", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    Text("Rider: ${order.riderName}", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.secondary)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SLA Class: ${order.fulfillmentSla}", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    Text("Fulfillment ETA: ${order.eta}", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text("Gross Margin: ${order.margin}", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  ],
                ),
                const Divider(height: 20),
                Text("Item Breakdown:", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ...order.items.map((item) => Text("• $item", style: GoogleFonts.inter(fontSize: 12))),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Paid: ${order.amount} (${order.paymentMode})", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    Text("OTP: Pickup ${order.pickupOtp} | Drop ${order.deliveryOtp}", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dashboardModePill(String mode, IconData icon) {
    final bool isActive = dashboardMode == mode;
    return InkWell(
      onTap: () => setState(() => dashboardMode = mode),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primary
              : (widget.isDark ? AppTheme.cardDarkElevated : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : (widget.isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive ? Colors.white : (widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 8),
            Text(
              mode,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? Colors.white : (widget.isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
