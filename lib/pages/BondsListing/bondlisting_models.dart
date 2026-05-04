class BondModel {
  final int id;
  final String bondName;
  final String issuer;
  final double interestRate;
  final int maturityPeriod;
  final double minInvestment;
  final double maxInvestment;
  final String payoutFrequency;
  final String riskLevel;
  final String? category;
  final String status;
  final double totalIssueSize;
  final double amountRaised;
  final String listingDate;
  final String? closingDate;
  final String? description;

  BondModel({
    required this.id,
    required this.bondName,
    required this.issuer,
    required this.interestRate,
    required this.maturityPeriod,
    required this.minInvestment,
    required this.maxInvestment,
    required this.payoutFrequency,
    required this.riskLevel,
    this.category,
    required this.status,
    required this.totalIssueSize,
    required this.amountRaised,
    required this.listingDate,
    this.closingDate,
    this.description,
  });

  double get progressPercent =>
      totalIssueSize > 0 ? (amountRaised / totalIssueSize).clamp(0.0, 1.0) : 0.0;

  double get availableAmount => totalIssueSize - amountRaised;

  factory BondModel.fromJson(Map<String, dynamic> json) {
    return BondModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      bondName: json['bond_name'] ?? '',
      issuer: json['issuer'] ?? '',
      interestRate: double.tryParse(json['interest_rate'].toString()) ?? 0,
      maturityPeriod: json['maturity_period'] is int
          ? json['maturity_period']
          : int.tryParse(json['maturity_period'].toString()) ?? 0,
      minInvestment: double.tryParse(json['min_investment'].toString()) ?? 0,
      maxInvestment: double.tryParse(json['max_investment'].toString()) ?? 0,
      payoutFrequency: json['payout_frequency'] ?? '',
      riskLevel: json['risk_level'] ?? 'low',
      category: json['category'],
      status: json['status'] ?? 'active',
      totalIssueSize: double.tryParse(json['total_issue_size'].toString()) ?? 0,
      amountRaised: double.tryParse(json['amount_raised'].toString()) ?? 0,
      listingDate: json['listing_date'] ?? '',
      closingDate: json['closing_date'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bond_name': bondName,
      'issuer': issuer,
      'interest_rate': interestRate,
      'maturity_period': maturityPeriod,
      'min_investment': minInvestment,
      'max_investment': maxInvestment,
      'payout_frequency': payoutFrequency,
      'risk_level': riskLevel,
      'category': category,
      'status': status,
      'total_issue_size': totalIssueSize,
      'amount_raised': amountRaised,
      'listing_date': listingDate,
      'closing_date': closingDate,
      'description': description,
    };
  }
}