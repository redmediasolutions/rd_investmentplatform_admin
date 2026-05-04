import 'package:care_kapital_webapp_admin/pages/Investors/investors_models.dart';
import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final InvestorModel investor;
  final VoidCallback? onStatusChange;

  const UserProfileCard({
    super.key,
    required this.investor,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D63D1);
    const Color textDark = Color(0xFF111827);
    const Color textGrey = Color(0xFF6B7280);

    final statusStyle = _statusStyle(investor.status);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Status Side Accent
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 6, color: statusStyle['text']),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Identity Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Styled Avatar
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryBlue.withOpacity(0.1),
                              primaryBlue.withOpacity(0.05)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: primaryBlue.withOpacity(0.1)),
                        ),
                        child: Center(
                          child: Text(
                            investor.initials,
                            style: const TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w900,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Name and Contacts
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  investor.name.isNotEmpty
                                      ? investor.name
                                      : investor.email.split('@')[0],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: textDark),
                                ),
                                const SizedBox(width: 12),
                                _badge(investor.status, statusStyle['bg']!,
                                    statusStyle['text']!),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 20,
                              runSpacing: 8,
                              children: [
                                _contactItem(
                                    Icons.mail_outline_rounded, investor.email),
                                if (investor.phone != null)
                                  _contactItem(Icons.phone_iphone_rounded,
                                      investor.phone!),
                                _contactItem(Icons.calendar_today_rounded,
                                    'Joined ${investor.joined}'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Action Buttons
                      _statusToggleButton(investor.status),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                  ),

                  // Financial Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _statBlock('Net Invested', investor.formattedInvested,
                          isPrimary: true),
                      const SizedBox(width: 60),
                      _statBlock('Active Bonds',
                          '${investor.totalInvestments} Holdings'),
                      const SizedBox(width: 60),
                      _statBlock('Portfolio Yield', '12.4% avg.',
                          color: const Color(0xFF059669)),
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

  Widget _contactItem(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      );

  Widget _statBlock(String label, String value,
          {bool isPrimary = false, Color? color}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isPrimary
                  ? const Color(0xFF0D63D1)
                  : (color ?? const Color(0xFF1F2937)),
            ),
          ),
        ],
      );

  Widget _statusToggleButton(String status) {
    final isActive = status == 'active';
    final color = isActive ? Colors.orange : const Color(0xFF059669);
    return OutlinedButton.icon(
      onPressed: onStatusChange,
      icon: Icon(
          isActive
              ? Icons.power_settings_new_rounded
              : Icons.verified_user_rounded,
          size: 16),
      label: Text(isActive ? 'Deactivate' : 'Activate',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _badge(String text, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.1))),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5),
      ),
    );
  }

  Map<String, Color> _statusStyle(String status) {
    switch (status) {
      case 'active':
        return {'bg': const Color(0xFFECFDF5), 'text': const Color(0xFF059669)};
      case 'inactive':
        return {'bg': const Color(0xFFF9FAFB), 'text': const Color(0xFF6B7280)};
      case 'suspended':
        return {'bg': const Color(0xFFFEF2F2), 'text': const Color(0xFFDC2626)};
      default:
        return {'bg': const Color(0xFFF9FAFB), 'text': const Color(0xFF6B7280)};
    }
  }
}