import 'package:flutter/material.dart';

class PayoutsUserprofile extends StatefulWidget {
  const PayoutsUserprofile({super.key});

  @override
  State<PayoutsUserprofile> createState() => _PayoutsUserprofileState();
}

class _PayoutsUserprofileState extends State<PayoutsUserprofile> {
  // 1. Track the state of the card
  bool isProcessed = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D63D1);
    const Color bgBlue = Color(0xFFE7F0FF);
    const Color textDark = Color(0xFF1F2937);
    const Color textGrey = Color(0xFF6B7280);
    const Color successGreen = Color(0xFF22C55E);
    const Color successBg = Color(0xFFDCFCE7);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. Dynamic Avatar/Icon based on state
          CircleAvatar(
            radius: 28,
            backgroundColor: isProcessed ? successBg : bgBlue,
            child: isProcessed
                ? const Icon(Icons.check, color: successGreen, size: 28)
                : const Text(
                    'RK',
                    style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
          ),
          const SizedBox(width: 16),
          // Name and Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Rajesh Kumar',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
                    ),
                    const SizedBox(width: 12),
                    // 3. Toggle Badge Text and Color
                    _buildStatusBadge(
                      isProcessed ? 'Completed' : 'Scheduled',
                      isProcessed ? successBg : bgBlue,
                      isProcessed ? successGreen : primaryBlue,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Government Bond Series A', style: TextStyle(fontSize: 15, color: textGrey)),
                const SizedBox(height: 20),
                // 4. Grid-style metrics row
                Row(
                  children: [
                    _buildMetric('Amount', '₹9,375', valueColor: successGreen),
                    const SizedBox(width: 40),
                    _buildMetric('Due Date', '15 Apr'),
                    const SizedBox(width: 40),
                    // Only show these if processed
                    if (isProcessed) ...[
                      _buildMetric('Transaction Ref', 'TXN1774959076676'),
                      const SizedBox(width: 40),
                      _buildMetric('Processed Date', '31 Mar'),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // 5. Toggle Button based on state
          isProcessed
              ? const SizedBox.shrink() // Hide button if processed
              : ElevatedButton.icon(
                  onPressed: () {
                    // 6. Change the state on click
                    setState(() {
                      isProcessed = true;
                    });
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 20, color: Colors.white),
                  label: const Text('Process Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052FE),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
        ],
      ),
    );
  }

  // Helper for Metric Columns (Amount, Due Date, etc.)
  Widget _buildMetric(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}