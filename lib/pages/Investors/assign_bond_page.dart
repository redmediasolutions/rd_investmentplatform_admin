import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this for comma formatting
import 'package:care_kapital_webapp_admin/services/api_service.dart';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bondlisting_models.dart';

class AssignBondPage extends StatefulWidget {
  final dynamic investor;

  const AssignBondPage({super.key, required this.investor});

  @override
  State<AssignBondPage> createState() => _AssignBondPageState();
}

class _AssignBondPageState extends State<AssignBondPage> {
  List<BondModel> bonds = [];
  BondModel? selectedBond;

  final TextEditingController amountController = TextEditingController();
  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  bool isLoading = false;
  bool isSubmitting = false;
  double availableAmount = 0;

  @override
  void initState() {
    super.initState();
    fetchBonds();
  }

  // ========================= FETCH BONDS =========================

  Future<void> fetchBonds() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getBonds();
      setState(() {
        bonds = data.where((b) => b.status == 'active').toList();
      });
    } catch (e) {
      _showError(e.toString());
    }
    setState(() => isLoading = false);
  }

  // ========================= ASSIGN =========================

  Future<void> assignBond() async {
    if (selectedBond == null) {
      _showError('Please select a bond');
      return;
    }

    if (amountController.text.isEmpty) {
      _showError('Enter investment amount');
      return;
    }

    final amount = double.tryParse(amountController.text.replaceAll(',', ''));
    if (amount == null) {
      _showError('Invalid amount');
      return;
    }

    if (amount < selectedBond!.minInvestment) {
      _showError('Minimum investment is ${formatter.format(selectedBond!.minInvestment)}');
      return;
    }

    if (amount > selectedBond!.maxInvestment) {
      _showError('Maximum investment is ${formatter.format(selectedBond!.maxInvestment)}');
      return;
    }

    if (amount > availableAmount) {
      _showError('Amount exceeds available capacity');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await ApiService.assignBond(
        userId: widget.investor.id,
        bondId: selectedBond!.id,
        amount: amount,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bond Assigned Successfully'), backgroundColor: Colors.green),
      );

      Navigator.pop(context, true);
    } catch (e) {
      _showError(e.toString());
    }

    setState(() => isSubmitting = false);
  }

  // ========================= HELPERS =========================

  void _onBondSelected(BondModel bond) {
    setState(() {
      selectedBond = bond;
      availableAmount = bond.totalIssueSize - bond.amountRaised;
      amountController.clear();
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Assign Bond', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  _userHeader(),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Inputs
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _formSection(),
                            const SizedBox(height: 24),
                            _submitButton(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Right Column: Details/Stats
                      Expanded(
                        flex: 2,
                        child: selectedBond != null ? _bondDetailsSidebar() : _emptyState(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // ========================= UI COMPONENTS =========================

  Widget _userHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Text(widget.investor.initials ?? 'U', 
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.investor.name, 
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(widget.investor.email, 
                  style: TextStyle(color: Colors.blue.shade100, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Investment Configuration", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            DropdownButtonFormField<BondModel>(
              decoration: InputDecoration(
                labelText: 'Select Bond',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              value: selectedBond,
              items: bonds.map((bond) => DropdownMenuItem(value: bond, child: Text(bond.bondName))).toList(),
              onChanged: (val) => val != null ? _onBondSelected(val) : null,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: 'Investment Amount',
                prefixText: '₹ ',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bondDetailsSidebar() {
    final b = selectedBond!;
    final double percentFilled = (b.amountRaised / b.totalIssueSize).clamp(0.0, 1.0);

    return Column(
      children: [
        _infoCard("Returns", "${b.interestRate}%", Icons.trending_up, Colors.orange),
        const SizedBox(height: 16),
        _infoCard("Available Liquidity", formatter.format(availableAmount), Icons.account_balance_wallet, Colors.green),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Bond Capacity", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: percentFilled,
                minHeight: 12,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(percentFilled > 0.8 ? Colors.red : Colors.blue),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${(percentFilled * 100).toStringAsFixed(1)}% Subscribed", style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(formatter.format(b.totalIssueSize), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const Divider(height: 32),
              _rowInfo("Minimum", formatter.format(b.minInvestment)),
              const SizedBox(height: 8),
              _rowInfo("Maximum", formatter.format(b.maxInvestment)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _rowInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.none),
      ),
      child: const Center(
        child: Text("Select a bond to view analytics", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : assignBond,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E40AF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Confirm & Finalize Assignment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}