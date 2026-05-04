import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0D63D1)),
          ),
          child: child!,
        );
      },
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
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
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
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Styled Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF0D63D1).withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEdit ? 'Update Bond Listing' : 'New Bond Entry',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1F2937)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEdit ? 'ID: ${widget.existingBond?['id']}' : 'Enter market details for the new bond',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _row(_field('Bond Title', _bondName, hint: 'e.g. Series VII Gold Bonds'),
                          _field('Issuer Organization', _issuer, hint: 'e.g. RBI')),
                      _row(
                          _field('Coupon Rate (%)', _interestRate, isNumber: true, hint: '8.5'),
                          _field('Tenure (Months)', _maturityPeriod, isNumber: true, hint: '36')),
                      _row(
                          _field('Minimum Bid (₹)', _minInvestment, isNumber: true, hint: '10,000'),
                          _field('Maximum Cap (₹)', _maxInvestment, isNumber: true, hint: '5,00,000')),
                      _row(
                          _dropdown('Payout Schedule', _payoutFrequency,
                              ['monthly', 'quarterly', 'half-yearly', 'yearly'],
                              (v) => setState(() => _payoutFrequency = v!)),
                          _dropdown('Security Level', _riskLevel,
                              ['low', 'medium', 'high'],
                              (v) => setState(() => _riskLevel = v!))),
                      _row(
                          _field('Market Category', _category, hint: 'Corporate / Govt'),
                          _dropdown('Trading Status', _status,
                              ['active', 'inactive', 'closed'],
                              (v) => setState(() => _status = v!))),
                      _row(
                          _field('Total Issue (₹)', _totalIssueSize, isNumber: true, hint: '1,00,00,000'),
                          _datePicker('Live Date', _listingDate)),
                      _row(
                          _datePicker('Expiry Date', _closingDate),
                          const SizedBox()),
                      const SizedBox(height: 8),
                      _field('Market Overview / Description', _description,
                          maxLines: 4, required: false, hint: 'Additional terms and conditions...'),
                    ],
                  ),
                ),
              ),
            ),

            // Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text('Discard', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D63D1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _submitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(isEdit ? 'Update Details' : 'Create Listing',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(Widget left, Widget right) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: left),
          const SizedBox(width: 20),
          Expanded(child: right),
        ]),
      );

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1, bool isNumber = false, bool required = true, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF374151))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Required field' : null : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0D63D1), width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF374151))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0D63D1))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o[0].toUpperCase() + o.substring(1), style: const TextStyle(fontSize: 14))))
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF374151))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _pickDate(controller),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF0D63D1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0D63D1))),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}