import 'package:care_kapital_webapp_admin/pages/BondsListing/bondlisting_models.dart';
import 'package:flutter/material.dart';


class BondProjectCard extends StatelessWidget {
  final BondModel bond;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BondProjectCard({
    super.key,
    required this.bond,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const Color textDark = Color(0xFF1F2937);
    const Color textGrey = Color(0xFF6B7280);
    const Color successGreen = Color(0xFF22C55E);
    const Color primaryBlue = Color(0xFF0D63D1);

    final statusColor = bond.status == 'active' ? successGreen : Colors.grey;
    final statusBg = bond.status == 'active'
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFF3F4F6);

    final riskColor = bond.riskLevel == 'low'
        ? const Color(0xFF0369A1)
        : bond.riskLevel == 'medium'
            ? const Color(0xFFB45309)
            : Colors.red;
    final riskBg = bond.riskLevel == 'low'
        ? const Color(0xFFE0F2FE)
        : bond.riskLevel == 'medium'
            ? const Color(0xFFFEF3C7)
            : const Color(0xFFFFE4E6);

    String _fmt(double amount) {
      if (amount >= 10000000) return '₹${(amount / 10000000).toStringAsFixed(1)}Cr';
      if (amount >= 100000) return '₹${(amount / 100000).toStringAsFixed(1)}L';
      return '₹${amount.toStringAsFixed(0)}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bond.bondName,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textDark),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _tag(bond.status[0].toUpperCase() + bond.status.substring(1),
                            statusBg, statusColor),
                        const SizedBox(width: 8),
                        _tag('${bond.riskLevel.toUpperCase()} Risk', riskBg,
                            riskColor),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(bond.issuer,
                        style: const TextStyle(color: textGrey, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action buttons
              Column(
                children: [
                  _actionBtn(Icons.visibility_outlined, 'View', textDark,
                      onTap: () {}),
                  const SizedBox(height: 8),
                  _actionBtn(Icons.edit_outlined, 'Edit', textDark,
                      onTap: onEdit),
                  const SizedBox(height: 8),
                  _actionBtn(Icons.delete_outline, '', Colors.red,
                      isDelete: true, onTap: onDelete),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // KPI row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _kpi('Interest Rate', '${bond.interestRate}% p.a.', successGreen),
              _kpi('Min Investment', _fmt(bond.minInvestment), textDark),
              _kpi('Maturity', '${bond.maturityPeriod} months', textDark),
              _kpi('Available', _fmt(bond.availableAmount), textDark),
              const SizedBox(width: 60),
            ],
          ),
          const SizedBox(height: 16),

          // Footer
          Row(
            children: [
              _iconDetail(Icons.calendar_today_outlined,
                  'Listed: ${bond.listingDate}'),
              const SizedBox(width: 16),
              if (bond.closingDate != null)
                _iconDetail(Icons.calendar_month_outlined,
                    'Closes: ${bond.closingDate}'),
              const SizedBox(width: 16),
              _iconDetail(Icons.trending_up,
                  '${bond.payoutFrequency[0].toUpperCase()}${bond.payoutFrequency.substring(1)} payouts'),
            ],
          ),
          const SizedBox(height: 20),

          // Progress bar
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         const Text('Issue Progress',
          //             style: TextStyle(
          //                 color: textGrey,
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w500)),
          //         Text('${(bond.progressPercent * 100).toStringAsFixed(1)}%',
          //             style: const TextStyle(
          //                 color: textDark,
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.bold)),
          //       ],
          //     ),
          //     const SizedBox(height: 8),
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(4),
          //       child: LinearProgressIndicator(
          //         value: bond.progressPercent,
          //         minHeight: 8,
          //         backgroundColor: Colors.grey.shade200,
          //         valueColor:
          //             const AlwaysStoppedAnimation<Color>(primaryBlue),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color bg, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      );

  Widget _kpi(String label, String value, Color valueColor) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: valueColor)),
        ],
      );

  Widget _iconDetail(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF6B7280)),
          const SizedBox(width: 4),
          Text(text,
              style:
                  const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
        ],
      );

  Widget _actionBtn(IconData icon, String label, Color color,
      {bool isDelete = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isDelete ? 60 : 85,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ],
          ],
        ),
      ),
    );
  }
}