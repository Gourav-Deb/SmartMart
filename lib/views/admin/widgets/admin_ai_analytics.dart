import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';

class AdminAiAnalytics extends StatelessWidget {
  final bool isDark;

  const AdminAiAnalytics({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grid layout for ML Forecasting and Anomaly Logs
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1000;
            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _buildForecastingCard()),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: _buildAnomalyLogsCard()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildForecastingCard(),
                  const SizedBox(height: 16),
                  _buildAnomalyLogsCard(),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 20),
        // Stockout Risk Table
        _buildStockoutRiskCard(),
      ],
    );
  }

  Widget _buildForecastingCard() {
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
                      "ML Demand Surge Forecasting",
                      style: GoogleFonts.poppins(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Confidence Level: 94.8% SLA Target Prediction",
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "MODEL v4.2-LIVE",
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _legendItem("Historical Actuals", AppTheme.primary, isDashed: false),
              _legendItem("AI Predicted Demand", const Color(0xFF8B5CF6), isDashed: true),
              _legendItem("95% Prediction Interval", const Color(0xFF8B5CF6).withOpacity(0.15), isDashed: false, isRect: true),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: DemandForecastPainter(isDark: isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnomalyLogsCard() {
    final logs = [
      {
        'title': "Salt Lake Hub Demand Spike (+115%)",
        'desc': "AI reallocated 25 riders from Rajarhat to maintain SLA.",
        'time': "Just now",
        'type': "URGENT",
        'color': AppTheme.danger,
        'icon': LucideIcons.trendingUp,
      },
      {
        'title': "Route Delay Anomaly detected at Gariahat",
        'desc': "Average wait time increased by 4.2 mins. Re-routing dispatch stream.",
        'time': "8 mins ago",
        'type': "ROUTING",
        'color': AppTheme.accent,
        'icon': LucideIcons.map,
      },
      {
        'title': "Auto-Replenishment PO #PO-9921 triggered",
        'desc': "Amul Milk stock reached critical min threshold (ETA 45 mins).",
        'time': "25 mins ago",
        'type': "INVENTORY",
        'color': AppTheme.primary,
        'icon': LucideIcons.packageCheck,
      },
      {
        'title': "Zero fraud anomalies detected on gateways",
        'desc': "SLA security verification checked 12,458 orders successfully.",
        'time': "1 hr ago",
        'type': "SECURITY",
        'color': const Color(0xFF8B5CF6),
        'icon': LucideIcons.shieldCheck,
      },
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
                child: Text(
                  "Realtime AI Anomaly & Ops Log",
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(LucideIcons.activity, color: AppTheme.primary, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: logs.length,
              separatorBuilder: (context, index) => const Divider(height: 14),
              itemBuilder: (context, index) {
                final log = logs[index];
                final Color color = log['color'] as Color;
                final IconData icon = log['icon'] as IconData;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 16, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  log['title'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                log['time'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            log['desc'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
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

  Widget _buildStockoutRiskCard() {
    final alerts = [
      {
        'sku': 'Amul Taaza Milk 1L',
        'store': 'FreshMart Salt Lake',
        'stock': 12,
        'velocity': '8.2 units/hr',
        'coverage': '1.4 hrs',
        'status': 'CRITICAL',
        'color': AppTheme.danger,
      },
      {
        'sku': 'Britannia Wheat Bread 400g',
        'store': 'DailyNeeds Gariahat',
        'stock': 8,
        'velocity': '4.1 units/hr',
        'coverage': '1.9 hrs',
        'status': 'HIGH RISK',
        'color': AppTheme.accent,
      },
      {
        'sku': 'Fortune Sunflower Oil 1L',
        'store': 'SuperShop Behala',
        'stock': 5,
        'velocity': '1.2 units/hr',
        'coverage': '4.1 hrs',
        'status': 'REORDERING',
        'color': AppTheme.primary,
      },
      {
        'sku': 'Epigamia Yogurt 90g',
        'store': 'QuickStop Dumdum',
        'stock': 18,
        'velocity': '2.5 units/hr',
        'coverage': '7.2 hrs',
        'status': 'OPTIMAL',
        'color': const Color(0xFF8B5CF6),
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
                      "Predictive Stockout Risk & Coverage",
                      style: GoogleFonts.poppins(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Hours of coverage based on live store order velocities & replenishment ETAs",
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
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "AUTO-REORDER: ACTIVE",
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Responsive Table Wrapper
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 32,
              horizontalMargin: 0,
              headingRowHeight: 40,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 52,
              columns: [
                DataColumn(label: Text("PRODUCT SKU", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("DARK STORE", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("ON HAND", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("VELOCITY", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("AI COVERAGE", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                DataColumn(label: Text("REORDER STATUS", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
              ],
              rows: alerts.map((alert) {
                final Color color = alert['color'] as Color;
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Icon(LucideIcons.package, size: 14, color: color),
                          const SizedBox(width: 8),
                          Text(
                            alert['sku'] as String,
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(alert['store'] as String, style: GoogleFonts.inter(fontSize: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)))),
                    DataCell(Text("${alert['stock']} units", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold))),
                    DataCell(Text(alert['velocity'] as String, style: GoogleFonts.inter(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          alert['coverage'] as String,
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                        ),
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
                          alert['status'] as String,
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

  Widget _legendItem(String label, Color color, {required bool isDashed, bool isRect = false}) {
    return Row(
      children: [
        if (isRect)
          Container(
            width: 14,
            height: 8,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          )
        else if (isDashed)
          Row(
            children: List.generate(
              3,
              (index) => Container(
                width: 4,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                color: color,
              ),
            ),
          )
        else
          Container(
            width: 14,
            height: 3,
            color: color,
          ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
        ),
      ],
    );
  }
}

// Custom Painter for ML Demand Forecasting Chart
class DemandForecastPainter extends CustomPainter {
  final bool isDark;

  DemandForecastPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)
      ..strokeWidth = 1;

    // Draw Grid
    const int gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      double y = size.height * (i / gridLines);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Coordinates definition
    final actualPoints = [
      Offset(size.width * 0.0, size.height * 0.75),
      Offset(size.width * 0.12, size.height * 0.82),
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.38, size.height * 0.25),
      Offset(size.width * 0.50, size.height * 0.35),
      Offset(size.width * 0.62, size.height * 0.15),
    ];

    // Predict points (dashed line onwards)
    final predictedPoints = [
      Offset(size.width * 0.62, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.38),
      Offset(size.width * 0.88, size.height * 0.55),
      Offset(size.width * 1.0, size.height * 0.30),
    ];

    // Shaded Prediction interval
    final confidenceUpperPath = Path();
    confidenceUpperPath.moveTo(predictedPoints[0].dx, predictedPoints[0].dy - 10);
    confidenceUpperPath.cubicTo(
      predictedPoints[0].dx + (predictedPoints[1].dx - predictedPoints[0].dx) / 2, predictedPoints[0].dy - 20,
      predictedPoints[0].dx + (predictedPoints[1].dx - predictedPoints[0].dx) / 2, predictedPoints[1].dy - 35,
      predictedPoints[1].dx, predictedPoints[1].dy - 30,
    );
    confidenceUpperPath.cubicTo(
      predictedPoints[1].dx + (predictedPoints[2].dx - predictedPoints[1].dx) / 2, predictedPoints[1].dy - 35,
      predictedPoints[1].dx + (predictedPoints[2].dx - predictedPoints[1].dx) / 2, predictedPoints[2].dy - 45,
      predictedPoints[2].dx, predictedPoints[2].dy - 40,
    );
    confidenceUpperPath.cubicTo(
      predictedPoints[2].dx + (predictedPoints[3].dx - predictedPoints[2].dx) / 2, predictedPoints[2].dy - 45,
      predictedPoints[2].dx + (predictedPoints[3].dx - predictedPoints[2].dx) / 2, predictedPoints[3].dy - 55,
      predictedPoints[3].dx, predictedPoints[3].dy - 50,
    );

    final confidenceLowerPath = Path();
    confidenceLowerPath.moveTo(predictedPoints[0].dx, predictedPoints[0].dy + 10);
    confidenceLowerPath.cubicTo(
      predictedPoints[0].dx + (predictedPoints[1].dx - predictedPoints[0].dx) / 2, predictedPoints[0].dy + 20,
      predictedPoints[0].dx + (predictedPoints[1].dx - predictedPoints[0].dx) / 2, predictedPoints[1].dy + 35,
      predictedPoints[1].dx, predictedPoints[1].dy + 30,
    );
    confidenceLowerPath.cubicTo(
      predictedPoints[1].dx + (predictedPoints[2].dx - predictedPoints[1].dx) / 2, predictedPoints[1].dy + 35,
      predictedPoints[1].dx + (predictedPoints[2].dx - predictedPoints[1].dx) / 2, predictedPoints[2].dy + 45,
      predictedPoints[2].dx, predictedPoints[2].dy + 40,
    );
    confidenceLowerPath.cubicTo(
      predictedPoints[2].dx + (predictedPoints[3].dx - predictedPoints[2].dx) / 2, predictedPoints[2].dy + 45,
      predictedPoints[2].dx + (predictedPoints[3].dx - predictedPoints[2].dx) / 2, predictedPoints[3].dy + 55,
      predictedPoints[3].dx, predictedPoints[3].dy + 50,
    );

    // Merge upper and lower bounds for the interval area
    final intervalArea = Path();
    intervalArea.moveTo(predictedPoints[0].dx, predictedPoints[0].dy);
    // Draw upper path
    intervalArea.lineTo(predictedPoints[0].dx, predictedPoints[0].dy - 10);
    intervalArea.cubicTo(
      predictedPoints[0].dx + (predictedPoints[1].dx - predictedPoints[0].dx) / 2, predictedPoints[0].dy - 20,
      predictedPoints[0].dx + (predictedPoints[1].dx - predictedPoints[0].dx) / 2, predictedPoints[1].dy - 35,
      predictedPoints[1].dx, predictedPoints[1].dy - 30,
    );
    intervalArea.cubicTo(
      predictedPoints[1].dx + (predictedPoints[2].dx - predictedPoints[1].dx) / 2, predictedPoints[1].dy - 35,
      predictedPoints[1].dx + (predictedPoints[2].dx - predictedPoints[1].dx) / 2, predictedPoints[2].dy - 45,
      predictedPoints[2].dx, predictedPoints[2].dy - 40,
    );
    intervalArea.cubicTo(
      predictedPoints[2].dx + (predictedPoints[3].dx - predictedPoints[2].dx) / 2, predictedPoints[2].dy - 45,
      predictedPoints[2].dx + (predictedPoints[3].dx - predictedPoints[2].dx) / 2, predictedPoints[3].dy - 55,
      predictedPoints[3].dx, predictedPoints[3].dy - 50,
    );
    // Connect to lower path and go backwards
    intervalArea.lineTo(predictedPoints[3].dx, predictedPoints[3].dy + 50);
    intervalArea.cubicTo(
      predictedPoints[2].dx + (predictedPoints[3].dx - predictedPoints[2].dx) / 2, predictedPoints[3].dy + 55,
      predictedPoints[2].dx + (predictedPoints[3].dx - predictedPoints[2].dx) / 2, predictedPoints[2].dy + 45,
      predictedPoints[2].dx, predictedPoints[2].dy + 40,
    );
    intervalArea.cubicTo(
      predictedPoints[1].dx + (predictedPoints[2].dx - predictedPoints[1].dx) / 2, predictedPoints[2].dy + 45,
      predictedPoints[1].dx + (predictedPoints[2].dx - predictedPoints[1].dx) / 2, predictedPoints[1].dy + 35,
      predictedPoints[1].dx, predictedPoints[1].dy + 30,
    );
    intervalArea.cubicTo(
      predictedPoints[0].dx + (predictedPoints[1].dx - predictedPoints[0].dx) / 2, predictedPoints[1].dy + 35,
      predictedPoints[0].dx + (predictedPoints[1].dx - predictedPoints[0].dx) / 2, predictedPoints[0].dy + 20,
      predictedPoints[0].dx, predictedPoints[0].dy + 10,
    );
    intervalArea.close();

    final intervalPaint = Paint()
      ..color = const Color(0xFF8B5CF6).withOpacity(0.12)
      ..style = PaintingStyle.fill;
    canvas.drawPath(intervalArea, intervalPaint);

    // Paint Actual path
    final actualPath = Path();
    actualPath.moveTo(actualPoints[0].dx, actualPoints[0].dy);
    for (int i = 0; i < actualPoints.length - 1; i++) {
      final p1 = actualPoints[i];
      final p2 = actualPoints[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      actualPath.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    final actualPaint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawPath(actualPath, actualPaint);

    // Paint Predicted path (Dashed curve)
    final predictedPath = Path();
    predictedPath.moveTo(predictedPoints[0].dx, predictedPoints[0].dy);
    for (int i = 0; i < predictedPoints.length - 1; i++) {
      final p1 = predictedPoints[i];
      final p2 = predictedPoints[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      predictedPath.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    // Draw dashed path
    final predictedPaint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pathMetrics = predictedPath.computeMetrics();
    for (var metric in pathMetrics) {
      double length = 0;
      const double dashLength = 6.0;
      const double gapLength = 4.0;
      bool draw = true;
      while (length < metric.length) {
        final currentLength = draw ? dashLength : gapLength;
        if (draw) {
          final extract = metric.extractPath(length, length + currentLength);
          canvas.drawPath(extract, predictedPaint);
        }
        length += currentLength;
        draw = !draw;
      }
    }

    // Draw Dots
    final dotPaint = Paint()..color = AppTheme.primary;
    final forecastDotPaint = Paint()..color = const Color(0xFF8B5CF6);

    for (var p in actualPoints) {
      canvas.drawCircle(p, 4, dotPaint);
      canvas.drawCircle(p, 2, Paint()..color = Colors.white);
    }
    for (var p in predictedPoints.skip(1)) {
      canvas.drawCircle(p, 4, forecastDotPaint);
      canvas.drawCircle(p, 2, Paint()..color = Colors.white);
    }

    canvas.drawCircle(predictedPoints[0], 6, Paint()..color = AppTheme.accent);
    canvas.drawCircle(predictedPoints[0], 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
