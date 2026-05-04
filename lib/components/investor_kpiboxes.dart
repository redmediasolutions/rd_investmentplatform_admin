import 'package:flutter/material.dart';

class InvestorKpiboxes extends StatelessWidget {
  final String title;
  final String value;
  final Color textcolor;
  const InvestorKpiboxes({super.key, 
  required this.title, 
  required this.value, required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color:textcolor,
            
            fontWeight: FontWeight.w700
          ),),
          Text(
            title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
           color: Colors.grey.shade700,
           fontSize: 15
          ),)

        ],
      ),

    );
  }
}