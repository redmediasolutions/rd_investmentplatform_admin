import 'package:care_kapital_webapp_admin/Theme/apptheme.dart';
import 'package:care_kapital_webapp_admin/pages/dashboard/dashboard_controller.dart';
import 'package:care_kapital_webapp_admin/pages/dashboard/dashboard_models.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController _controller = DashboardController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.fetchDashboard();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: backgroundLight,
        elevation: 0,
        toolbarHeight: 80,

        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Welcome back! Here's what's happening today.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: textGrey),
            ),
          ],
        ),
      ),
      body: _controller.loading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(_controller.error!),
                  TextButton.icon(
                    onPressed: _controller.fetchDashboard,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _controller.data == null
          ? const SizedBox()
          : _buildBody(_controller.data!),
    );
  }

  Widget _buildBody(DashboardModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Row
          Row(
            children: [
              Expanded(
                child: _kpiCard(
                  label: 'Total Investors',
                  value: data.kpis.totalInvestors.toString(),
                  sub: '+12.5% from last month',
                  subColor: successGreen,
                  icon: Icons.people_outline,
                  iconColor: primaryBlue,
                  upTrend: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _kpiCard(
                  label: 'Assets Under Management',
                  value: data.kpis.formattedAum,
                  sub: '+8.3% from last month',
                  subColor: successGreen,
                  icon: Icons.trending_up,
                  iconColor: successGreen,
                  upTrend: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _kpiCard(
                  label: 'Payouts This Month',
                  value: data.kpis.formattedPayouts,
                  sub: '${data.kpis.pendingPayouts} pending',
                  subColor: Colors.orange,
                  icon: Icons.attach_money,
                  iconColor: Colors.orange,
                  upTrend: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _kpiCard(
                  label: 'Open Tickets',
                  value: data.todayStats.urgentTickets.toString(),
                  sub: 'Urgent tickets',
                  subColor: Colors.red,
                  icon: Icons.confirmation_number_outlined,
                  iconColor: Colors.red,
                  upTrend: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Middle row — Top Investors + Bond Distribution
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _topInvestorsCard(data.topInvestors)),
              const SizedBox(width: 20),
              Expanded(child: _bondDistributionCard(data.bondDistribution)),
            ],
          ),
          const SizedBox(height: 24),

          // Bottom row — Recent Activities + Today's Stats
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _recentActivitiesCard(data.recentActivities),
              ),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _todayStatsCard(data.todayStats)),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── KPI Card ──────────────────────────────────────────
  Widget _kpiCard({
    required String label,
    required String value,
    required String sub,
    required Color subColor,
    required IconData icon,
    required Color iconColor,
    required bool upTrend,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                upTrend ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: subColor,
              ),
              const SizedBox(width: 4),
              Text(
                sub,
                style: TextStyle(
                  color: subColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Top Investors Card ────────────────────────────────
  Widget _topInvestorsCard(List<TopInvestor> investors) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_outline, color: primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Top Investors',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Highest portfolio values',
            style: TextStyle(fontSize: 13, color: textGrey),
          ),
          const SizedBox(height: 20),
          if (investors.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No investor data yet',
                  style: TextStyle(color: textGrey),
                ),
              ),
            )
          else
            ...investors.asMap().entries.map((entry) {
              final i = entry.key;
              final inv = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    // Rank badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inv.name.isNotEmpty
                                ? inv.name
                                : inv.email.split('@')[0],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textDark,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${inv.investmentCount} investments',
                            style: TextStyle(color: textGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // Value
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          inv.formattedInvested,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textDark,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // ── Bond Distribution Card ────────────────────────────
  Widget _bondDistributionCard(List<BondDistribution> bonds) {
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF22C55E),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEF4444),
    ];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grid_view_outlined, color: successGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                'Bond Distribution',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('By category', style: TextStyle(fontSize: 13, color: textGrey)),
          const SizedBox(height: 24),
          if (bonds.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No bond data yet',
                  style: TextStyle(color: textGrey),
                ),
              ),
            )
          else
            ...bonds.asMap().entries.map((entry) {
              final i = entry.key;
              final bond = entry.value;
              final color = colors[i % colors.length];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(radius: 5, backgroundColor: color),
                            const SizedBox(width: 8),
                            Text(
                              bond.category,
                              style: TextStyle(
                                color: textDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${bond.percentage}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textDark,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              bond.formattedAmount,
                              style: TextStyle(color: textGrey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: bond.percentage / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // ── Recent Activities Card ────────────────────────────
  Widget _recentActivitiesCard(List<RecentActivity> activities) {
    final dotColors = {
      'investment': const Color(0xFF22C55E),
      'payout': const Color(0xFF3B82F6),
      'user': const Color(0xFF8B5CF6),
      'bond': const Color(0xFFF59E0B),
      'ticket': const Color(0xFF6B7280),
    };

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Latest platform activities',
            style: TextStyle(fontSize: 13, color: textGrey),
          ),
          const SizedBox(height: 20),
          if (activities.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No recent activity',
                  style: TextStyle(color: textGrey),
                ),
              ),
            )
          else
            ...activities.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: dotColors[a.type] ?? Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.activity,
                            style: TextStyle(
                              color: textDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            a.time,
                            style: TextStyle(color: textGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Today's Stats Card ────────────────────────────────
  Widget _todayStatsCard(TodayStats stats) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                "Today's Stats",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _statRow(
            icon: Icons.person_add_outlined,
            label: 'New Investors',
            value: stats.newInvestors,
            color: successGreen,
            bg: const Color(0xFFDCFCE7),
          ),
          _statRow(
            icon: Icons.trending_up,
            label: 'New Investments',
            value: stats.newInvestments,
            color: primaryBlue,
            bg: const Color(0xFFDBEAFE),
          ),
          _statRow(
            icon: Icons.check_circle_outline,
            label: 'Processed Payouts',
            value: stats.processedPayouts,
            color: Colors.orange,
            bg: const Color(0xFFFEF3C7),
          ),
          _statRow(
            icon: Icons.access_time_outlined,
            label: 'Pending KYC',
            value: stats.pendingKyc,
            color: Colors.purple,
            bg: const Color(0xFFF3E8FF),
          ),
          _statRow(
            icon: Icons.error_outline,
            label: 'Urgent Tickets',
            value: stats.urgentTickets,
            color: Colors.red,
            bg: const Color(0xFFFFE4E6),
          ),
        ],
      ),
    );
  }

  Widget _statRow({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
    required Color bg,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bg.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared card wrapper ───────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
