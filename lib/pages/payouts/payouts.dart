
import 'package:care_kapital_webapp_admin/components/payoutkpiboxes.dart';
import 'package:care_kapital_webapp_admin/components/searchbar.dart';
import 'package:care_kapital_webapp_admin/pages/payouts/payouts_controller.dart';
import 'package:care_kapital_webapp_admin/pages/payouts/payouts_userprofile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Payouts extends StatefulWidget {
  const Payouts({super.key});

  @override
  State<Payouts> createState() => _PayoutsState();
}

class _PayoutsState extends State<Payouts> {
  final AdminPayoutController _controller = AdminPayoutController();
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() { if (mounted) setState(() {}); });
    _controller.fetchPayouts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmProcess(int id, String investorName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Payment', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('You are about to authorize the payout for $investorName. This will update the investor ledger immediately.'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Go Back', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              context.pop();
              try {
                await _controller.processPayout(id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment authorized successfully ✓'), behavior: SnackBarBehavior.floating, backgroundColor: Color(0xFF059669)),
                  );
                }
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Authorization Failed: $e'), backgroundColor: Colors.redAccent));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D63D1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Confirm & Process', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmProcessAll() {
    final count = _controller.summary?.scheduledCount ?? 0;
    if (count == 0) return;
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Bulk Process Authorization'),
        content: Text('Are you sure you want to process ALL $count scheduled payouts? This action will generate multiple bank transaction requests.'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              context.pop();
              await _controller.processAll();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D63D1)),
            child: const Text('Authorize Bulk Payment', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = _controller.summary;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Payout Ledger', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                    const SizedBox(height: 4),
                    Text('Track distributions and settlement status for all active bonds', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _controller.processing ? null : _confirmProcessAll,
                  icon: _controller.processing 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.bolt_rounded, size: 18),
                  label: const Text('Authorize All Scheduled'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D63D1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _controller.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D63D1)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // High-Contrast KPI Row
                  Row(
                    children: [
                      Expanded(
                        child: Payoutkpiboxes(
                          value: '${summary?.scheduledCount ?? 0}',
                          title: 'Scheduled',
                          subtitle: summary?.formattedScheduledAmount ?? '₹0',
                          icon: Icons.pending_actions_rounded,
                          iconcolor: const Color(0xFF0D63D1),
                          valueColor: const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Payoutkpiboxes(
                          value: '${summary?.completedCount ?? 0}',
                          title: 'Settled',
                          subtitle: 'Cleared this cycle',
                          icon: Icons.check_circle_rounded,
                          iconcolor: const Color(0xFF059669),
                          valueColor: const Color(0xFF059669),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Payoutkpiboxes(
                          value: '${summary?.totalCount ?? 0}',
                          title: 'Total Volume',
                          subtitle: 'Full history',
                          icon: Icons.analytics_rounded,
                          iconcolor: Colors.orange.shade700,
                          valueColor: const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Filter & Utility Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
                    ),
                    child: Row(
                      children: [
                        Expanded(child: SearchbarWidget(onChanged: _controller.search)),
                        const SizedBox(width: 20),
                        Container(
                          width: 180,
                          decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                            items: const [
                              DropdownMenuItem(value: 'all', child: Text('All Types')),
                              DropdownMenuItem(value: 'upcoming', child: Text('Scheduled')),
                              DropdownMenuItem(value: 'paid', child: Text('Completed')),
                            ],
                            onChanged: (v) {
                              setState(() => _selectedStatus = v!);
                              _controller.filterByStatus(v!);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filledTonal(
                          onPressed: () {},
                          icon: const Icon(Icons.file_download_outlined),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            foregroundColor: const Color(0xFF111827),
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // List Render
                  if (_controller.filteredPayouts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80),
                      child: Column(
                        children: [
                          Icon(Icons.history_edu_rounded, size: 64, color: Color(0xFFE5E7EB)),
                          SizedBox(height: 16),
                          Text('No payout records found for this period.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _controller.filteredPayouts.length,
                      itemBuilder: (context, index) {
                        return PayoutsUserprofile(
                          payout: _controller.filteredPayouts[index],
                          onProcess: () => _confirmProcess(_controller.filteredPayouts[index].id, _controller.filteredPayouts[index].investorName),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}