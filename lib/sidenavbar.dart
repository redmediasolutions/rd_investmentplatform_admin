import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sidenavbar extends StatefulWidget {
  const Sidenavbar({super.key});

  @override
  State<Sidenavbar> createState() => _SidenavbarState();
}

class _SidenavbarState extends State<Sidenavbar> {
  String _selectedRoute = '/dashboard';

  Widget _item(
    BuildContext context, {
    required String route,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedRoute == route;

    return InkWell(
      onTap: () {
        setState(() => _selectedRoute = route);
        context.go(route);
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0D63D1).withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? const Color(0xFF0D63D1) : const Color(0xFF6C757D),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF0D63D1) : const Color(0xFF1A1C1E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material( // Added Material to ensure text styles render correctly
      color: Colors.white,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LOGO SECTION ---
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 8),
              child: Row(
                children: const [
                  SizedBox(width: 12),
                  Text(
                    "Carekapital",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1C1E),
                    ),
                  ),
                ],
              ),
            ),

            // --- MAIN NAVIGATION ---
            _item(context, route: '/dashboard', icon: Icons.grid_view_rounded, label: "Dashboard"),
            _item(context, route: '/bondlistings', icon: Icons.trending_up_rounded, label: "Bond Listings"),
            _item(context, route: '/investors', icon: Icons.people_alt_outlined, label: "Investors"),
            _item(context, route: '/payouts', icon: Icons.attach_money, label: "Payouts"),
            // _item(context, route: '/supportTickets', icon: Icons.support, label: "Support Tickets"),
            // _item(context, route: '/reports', icon: Icons.content_paste_sharp, label: "Reports"),
            // _item(context, route: '/settings', icon: Icons.settings, label: "Settings"),

            const Spacer(),

            // --- USER PROFILE SECTION ---
            const Divider(height: 40, thickness: 1),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF9735FF),
                child: Text("AR", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              title: const Text(
                'Arjun Reddy',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
              ),
              subtitle: const Text('arjun@email.com', style: TextStyle(fontSize: 11)),
              trailing: IconButton(
                icon: const Icon(Icons.logout, size: 20, color: Color(0xFFE53935)),
                onPressed: () {
                  // Logout logic here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MOVED OUTSIDE OF SIDENAVBAR CLASS ---
class SearchbarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const SearchbarWidget({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search bonds...',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}