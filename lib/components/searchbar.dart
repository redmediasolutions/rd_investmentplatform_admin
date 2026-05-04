import 'package:flutter/material.dart';

class SearchbarWidget extends StatelessWidget {
  const SearchbarWidget({super.key, required void Function(String query) onChanged});

  @override
  Widget build(BuildContext context) {
   const Color inputBg = Color(0xFFF8F9FA); 
    const Color borderGrey = Color(0xFFD1D5DB);
    const Color hintTextGrey = Color(0xFF9CA3AF);
   return Container(
      height: 48,
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(10), // Slightly rounder corners
        border: Border.all(
          color: borderGrey, 
          width: 1.5, // Noticeable but thin border from your image
        ),
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search bonds...',
          hintStyle: const TextStyle(
            color: hintTextGrey, 
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_outlined, 
            color: hintTextGrey, 
            size: 22,
          ),
          
          border: InputBorder.none,
          // Eliminates the default material padding to center text perfectly
          contentPadding: EdgeInsets.zero, 
        ),
      ),
    );
  }
}