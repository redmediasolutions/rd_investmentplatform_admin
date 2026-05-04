import 'package:care_kapital_webapp_admin/Theme/apptheme.dart';
import 'package:care_kapital_webapp_admin/components/investor_kpiboxes.dart';
import 'package:care_kapital_webapp_admin/components/kyc_dropdown.dart';
import 'package:care_kapital_webapp_admin/components/searchbar.dart';
import 'package:care_kapital_webapp_admin/components/status_dropdown.dart';
import 'package:care_kapital_webapp_admin/pages/Investors/userprofilecard.dart';
import 'package:flutter/material.dart';

class Investors extends StatefulWidget {
  const Investors({super.key});

  @override
  State<Investors> createState() => _InvestorsState();
}

class _InvestorsState extends State<Investors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: backgroundLight,
        elevation: 0,
        toolbarHeight: 90,
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investor Management',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'View and manage all registered investors',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: textGrey),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    flex: 1,
                    child: InvestorKpiboxes(
                      title: 'Total Investors',
                      value: '6',
                      textcolor: textDark,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InvestorKpiboxes(
                      title: 'Active',
                      value: '5',
                      textcolor: successGreen,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InvestorKpiboxes(
                      title: 'KYC Verified',
                      value: '5',
                      textcolor: primaryBlue,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InvestorKpiboxes(
                      title: 'Pending KYC',
                      value: '1',
                      textcolor: containerOrange,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  // Optional: Add a subtle shadow to match the card style
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 500, child: SearchbarWidget(onChanged: (String query) {  },)),

                    const SizedBox(width: 16),
                    Spacer(),
                    const SizedBox(width: 200, child: StatusDropdown()),
                    const SizedBox(width: 10),
                    const SizedBox(width: 200, child: KycDropdown()),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: (UserProfileCard()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
