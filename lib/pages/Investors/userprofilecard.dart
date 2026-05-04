import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

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
      child: Column(
        children: [
          // --- Top Row: Avatar, Name, Badges, and Action Button ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: bgBlue,
                child: const Text(
                  'RK',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Name and Contact Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Rajesh Kumar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildStatusBadge('active', successBg, successGreen),
                        const SizedBox(width: 8),
                        _buildStatusBadge('KYC: verified', successBg, successGreen),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 16, color: textGrey),
                        const SizedBox(width: 4),
                        const Text('rajesh.kumar@email.com', style: TextStyle(color: textGrey)),
                        const SizedBox(width: 16),
                        const Icon(Icons.phone_outlined, size: 16, color: textGrey),
                        const SizedBox(width: 4),
                        const Text('+91 98765 43210', style: TextStyle(color: textGrey)),
                      ],
                    ),
                  ],
                ),
              ),
              // View Details Button
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: const Text('View Details'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textDark,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // --- Bottom Row: Stats/Metrics ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Total Investment', '₹28.0L', primaryBlue),
              _buildStatItem('Active Investments', '5', textDark),
              _buildStatItem('Joined', 'Jan 2023', textDark),
              _buildStatItem('Last Active', '30 Mar', textDark),
              const SizedBox(width: 120), // Placeholder to balance the button above
            ],
          ),
        ],
      ),
    );
  }

  // Badge Helper
  Widget _buildStatusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Stat Item Helper
  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}