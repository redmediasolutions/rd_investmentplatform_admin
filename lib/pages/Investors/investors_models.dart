class InvestorModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String status;
  final String joined;
  final int totalInvestments;
  final double totalInvested;

  InvestorModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.status,
    required this.joined,
    required this.totalInvestments,
    required this.totalInvested,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get formattedInvested {
    if (totalInvested >= 10000000) {
      return '₹${(totalInvested / 10000000).toStringAsFixed(1)}Cr';
    }
    if (totalInvested >= 100000) {
      return '₹${(totalInvested / 100000).toStringAsFixed(1)}L';
    }
    return '₹${totalInvested.toStringAsFixed(0)}';
  }

  factory InvestorModel.fromJson(Map<String, dynamic> json) {
    return InvestorModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      status: json['status'] ?? 'active',
      joined: json['joined'] ?? '',
      totalInvestments: json['total_investments'] is int
          ? json['total_investments']
          : int.tryParse(json['total_investments'].toString()) ?? 0,
      totalInvested:
          double.tryParse(json['total_invested'].toString()) ?? 0,
    );
  }
}

class InvestorSummary {
  final int total;
  final int active;
  final int inactive;

  InvestorSummary({
    required this.total,
    required this.active,
    required this.inactive,
  });

  factory InvestorSummary.fromJson(Map<String, dynamic> json) {
    return InvestorSummary(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      inactive: json['inactive'] ?? 0,
    );
  }
}