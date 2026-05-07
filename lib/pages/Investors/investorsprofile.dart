import 'package:flutter/material.dart';
import 'package:care_kapital_webapp_admin/services/api_service.dart';

class InvestorPortfolioPage extends StatefulWidget {
  final dynamic investor;

  const InvestorPortfolioPage({
    super.key,
    required this.investor,
  });

  @override
  State<InvestorPortfolioPage> createState() =>
      _InvestorPortfolioPageState();
}

class _InvestorPortfolioPageState
    extends State<InvestorPortfolioPage> {
  List investments = [];

  bool isLoading = true;

  double totalInvested = 0;
  double activeInvested = 0;

  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    fetchInvestments();
  }

  // ========================= FETCH =========================

  Future<void> fetchInvestments() async {
    setState(() => isLoading = true);

    try {
      final data =
          await ApiService.getInvestorBondInvestments(
        widget.investor.id,
      );

      final list = List<Map<String, dynamic>>.from(
        data['investments'] ?? [],
      );

      double total = 0;
      double active = 0;

      for (final inv in list) {
        final amount = double.tryParse(
              inv['investment_amount'].toString(),
            ) ??
            0;

        total += amount;

        if (inv['status'] == 'active') {
          active += amount;
        }
      }

      if (!mounted) return;

      setState(() {
        investments = list;
        totalInvested = total;
        activeInvested = active;
        totalCount = list.length;
      });
    } catch (e) {
      debugPrint(e.toString());

      _showError(
        'Failed to load investor investments',
      );
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // ========================= HELPERS =========================

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  String formatAmount(double value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(2)}Cr';
    }

    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(2)}L';
    }

    return '₹${value.toStringAsFixed(0)}';
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;

    return s[0].toUpperCase() + s.substring(1);
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    final investor = widget.investor;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              investor.name?.toString().isNotEmpty == true
                  ? investor.name
                  : investor.email,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              investor.email ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchInvestments,
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _summaryCards(),

                      const SizedBox(height: 24),

                      _investmentList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ================= SUMMARY =================

  Widget _summaryCards() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            title: 'Total Invested',
            value: formatAmount(totalInvested),
            color: const Color(0xFF0D63D1),
            icon: Icons.account_balance_wallet_outlined,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _summaryCard(
            title: 'Active Investments',
            value: formatAmount(activeInvested),
            color: const Color(0xFF059669),
            icon: Icons.trending_up_rounded,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _summaryCard(
            title: 'Total Bonds',
            value: totalCount.toString(),
            color: Colors.orange,
            icon: Icons.description_outlined,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 18),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ================= INVESTMENT LIST =================

  Widget _investmentList() {
    if (investments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(60),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'No investments found',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: investments.length,
      itemBuilder: (context, index) {
        final inv = investments[index];

        final isActive =
            inv['status'].toString() == 'active';

        final amount = double.tryParse(
              inv['investment_amount'].toString(),
            ) ??
            0;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
              ),
            ],
          ),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              // LEFT
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      inv['bond_name'] ?? 'Bond',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.business,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          inv['issuer'] ?? '-',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 20,
                      runSpacing: 12,
                      children: [
                        _metaItem(
                          'Interest',
                          '${inv['interest_rate']}%',
                        ),
                        _metaItem(
                          'Payout',
                          capitalize(
                            inv['payout_frequency']
                                    ?.toString() ??
                                '-',
                          ),
                        ),
                        _metaItem(
                          'Start Date',
                          inv['start_date']
                                  ?.toString() ??
                              '-',
                        ),
                        _metaItem(
                          'Maturity',
                          inv['maturity_date']
                                  ?.toString() ??
                              '-',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // RIGHT
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    formatAmount(amount),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFF3F4F6),
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: Text(
                      capitalize(
                        inv['status']
                                ?.toString() ??
                            '',
                      ),
                      style: TextStyle(
                        color: isActive
                            ? const Color(0xFF059669)
                            : const Color(0xFF6B7280),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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

  Widget _metaItem(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}