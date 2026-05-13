import 'package:care_kapital_webapp_admin/components/investor_kpiboxes.dart';
import 'package:care_kapital_webapp_admin/pages/Investors/create_investor_dialog.dart';
import 'package:care_kapital_webapp_admin/pages/Investors/investor_controller.dart';
import 'package:care_kapital_webapp_admin/pages/Investors/userprofilecard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Investors extends StatefulWidget {
  const Investors({super.key});

  @override
  State<Investors> createState() => _InvestorsState();
}

class _InvestorsState extends State<Investors> {
  final InvestorController _controller = InvestorController();
  final String _selectedStatus = 'all';

  @override

  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.fetchInvestors();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleStatusChange(int id, String currentStatus) {
    final newStatus = currentStatus == 'active' ? 'inactive' : 'active';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '${newStatus == 'active' ? 'Activate' : 'Deactivate'} Investor',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Confirm change for investor ID #$id. They will ${newStatus == 'active' ? 'regain' : 'lose'} access to the platform.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop();
              await _controller.updateStatus(id, newStatus);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Status updated to $newStatus'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: newStatus == 'active' ? const Color(0xFF059669) : Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == 'active' ? const Color(0xFF059669) : Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              newStatus == 'active' ? 'Activate' : 'Deactivate',
              style: const TextStyle(color: Colors.white),
            ),
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
              const Text('Investor Directory',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827))),
              const SizedBox(height: 4),
              Text(
                'Manage accounts, verification, and investment portfolios',
                style:
                    TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
          // ← ADD INVESTOR BUTTON
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => CreateInvestorDialog(
                  onCreate: ({
                    required String name,
                    required String email,
                    required String password,
                    String? phone,
                  }) async {
                    await _controller.createInvestor(
                      name: name,
                      email: email,
                      password: password,
                      phone: phone,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.person_add_rounded, size: 18),
            label: const Text('Add Investor',
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D63D1),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    ),
  ),
),
      body: _controller.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D63D1)))
          : _controller.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(_controller.error!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: _controller.fetchInvestors,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Modern KPI Row
                        Row(
                          children: [
                            Expanded(
                              child: InvestorKpiboxes(
                                title: 'Total Registry',
                                value: '${summary?.total ?? 0}',
                                textcolor: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InvestorKpiboxes(
                                title: 'Verified Active',
                                value: '${summary?.active ?? 0}',
                                textcolor: const Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InvestorKpiboxes(
                                title: 'Pending/Inactive',
                                value: '${summary?.inactive ?? 0}',
                                textcolor: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Search + Filter Bar
                        /*Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SearchbarWidget(onChanged: _controller.search),
                              ),
                              const SizedBox(width: 24),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonFormField<String>(
                                  initialValue: _selectedStatus,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'all', child: Text('All Status')),
                                    DropdownMenuItem(value: 'active', child: Text('Active')),
                                    DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                                    DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                                  ],
                                  onChanged: (v) {
                                    setState(() => _selectedStatus = v!);
                                    _controller.filterByStatus(v!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),*/
                        const SizedBox(height: 24),

                        // Investor List
                        if (_controller.filteredInvestors.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(60),
                            child: Column(
                              children: [
                                Icon(Icons.person_search_rounded, size: 64, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                const Text('No investors match your current filters.',
                                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _controller.filteredInvestors.length,
                            itemBuilder: (context, index) {
                              final investor = _controller.filteredInvestors[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: UserProfileCard(
                                  investor: investor,
                                  onStatusChange: () => _handleStatusChange(investor.id, investor.status),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }
}