import 'package:flutter/material.dart';
import 'package:care_kapital_webapp_admin/services/api_service.dart';

class InvestorPortfolioPage extends StatefulWidget {
  final dynamic investor;

  const InvestorPortfolioPage({super.key, required this.investor});

  @override
  State<InvestorPortfolioPage> createState() =>
      _InvestorPortfolioPageState();
}

class _InvestorPortfolioPageState
    extends State<InvestorPortfolioPage> {
  List investments = [];
  bool isLoading = true;

  double totalInvested = 0;
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
      final data = await ApiService.getInvestorBondInvestments(
        widget.investor.id,
      );

      final list = data['investments'] as List;

      double total = 0;
      for (var inv in list) {
        total += double.parse(inv['investment_amount'].toString());
      }

      setState(() {
        investments = list;
        totalInvested = total;
        totalCount = list.length;
      });
    } catch (e) {
      _showError('Failed to load investments');
      debugPrint(e.toString());
    }

    setState(() => isLoading = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.investor.name),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchInvestments,
              child: Column(
                children: [
                  _header(),
                  Expanded(child: _list()),
                ],
              ),
            ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TOTAL INVESTED
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Invested",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "₹${totalInvested.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          // COUNT
          Column(
            children: [
              const Text(
                "Bonds",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                totalCount.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ================= LIST =================

  Widget _list() {
    if (investments.isEmpty) {
      return const Center(
        child: Text(
          'No bonds assigned',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: investments.length,
      itemBuilder: (context, index) {
        final inv = investments[index];

        final isActive = inv['status'] == 'active';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inv['bond_name'] ?? 'Bond',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),

                  if (inv['issuer'] != null)
                    Text(
                      inv['issuer'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                  const SizedBox(height: 6),

                  Text(
                    "Start: ${inv['start_date'] ?? '-'}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              // RIGHT SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${inv['investment_amount']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      inv['status'].toUpperCase(),
                      style: TextStyle(
                        color: isActive
                            ? const Color(0xFF059669)
                            : const Color(0xFF6B7280),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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
}