import 'package:care_kapital_webapp_admin/Theme/apptheme.dart';
import 'package:care_kapital_webapp_admin/components/searchbar.dart';
import 'package:care_kapital_webapp_admin/pages/BondsListing/boand_addform.dart';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bondlisting_models.dart';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bonds_certificate_list.dart';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bonds_controller.dart';
import 'package:flutter/material.dart';

class BondListing extends StatefulWidget {
  const BondListing({super.key});

  @override
  State<BondListing> createState() => _BondListingState();
}

class _BondListingState extends State<BondListing> {
  final BondController _controller = BondController();
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.fetchBonds();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openAddForm({BondModel? bond}) {
    showDialog(
      context: context,
      builder: (_) => BondAddForm(
        existingBond: bond?.toJson(),
        onSubmit: (data) async {
          if (bond != null) {
            await _controller.updateBond(bond.id, data);
          } else {
            await _controller.createBond(data);
          }
        },
      ),
    );
  }

  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Bond'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _controller.deleteBond(id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Bond deleted'),
                      backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bond Listings',
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
                  'Manage all bond investment products',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: textGrey),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openAddForm(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New Bond',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D63D1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Search + Filter bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SearchbarWidget(
                      onChanged: _controller.search,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Status')),
                        DropdownMenuItem(value: 'active', child: Text('Active')),
                        DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                        DropdownMenuItem(value: 'closed', child: Text('Closed')),
                      ],
                      onChanged: (v) {
                        setState(() => _selectedStatus = v!);
                        _controller.filterByStatus(v!);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // List
            if (_controller.loading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_controller.error != null)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(_controller.error!),
                    TextButton.icon(
                      onPressed: _controller.fetchBonds,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (_controller.filteredBonds.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: Text('No bonds found.')),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.filteredBonds.length,
                itemBuilder: (context, index) {
                  final bond = _controller.filteredBonds[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BondProjectCard(
                      bond: bond,
                      onEdit: () => _openAddForm(bond: bond),
                      onDelete: () => _confirmDelete(bond.id, bond.bondName),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}