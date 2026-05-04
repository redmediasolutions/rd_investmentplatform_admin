import 'package:flutter/material.dart';

class BondAddForm extends StatefulWidget {
  final Map<String, dynamic>? existingBond; 
  final Function(Map<String, dynamic>) onSubmit;

  const BondAddForm({super.key, this.existingBond, required this.onSubmit});

  @override
  State<BondAddForm> createState() => _BondAddFormState();
}

class _BondAddFormState extends State<BondAddForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _bondName;
  late TextEditingController _issuer;
  late TextEditingController _interestRate;
  late TextEditingController _maturityPeriod;
  late TextEditingController _minInvestment;
  late TextEditingController _maxInvestment;
  late TextEditingController _totalIssueSize;
  late TextEditingController _listingDate;
  late TextEditingController _closingDate;
  late TextEditingController _description;
  late TextEditingController _category;

  String _payoutFrequency = 'quarterly';
  String _riskLevel = 'low';
  String _status = 'active';

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final b = widget.existingBond;
    _bondName = TextEditingController(text: b?['bond_name'] ?? '');
    _issuer = TextEditingController(text: b?['issuer'] ?? '');
    _interestRate = TextEditingController(text: b?['interest_rate']?.toString() ?? '');
    _maturityPeriod = TextEditingController(text: b?['maturity_period']?.toString() ?? '');
    _minInvestment = TextEditingController(text: b?['min_investment']?.toString() ?? '');
    _maxInvestment = TextEditingController(text: b?['max_investment']?.toString() ?? '');
    _totalIssueSize = TextEditingController(text: b?['total_issue_size']?.toString() ?? '');
    _listingDate = TextEditingController(text: b?['listing_date'] ?? '');
    _closingDate = TextEditingController(text: b?['closing_date'] ?? '');
    _description = TextEditingController(text: b?['description'] ?? '');
    _category = TextEditingController(text: b?['category'] ?? '');
    _payoutFrequency = b?['payout_frequency'] ?? 'quarterly';
    _riskLevel = b?['risk_level'] ?? 'low';
    _status = b?['status'] ?? 'active';
  }

  @override
  void dispose() {
    for (final c in [
      _bondName, _issuer, _interestRate, _maturityPeriod,
      _minInvestment, _maxInvestment, _totalIssueSize,
      _listingDate, _closingDate, _description, _category,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit({
        'bond_name': _bondName.text.trim(),
        'issuer': _issuer.text.trim(),
        'interest_rate': double.tryParse(_interestRate.text) ?? 0,
        'maturity_period': int.tryParse(_maturityPeriod.text) ?? 0,
        'min_investment': double.tryParse(_minInvestment.text) ?? 0,
        'max_investment': double.tryParse(_maxInvestment.text) ?? 0,
        'payout_frequency': _payoutFrequency,
        'risk_level': _riskLevel,
        'category': _category.text.trim(),
        'status': _status,
        'total_issue_size': double.tryParse(_totalIssueSize.text) ?? 0,
        'listing_date': _listingDate.text.trim(),
        'closing_date': _closingDate.text.trim(),
        'description': _description.text.trim(),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingBond != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? 'Edit Bond Listing' : 'Add New Bond Listing',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Text(
                  isEdit
                      ? 'Update the bond details below'
                      : 'Fill in the details to create a bond listing',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),

                // Scrollable form
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _row(_field('Bond Name', _bondName),
                            _field('Issuer', _issuer)),
                        _row(
                            _field('Interest Rate (%)', _interestRate,
                                isNumber: true),
                            _field('Maturity Period (months)', _maturityPeriod,
                                isNumber: true)),
                        _row(
                            _field('Min Investment (₹)', _minInvestment,
                                isNumber: true),
                            _field('Max Investment (₹)', _maxInvestment,
                                isNumber: true)),
                        _row(
                            _dropdown('Payout Frequency', _payoutFrequency,
                                ['monthly', 'quarterly', 'half-yearly', 'yearly'],
                                (v) => setState(() => _payoutFrequency = v!)),
                            _dropdown('Risk Level', _riskLevel,
                                ['low', 'medium', 'high'],
                                (v) => setState(() => _riskLevel = v!))),
                        _row(
                            _field('Category', _category),
                            _dropdown('Status', _status,
                                ['active', 'inactive', 'closed'],
                                (v) => setState(() => _status = v!))),
                        _row(
                            _field('Total Issue Size (₹)', _totalIssueSize,
                                isNumber: true),
                            _datePicker('Listing Date', _listingDate)),
                        _row(
                            _datePicker('Closing Date', _closingDate),
                            const SizedBox()),
                        const SizedBox(height: 4),
                        _field('Description', _description,
                            maxLines: 3, required: false),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D63D1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(isEdit ? 'Save Changes' : 'Add Bond',
                              style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(Widget left, Widget right) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(children: [
          Expanded(child: left),
          const SizedBox(width: 14),
          Expanded(child: right),
        ]),
      );

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1, bool isNumber = false, bool required = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: required
              ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, String value, List<String> options,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: options
              .map((o) => DropdownMenuItem(
                  value: o,
                  child: Text(o[0].toUpperCase() + o.substring(1))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _datePicker(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _pickDate(controller),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            suffixIcon:
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}