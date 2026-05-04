
import 'package:care_kapital_webapp_admin/sidenavbar.dart';
import 'package:flutter/material.dart';



class ShellPage extends StatelessWidget {
  final Widget child;
  final Widget? secondarySidebar;

  const ShellPage({
    super.key,
    required this.child,
    this.secondarySidebar,
  });

  @override
  Widget build(BuildContext context) {
     

    return Scaffold(
      
      backgroundColor: const Color(0xFFF5F5F7),
      body: Row(
        children: [
          // Primary sidebar (ONCE)
         
         
           const SizedBox(
            width: 300,
            child: Sidenavbar(),
          ),

          // Secondary sidebar (optional)
          if (secondarySidebar != null)
            Container(
              width: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: secondarySidebar,
            ),

          Expanded(child: child),
        ],
      ),
    );
  }
}