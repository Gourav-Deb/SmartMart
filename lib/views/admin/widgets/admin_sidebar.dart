import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class AdminSidebar extends StatelessWidget {
  final String activeTab;
  final Function(String) onSelectTab;
  final bool isDark;
  final VoidCallback? onLogout;

  const AdminSidebar({
    super.key,
    required this.activeTab,
    required this.onSelectTab,
    required this.isDark,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'title': 'Dashboard', 'icon': LucideIcons.layoutDashboard, 'tag': 'BI Live'},
      {'title': 'Orders', 'icon': LucideIcons.shoppingBag, 'tag': '12.4k'},
      {'title': 'Stores', 'icon': LucideIcons.store, 'tag': '245 Hubs'},
      {'title': 'Categories', 'icon': LucideIcons.grid, 'tag': '6 Sectors'},
      {'title': 'Customers', 'icon': LucideIcons.users, 'tag': '78.4% Ret'},
      {'title': 'Riders', 'icon': LucideIcons.bike, 'tag': '88.4% Duty'},
      {'title': 'Payments', 'icon': LucideIcons.creditCard, 'tag': '99.4% Succ'},
      {'title': 'Coupons', 'icon': LucideIcons.ticket, 'tag': '24 Active'},
      {'title': 'Reports', 'icon': LucideIcons.fileText, 'tag': 'Auto Export'},
      {'title': 'Settings', 'icon': LucideIcons.settings, 'tag': 'Guardrails'},
    ];

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.bgDark : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Brand Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
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
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.zap, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SmartMart",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1E293B)),
          const SizedBox(height: 10),

          // Menu List with Data Analyst Telemetry Badges
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final String title = item['title'] as String;
                final IconData icon = item['icon'] as IconData;
                final String tag = item['tag'] as String;
                final bool isActive = activeTab == title;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onSelectTab(title),
                      hoverColor: isDark ? AppTheme.cardDarkElevated : const Color(0xFFF1F5F9),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? (isDark ? AppTheme.primary.withOpacity(0.18) : AppTheme.primary.withOpacity(0.1))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isActive
                              ? Border.all(color: AppTheme.primary.withOpacity(0.4), width: 1)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              size: 17,
                              color: isActive
                                  ? AppTheme.primary
                                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              title,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                color: isActive
                                    ? (isDark ? Colors.white : AppTheme.primary)
                                    : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppTheme.primary
                                    : (isDark ? AppTheme.cardDarkElevated : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? Colors.white : (isDark ? const Color(0xFF64748B) : const Color(0xFF64748B)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Logout Action Button
          if (onLogout != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
              child: InkWell(
                onTap: onLogout,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.danger.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.logOut, size: 14, color: AppTheme.danger),
                      const SizedBox(width: 8),
                      Text(
                        "Sign Out",
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Footer Profile / Analyst Role
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDarkElevated : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                   const CircleAvatar(
                    radius: 15,
                    backgroundColor: AppTheme.primary,
                    child: Text("SO", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Store Owner",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "manager@smartmart.ai",
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.store, size: 14, color: AppTheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
