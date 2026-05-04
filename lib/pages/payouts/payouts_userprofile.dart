import 'package:care_kapital_webapp_admin/pages/payouts/payouts_model.dart';
import 'package:flutter/material.dart';

class PayoutsUserprofile extends StatelessWidget {
  final AdminPayoutModel payout;
  final VoidCallback onProcess;

  const PayoutsUserprofile({
    super.key,
    required this.payout,
    required this.onProcess,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D63D1);
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);
    const Color successGreen = Color(0xFF059669);
    const Color successBg = Color(0xFFECFDF5);

    final isPaid = payout.isPaid;
    final statusColor = isPaid ? successGreen : primaryBlue;
    final statusBg = isPaid ? successBg : const Color(0xFFEFF6FF);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Status Side Ribbon
            Positioned(
              left: 0, top: 0, bottom: 0,
              child: Container(width: 6, color: statusColor),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with Status Icon overlay
                      Stack(
                        children: [
                          Container(
                            height: 60, width: 60,
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: isPaid 
                                ? Icon(Icons.check_circle_rounded, color: successGreen, size: 30)
                                : Text(payout.initials, style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),

                      // Investor & Bond Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  payout.investorName.isNotEmpty ? payout.investorName : payout.investorEmail.split('@')[0],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textDark),
                                ),
                                const SizedBox(width: 12),
                                _badge(isPaid ? 'COMPLETED' : 'SCHEDULED', statusBg, statusColor),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.account_balance_wallet_outlined, size: 14, color: textGrey.withOpacity(0.7)),
                                const SizedBox(width: 6),
                                Text(payout.bondName, style: const TextStyle(fontSize: 14, color: textGrey, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(payout.investorEmail, style: TextStyle(fontSize: 12, color: textGrey.withOpacity(0.6))),
                          ],
                        ),
                      ),

                      // Amount & Primary Action
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Payout Amount', style: TextStyle(color: textGrey.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          const SizedBox(height: 4),
                          Text(payout.formattedAmount, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: successGreen)),
                          const SizedBox(height: 12),
                          if (!isPaid)
                            ElevatedButton(
                              onPressed: onProcess,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1F2937),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              ),
                              child: const Text('Process Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(height: 1, color: Color(0xFFF3F4F6))),

                  // Timeline / Metadata Metrics
                  Row(
                    children: [
                      _timelineInfo('Expected Due', payout.dueDate, Icons.calendar_today_rounded),
                      if (isPaid && payout.paidDate != null) ...[
                        const SizedBox(width: 40),
                        _timelineInfo('Actual Settlement', payout.paidDate!, Icons.verified_rounded, color: successGreen),
                      ],
                      if (isPaid && payout.reference != null) ...[
                        const SizedBox(width: 40),
                        _timelineInfo('TXN Reference', payout.reference!, Icons.receipt_long_rounded),
                      ],
                      const Spacer(),
                      if (isPaid)
                        _actionIconButton(Icons.download_rounded, 'Receipt', () {}),
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

  Widget _timelineInfo(String label, String value, IconData icon, {Color? color}) => Row(
    children: [
      Icon(icon, size: 16, color: color ?? Colors.grey.shade400),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color ?? const Color(0xFF1F2937))),
        ],
      ),
    ],
  );

  Widget _actionIconButton(IconData icon, String label, VoidCallback onTap) => TextButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    label: Text(label),
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF0D63D1),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
    ),
  );

  Widget _badge(String text, Color bg, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.1))),
    child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
  );
}