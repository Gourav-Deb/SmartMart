import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';

class AdminRiderAnalytics extends StatelessWidget {
  final bool isDark;

  const AdminRiderAnalytics({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Responsive Layout for Fleet Utilization and Route Telemetry
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1000;
            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _buildFleetUtilizationCard()),
                  const SizedBox(width: 16),
                  Expanded(flex: 6, child: _buildRouteTelemetryCard()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildFleetUtilizationCard(),
                  const SizedBox(height: 16),
                  _buildRouteTelemetryCard(),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 20),
        // Rider Cohorts table
        _buildRiderCohortsCard(),
      ],
    );
  }

  Widget _buildFleetUtilizationCard() {
    final statusMetrics = [
      {'label': 'Active Delivery In-Transit', 'count': 820, 'percentage': 65.8, 'color': AppTheme.primary},
      {'label': 'At Dark Store Waiting', 'count': 214, 'percentage': 17.2, 'color': AppTheme.secondary},
      {'label': 'Idle / Search State', 'count': 112, 'percentage': 9.0, 'color': AppTheme.accent},
      {'label': 'Transit to Hub', 'count': 99, 'percentage': 8.0, 'color': const Color(0xFF8B5CF6)},
    ];

    return Container(
      height: 380,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassCard(isDark: isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fleet capacity & Duty State",
                      style: GoogleFonts.poppins(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Realtime allocation across 1,245 on-duty riders",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(LucideIcons.bike, color: AppTheme.primary, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          // Stacked bar visual
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 22,
              child: Row(
                children: statusMetrics.map((met) {
                  final double val = met['percentage'] as double;
                  final Color color = met['color'] as Color;
                  return Expanded(
                    flex: (val * 10).round(),
                    child: Container(
                      color: color,
                      child: Center(
                        child: Text(
                          "${val.toStringAsFixed(0)}%",
                          style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legend list
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statusMetrics.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final met = statusMetrics[index];
                final Color color = met['color'] as Color;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          met['label'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${met['count']} Riders (${met['percentage']}%)",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteTelemetryCard() {
    final telemetry = [
      {'title': 'Target Dispatch Speed', 'value': '1.4 mins', 'sub': 'Hub order assign to checkout', 'icon': LucideIcons.zap, 'color': AppTheme.primary},
      {'title': 'GPS Path Deviations', 'value': '1.2%', 'sub': 'Riders deviating from optimal path', 'icon': LucideIcons.navigation, 'color': const Color(0xFF8B5CF6)},
      {'title': 'Average Hub Queue Time', 'value': '3.2 mins', 'sub': 'Rider waiting at store pickup', 'icon': LucideIcons.clock, 'color': AppTheme.accent},
      {'title': 'Delivery Handshake SLA', 'value': '1.1 mins', 'sub': 'Rider arrival to customer OTP', 'icon': LucideIcons.userCheck, 'color': AppTheme.secondary},
    ];

    return Container(
      height: 380,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassCard(isDark: isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GPS Route & Handoff Telemetry",
            style: GoogleFonts.poppins(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Granular micro-SLA tracking of order dispatch pipelines",
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: telemetry.length,
              itemBuilder: (context, index) {
                final item = telemetry[index];
                final Color color = item['color'] as Color;
                final IconData icon = item['icon'] as IconData;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(icon, size: 16, color: color),
                          Text(
                            item['value'] as String,
                            style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.bold, color: color),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            item['sub'] as String,
                            style: GoogleFonts.inter(fontSize: 9.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget _buildRiderCohortsCard() {
    final cohorts = [
      {
        'type': 'EV Smart Scooter Fleet',
        'count': 640,
        'avgTime': '8.1 mins',
        'rating': '4.91 ★',
        'margin': '₹38.2 / del',
        'tips': '₹24 avg',
        'retention': '91.4%',
        'status': 'HIGH MARGIN',
        'color': AppTheme.primary,
      },
      {
        'type': 'E-bike / Cycle Fleet',
        'count': 320,
        'avgTime': '10.8 mins',
        'rating': '4.82 ★',
        'margin': '₹45.0 / del',
        'tips': '₹18 avg',
        'retention': '84.2%',
        'status': 'ECO OPTIMAL',
        'color': AppTheme.secondary,
      },
      {
        'type': 'Gas Powered Motorcycle',
        'count': 285,
        'avgTime': '7.9 mins',
        'rating': '4.78 ★',
        'margin': '₹29.4 / del',
        'tips': '₹28 avg',
        'retention': '78.5%',
        'status': 'HIGH COSTS',
        'color': AppTheme.danger,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassCard(isDark: isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fleet Vehicle Cohort Performance Analytics",
                      style: GoogleFonts.poppins(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Comparative metrics analyzing delivery speeds, margins, and customer service by rider transport cohort",
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "EV TRANSITION: +14% ROI",
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 36,
              horizontalMargin: 0,
              headingRowHeight: 40,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 52,
              columns: [
                DataColumn(label: Text("VEHICLE COHORT", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("FLEET SIZE", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("AVG SLA TIME", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("RATING", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("NET MARGIN", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("CUSTOMER TIPS", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("RETENTION (30D)", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("ROI STATUS", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
              ],
              rows: cohorts.map((coh) {
                final Color color = coh['color'] as Color;
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Icon(LucideIcons.bike, size: 14, color: color),
                          const SizedBox(width: 8),
                          Text(
                            coh['type'] as String,
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text("${coh['count']} riders", style: GoogleFonts.inter(fontSize: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)))),
                    DataCell(Text(coh['avgTime'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary))),
                    DataCell(Text(coh['rating'] as String, style: GoogleFonts.inter(fontSize: 12))),
                    DataCell(Text(coh['margin'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(coh['tips'] as String, style: GoogleFonts.inter(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                    DataCell(
                      Text(
                        coh['retention'] as String,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Text(
                          coh['status'] as String,
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
