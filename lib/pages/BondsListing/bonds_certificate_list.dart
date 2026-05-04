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
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);
    const Color primaryBlue = Color(0xFF0D63D1);

    // Status Styling logic
    final statusColor = bond.status == 'active' ? const Color(0xFF059669) : const Color(0xFFD1D5DB);
    final statusBg = bond.status == 'active' ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB);

    String _fmt(double amount) {
      if (amount >= 10000000) return '₹${(amount / 10000000).toStringAsFixed(1)} Cr';
      if (amount >= 100000) return '₹${(amount / 100000).toStringAsFixed(1)} L';
      return '₹${amount.toStringAsFixed(0)}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Side Accent
            Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 6, color: statusColor)),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar/Icon
                      Container(
                        height: 56, width: 56,
                        decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.account_balance_wallet_rounded, color: primaryBlue, size: 28),
                      ),
                      const SizedBox(width: 20),
                      
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(bond.bondName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textDark)),
                                const SizedBox(width: 12),
                                _tag(bond.status.toUpperCase(), statusBg, statusColor),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Issuer: ${bond.issuer}', style: const TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      
                      // Actions
                      Row(
                        children: [
                          _iconBtn(Icons.edit_note_rounded, Colors.black87, onEdit),
                          const SizedBox(width: 8),
                          _iconBtn(Icons.delete_sweep_rounded, Colors.redAccent, onDelete),
                        ],
                      ),
                    ],
                  ),
                  
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(height: 1, color: Color(0xFFF3F4F6))),
                  
                  // Stats Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _stat('Return', '${bond.interestRate}%', isHighlight: true),
                      _stat('Min. Investment', _fmt(bond.minInvestment)),
                      _stat('Duration', '${bond.maturityPeriod}m'),
                      _stat('Risk Profile', bond.riskLevel.toUpperCase(), 
                          color: bond.riskLevel == 'high' ? Colors.orange : primaryBlue),
                      _stat('Listing Date', bond.listingDate),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color bg, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.1))),
        child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      );

  Widget _stat(String label, String value, {bool isHighlight = false, Color? color}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isHighlight ? const Color(0xFF059669) : (color ?? const Color(0xFF1F2937)),
            ),
          ),
        ],
      );

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      );
}