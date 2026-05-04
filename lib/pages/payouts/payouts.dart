import 'package:care_kapital_webapp_admin/Theme/apptheme.dart';
import 'package:care_kapital_webapp_admin/components/payoutkpiboxes.dart';
import 'package:care_kapital_webapp_admin/components/searchbar.dart';
import 'package:care_kapital_webapp_admin/components/status_dropdown.dart';
import 'package:care_kapital_webapp_admin/pages/payouts/payouts_userprofile.dart';
import 'package:flutter/material.dart';

class Payouts extends StatefulWidget {
  const Payouts({super.key});

  @override
  State<Payouts> createState() => _PayoutsState();
}

class _PayoutsState extends State<Payouts> {
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
              'Payout Management',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage and process investor payouts',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: textGrey),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      255,
                      6,
                      97,
                      218,
                    ), // Care Kapital Blue
                    foregroundColor: Colors.white, // Text and Icon color
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Matching your card radii
                    ),
                  ),
                  child: Row(
                    spacing: 15,
                    children: [
                      Icon(Icons.add, size: 15, color: Colors.white),
                      Text(
                        'Process all scheduled',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Payoutkpiboxes(
                      value: '3',
                      title: 'Scheduled',
                      subtitle: '₹34,000',
                      icon: Icons.access_time_filled_rounded,
                      iconcolor: Colors.blue,
                      valueColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between cards
                  Expanded(
                    child: Payoutkpiboxes(
                      value: '2',
                      title: 'Completed',
                      subtitle: 'This month',
                      icon: Icons.check_circle_outline_rounded,
                      iconcolor: Colors.green,
                      valueColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Payoutkpiboxes(
                      value: '1',
                      title: 'Failed',
                      subtitle: 'Needs attention',
                      icon: Icons.error_outline_rounded,
                      iconcolor: Colors.red,
                      valueColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Payoutkpiboxes(
                      value: '6',
                      title: 'Total Payouts',
                      subtitle: 'All time',
                      icon: Icons.attach_money_rounded,
                      iconcolor: Colors.orange,
                      valueColor: Colors.black,
                    ),
                  ),
                ],
              ),
              //================= SearchBar and Dropdown=============================
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
                    OutlinedButton.icon(
                      onPressed: () {
                        print("Exporting data...");
                      },

                      icon: const Icon(
                        Icons.file_download_outlined,
                        color: Color(0xFF111827),
                        size: 20,
                      ),

                      label: const Text(
                        'Export',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),

                        // Define the rounded corners
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),

                        backgroundColor: Colors.white,

                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: PayoutsUserprofile(),
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
