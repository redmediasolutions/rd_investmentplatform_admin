import 'package:flutter/material.dart';

class KycDropdown extends StatelessWidget {
  const KycDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    const Color greyBg = Color(0xFFF3F4F6);
    const Color textGrey = Color(0xFF6B7280);
    const Color borderColor = Color(0xFFE5E7EB);
    return  Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: greyBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'All KYC',
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                isExpanded: true,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                // This mimics the leading filter icon in your image
                hint: Row(
                  children: const [
                    Icon(Icons.filter_list, size: 18, color: textGrey),
                    SizedBox(width: 8),
                    Text('All Status'),
                  ],
                ),
                onChanged: (String? newValue) {},
                items: <String>['All KYC', 'Verify', 'Pending', 'Rejected']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value),
                        if (value == 'All Status')
                          const Icon(Icons.check, size: 16, color: Colors.grey),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        
  }
}