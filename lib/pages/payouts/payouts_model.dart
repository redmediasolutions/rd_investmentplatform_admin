class AdminPayoutModel {
  final int id;
  final int investmentId;
  final int userId;
  final double amount;
  final String dueDate;
  final String? paidDate;
  final String status;
  final String? reference;
  final String investorName;
  final String investorEmail;
  final String bondName;

  AdminPayoutModel({
    required this.id,
    required this.investmentId,
    required this.userId,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.reference,
    required this.investorName,
    required this.investorEmail,
    required this.bondName,
  });

  bool get isPaid => status == 'paid';

  String get initials {
    final parts = investorName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return investorName.isNotEmpty ? investorName[0].toUpperCase() : '?';
  }

  String get formattedAmount {
    return '₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  factory AdminPayoutModel.fromJson(Map<String, dynamic> json) {
    return AdminPayoutModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      investmentId: json['investment_id'] is int
          ? json['investment_id']
          : int.tryParse(json['investment_id'].toString()) ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()) ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      dueDate: json['due_date'] ?? '',
      paidDate: json['paid_date'],
      status: json['status'] ?? 'upcoming',
      reference: json['reference'],
      investorName: json['investor_name'] ?? '',
      investorEmail: json['investor_email'] ?? '',
      bondName: json['bond_name'] ?? '',
    );
  }
}

class AdminPayoutSummary {
  final int scheduledCount;
  final double scheduledAmount;
  final int completedCount;
  final int totalCount;
  final double totalAmount;

  AdminPayoutSummary({
    required this.scheduledCount,
    required this.scheduledAmount,
    required this.completedCount,
    required this.totalCount,
    required this.totalAmount,
  });

  factory AdminPayoutSummary.fromJson(Map<String, dynamic> json) {
    return AdminPayoutSummary(
      scheduledCount: json['scheduled_count'] ?? 0,
      scheduledAmount:
          double.tryParse(json['scheduled_amount'].toString()) ?? 0,
      completedCount: json['completed_count'] ?? 0,
      totalCount: json['total_count'] ?? 0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0,
    );
  }

  String get formattedScheduledAmount {
    if (scheduledAmount >= 100000) {
      return '₹${(scheduledAmount / 100000).toStringAsFixed(1)}L';
    }
    return '₹${scheduledAmount.toStringAsFixed(0)}';
  }
}