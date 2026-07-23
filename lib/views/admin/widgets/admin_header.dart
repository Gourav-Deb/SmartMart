import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class AdminHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenAiCopilot;
  final VoidCallback? onLogout;

  const AdminHeader({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onOpenAiCopilot,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth <= 900;

    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.bgDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Drawer Hamburger Menu Button on Mobile
          if (isMobile) ...[
            IconButton(
              icon: Icon(
                LucideIcons.menu,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                size: 22,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: "Open Menu",
            ),
            const SizedBox(width: 8),
          ],

          // Data Query Search Input with Shortcut
          Expanded(
            child: Container(
              height: 40,
              constraints: const BoxConstraints(maxWidth: 420),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDarkElevated : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0),
                ),
              ),
              child: TextField(
                style: GoogleFonts.inter(fontSize: 12.5, color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: isMobile ? "Search..." : "Query data: SKU, Store ID, SLA status... (Ctrl + K)",
                  hintStyle: GoogleFonts.inter(fontSize: 12, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                  prefixIcon: Icon(LucideIcons.search, size: 15, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 9),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Date Range Filter Badge (Hidden on Mobile)
          if (!isMobile) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDarkElevated : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 13, color: AppTheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    "15 May - 21 May, 2025",
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.chevronDown, size: 13, color: Color(0xFF64748B)),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Notification Bell
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  LucideIcons.bell,
                  size: 19,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                ),
                onPressed: () {},
                tooltip: "Data Alerts",
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppTheme.danger,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "12",
                    style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          // Dark/Light Mode Toggle
          IconButton(
            icon: Icon(
              isDark ? LucideIcons.sun : LucideIcons.moon,
              size: 19,
              color: isDark ? const Color(0xFFF59E0B) : const Color(0xFF475569),
            ),
            onPressed: onToggleTheme,
            tooltip: isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
          ),
          const SizedBox(width: 4),

          if (onLogout != null) ...[
            IconButton(
              icon: const Icon(
                LucideIcons.logOut,
                size: 18,
                color: AppTheme.danger,
              ),
              onPressed: onLogout,
              tooltip: "Sign Out of Store Owner Portal",
            ),
            const SizedBox(width: 4),
          ],

          // User Profile Dropdown
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage("https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200"),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      "Store Owner",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(LucideIcons.chevronDown, size: 13, color: Color(0xFF64748B)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
