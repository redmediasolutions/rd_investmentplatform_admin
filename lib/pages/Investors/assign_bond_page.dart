import 'package:flutter/material.dart';
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

    final amount = double.tryParse(amountController.text);
    if (amount == null) {
      _showError('Invalid amount');
      return;
    }

    // VALIDATIONS
    if (amount < selectedBond!.minInvestment) {
      _showError(
          'Minimum investment is ₹${selectedBond!.minInvestment.toInt()}');
      return;
    }

    if (amount > selectedBond!.maxInvestment) {
      _showError(
          'Maximum investment is ₹${selectedBond!.maxInvestment.toInt()}');
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
        const SnackBar(content: Text('Bond Assigned Successfully')),
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Bond - ${widget.investor.name}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _userCard(),
                  const SizedBox(height: 20),
                  _bondDropdown(),
                  const SizedBox(height: 20),
                  _amountField(),
                  const SizedBox(height: 20),
                  if (selectedBond != null) _bondInfo(),
                  const Spacer(),
                  _submitButton(),
                ],
              ),
            ),
    );
  }

  // ========================= UI COMPONENTS =========================

  Widget _userCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(widget.investor.initials ?? 'U'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.investor.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.investor.email),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bondDropdown() {
    return DropdownButtonFormField<BondModel>(
      decoration: const InputDecoration(
        labelText: 'Select Bond',
        border: OutlineInputBorder(),
      ),
      value: selectedBond,
      items: bonds.map((bond) {
        return DropdownMenuItem(
          value: bond,
          child: Text(bond.bondName),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) _onBondSelected(val);
      },
    );
  }

  Widget _amountField() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Investment Amount',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _bondInfo() {
    final b = selectedBond!;

   final double percentFilled =
    (b.amountRaised / b.totalIssueSize).clamp(0.0, 1.0).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Interest: ${b.interestRate}%"),
          Text("Min: ₹${b.minInvestment.toInt()}"),
          Text("Max: ₹${b.maxInvestment.toInt()}"),
          Text("Available: ₹${availableAmount.toInt()}"),
          const SizedBox(height: 10),

          // Capacity Bar
          LinearProgressIndicator(value: percentFilled),
          const SizedBox(height: 4),
          Text(
            "${(percentFilled * 100).toStringAsFixed(0)}% filled",
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : assignBond,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Assign Bond',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}