import 'package:flutter/material.dart';

class Payoutkpiboxes extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle; // Added for "This month", "Needs attention", etc.
  final IconData icon;
  final Color iconcolor;
  final Color valueColor;

  const Payoutkpiboxes({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconcolor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200), // Added subtle border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Text Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF374151), // Darker grey
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            // Right Side: Icon
            Icon(
              icon,
              size: 32,
              color: iconcolor,
            ),
          ],
        ),
      ),
    );
  }
}