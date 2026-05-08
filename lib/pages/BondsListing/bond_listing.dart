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
  final String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() { if (mounted) setState(() {}); });
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
      barrierDismissible: false,
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

    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      title: const Text(
        'Confirm Deletion',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: Text(
        'Are you sure you want to permanently remove "$name" from the listings?',
      ),

      actions: [

        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Keep it'),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),

          onPressed: () async {

            // Close ONLY dialog
            Navigator.of(dialogContext).pop();

            try {

              await _controller.deleteBond(id);

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Bond removed successfully',
                  ),
                  backgroundColor: Colors.black87,
                ),
              );

            } catch (e) {

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Delete failed: $e',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },

          child: const Text('Yes, Delete'),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Bond Listings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                    const SizedBox(height: 4),
                    Text('Manage and monitor your investment inventory', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _openAddForm(),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add New Bond'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D63D1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 24),
        // Refined Filter Header
        /*Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
          ),
          child: Row(
            children: [
              Expanded(child: SearchbarWidget(onChanged: _controller.search)),
              const SizedBox(width: 16),
              Container(
                width: 180,
                decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16)),
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
        ),*/

        // Content
        Expanded(
          child: _controller.loading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D63D1)))
              : _controller.filteredBonds.isEmpty
                  ? Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers_clear_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text('No records found', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _controller.filteredBonds.length,
                      itemBuilder: (context, index) {
                        return BondProjectCard(
                          bond: _controller.filteredBonds[index],
                          onEdit: () => _openAddForm(bond: _controller.filteredBonds[index]),
                          onDelete: () => _confirmDelete(_controller.filteredBonds[index].id, _controller.filteredBonds[index].bondName),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}