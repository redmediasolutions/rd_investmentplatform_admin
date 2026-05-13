// lib/pages/payout_requests/payout_requests_page.dart

import 'package:care_kapital_webapp_admin/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PayoutRequestsPage extends StatefulWidget {
  const PayoutRequestsPage({super.key});

  @override
  State<PayoutRequestsPage> createState() => _PayoutRequestsPageState();
}

class _PayoutRequestsPageState extends State<PayoutRequestsPage> {
  List _requests = [];
  Map<String, dynamic>? _summary;
  bool _loading = true;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getAdminPayoutRequests(
          status: _statusFilter);
      setState(() {
        _requests = data['requests'];
        _summary = data['summary'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _review(int id, String investorName) {
    final noteController = TextEditingController();
    String selectedAction = 'approved';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text('Review Request — $investorName',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Action',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _actionChip('Approve', 'approved', selectedAction,
                      const Color(0xFF059669), (v) {
                    setDialogState(() => selectedAction = v);
                  }),
                  const SizedBox(width: 12),
                  _actionChip('Reject', 'rejected', selectedAction,
                      Colors.red, (v) {
                    setDialogState(() => selectedAction = v);
                  }),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Note to investor (optional)',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Reason for approval/rejection...',
                  hintStyle:
                      const TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                context.pop();
                try {
                  await ApiService.reviewPayoutRequest(
                    id: id,
                    status: selectedAction,
                    adminNote: noteController.text.trim(),
                  );
                  await _fetch();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Request $selectedAction ✓'),
                        backgroundColor: selectedAction == 'approved'
                            ? const Color(0xFF059669)
                            : Colors.orange,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed: $e'),
                          backgroundColor: Colors.red),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedAction == 'approved'
                    ? const Color(0xFF059669)
                    : Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                selectedAction == 'approved' ? 'Approve' : 'Reject',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionChip(String label, String value, String selected,
      Color color, Function(String) onTap) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? color.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1),
        ),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Payout Requests',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827))),
                    const SizedBox(height: 4),
                    Text('Review and approve investor payout requests',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14)),
                  ],
                ),
                // Summary badges
                if (_summary != null)
                  Row(
                    children: [
                      _summaryBadge('${_summary!['pending']} Pending',
                          const Color(0xFF0D63D1),
                          const Color(0xFFEFF6FF)),
                      const SizedBox(width: 8),
                      _summaryBadge('${_summary!['approved']} Approved',
                          const Color(0xFF059669),
                          const Color(0xFFECFDF5)),
                      const SizedBox(width: 8),
                      _summaryBadge('${_summary!['rejected']} Rejected',
                          Colors.red,
                          const Color(0xFFFFE4E6)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                _filterTab('All', 'all'),
                const SizedBox(width: 8),
                _filterTab('Pending', 'pending'),
                const SizedBox(width: 8),
                _filterTab('Approved', 'approved'),
                const SizedBox(width: 8),
                _filterTab('Rejected', 'rejected'),
              ],
            ),
          ),

          // List
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF0D63D1)))
                : _requests.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64,
                                color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            const Text('No requests found',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: _requests.length,
                        itemBuilder: (context, index) {
                          return _requestCard(_requests[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _requestCard(Map request) {
    final isPending = request['status'] == 'pending';
    final isApproved = request['status'] == 'approved';
    final statusColor = isApproved
        ? const Color(0xFF059669)
        : isPending
            ? const Color(0xFF0D63D1)
            : Colors.red;
    final statusBg = isApproved
        ? const Color(0xFFECFDF5)
        : isPending
            ? const Color(0xFFEFF6FF)
            : const Color(0xFFFFE4E6);

    final amount = double.tryParse(request['amount'].toString()) ?? 0;
    final formatted =
        '₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                    width: 6, color: statusColor)),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Initials
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _initials(request['investor_name'] ?? ''),
                          style: const TextStyle(
                              color: Color(0xFF0D63D1),
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request['investor_name'] ?? '',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827)),
                            ),
                            Text(request['investor_email'] ?? '',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          request['status'].toString().toUpperCase(),
                          style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _infoCol('Bond', request['bond_name'] ?? ''),
                      const SizedBox(width: 32),
                      _infoCol('Amount', formatted,
                          color: const Color(0xFF059669)),
                      const SizedBox(width: 32),
                      _infoCol('Requested',
                          request['requested_at'] ?? ''),
                    ],
                  ),
                  if (request['reason'] != null &&
                      request['reason'].toString().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Reason: ${request['reason']}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280))),
                  ],
                  if (request['admin_note'] != null &&
                      request['admin_note'].toString().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Note: ${request['admin_note']}',
                        style: TextStyle(
                            fontSize: 13,
                            color: statusColor,
                            fontWeight: FontWeight.w500)),
                  ],
                  if (isPending) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _review(
                              request['id'] is int
                                  ? request['id']
                                  : int.parse(
                                      request['id'].toString()),
                              request['investor_name'] ?? ''),
                          icon: const Icon(Icons.rate_review_outlined,
                              size: 16),
                          label: const Text('Review'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D63D1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterTab(String label, String value) {
    final active = _statusFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _statusFilter = value);
        _fetch();
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF0D63D1)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color:
                    active ? Colors.white : const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }

  Widget _summaryBadge(String text, Color color, Color bg) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(text,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12)),
    );
  }

  Widget _infoCol(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color ?? const Color(0xFF1F2937))),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}