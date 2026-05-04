class DashboardModel {
  final DashboardKpis kpis;
  final List<TopInvestor> topInvestors;
  final List<BondDistribution> bondDistribution;
  final List<RecentActivity> recentActivities;
  final TodayStats todayStats;

  DashboardModel({
    required this.kpis,
    required this.topInvestors,
    required this.bondDistribution,
    required this.recentActivities,
    required this.todayStats,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      kpis: DashboardKpis.fromJson(json['kpis']),
      topInvestors: (json['top_investors'] as List)
          .map((e) => TopInvestor.fromJson(e))
          .toList(),
      bondDistribution: (json['bond_distribution'] as List)
          .map((e) => BondDistribution.fromJson(e))
          .toList(),
      recentActivities: (json['recent_activities'] as List)
          .map((e) => RecentActivity.fromJson(e))
          .toList(),
      todayStats: TodayStats.fromJson(json['today_stats']),
    );
  }
}

class DashboardKpis {
  final int totalInvestors;
  final double totalAum;
  final double payoutsThisMonth;
  final int pendingPayouts;

  DashboardKpis({
    required this.totalInvestors,
    required this.totalAum,
    required this.payoutsThisMonth,
    required this.pendingPayouts,
  });

  String get formattedAum {
    if (totalAum >= 10000000) return '₹${(totalAum / 10000000).toStringAsFixed(1)}Cr';
    if (totalAum >= 100000) return '₹${(totalAum / 100000).toStringAsFixed(1)}L';
    return '₹${totalAum.toStringAsFixed(0)}';
  }

  String get formattedPayouts {
    if (payoutsThisMonth >= 100000) return '₹${(payoutsThisMonth / 100000).toStringAsFixed(1)}L';
    return '₹${payoutsThisMonth.toStringAsFixed(0)}';
  }

  factory DashboardKpis.fromJson(Map<String, dynamic> json) {
    return DashboardKpis(
      totalInvestors: json['total_investors'] is int
          ? json['total_investors']
          : int.tryParse(json['total_investors'].toString()) ?? 0,
      totalAum: double.tryParse(json['total_aum'].toString()) ?? 0,
      payoutsThisMonth:
          double.tryParse(json['payouts_this_month'].toString()) ?? 0,
      pendingPayouts: json['pending_payouts'] is int
          ? json['pending_payouts']
          : int.tryParse(json['pending_payouts'].toString()) ?? 0,
    );
  }
}

class TopInvestor {
  final int id;
  final String name;
  final String email;
  final int investmentCount;
  final double totalInvested;

  TopInvestor({
    required this.id,
    required this.name,
    required this.email,
    required this.investmentCount,
    required this.totalInvested,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get formattedInvested {
    if (totalInvested >= 10000000) return '₹${(totalInvested / 10000000).toStringAsFixed(1)}Cr';
    if (totalInvested >= 100000) return '₹${(totalInvested / 100000).toStringAsFixed(1)}L';
    return '₹${totalInvested.toStringAsFixed(0)}';
  }

  factory TopInvestor.fromJson(Map<String, dynamic> json) {
    return TopInvestor(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      investmentCount: json['investment_count'] is int
          ? json['investment_count']
          : int.tryParse(json['investment_count'].toString()) ?? 0,
      totalInvested: double.tryParse(json['total_invested'].toString()) ?? 0,
    );
  }
}

class BondDistribution {
  final String category;
  final double amount;
  final int percentage;

  BondDistribution({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  String get formattedAmount {
    if (amount >= 10000000) return '₹${(amount / 10000000).toStringAsFixed(1)}Cr';
    if (amount >= 100000) return '₹${(amount / 100000).toStringAsFixed(1)}L';
    return '₹${amount.toStringAsFixed(0)}';
  }

  factory BondDistribution.fromJson(Map<String, dynamic> json) {
    return BondDistribution(
      category: json['category'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      percentage: json['percentage'] is int
          ? json['percentage']
          : int.tryParse(json['percentage'].toString()) ?? 0,
    );
  }
}

class RecentActivity {
  final String activity;
  final String type;
  final String time;

  RecentActivity({
    required this.activity,
    required this.type,
    required this.time,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      activity: json['activity'] ?? '',
      type: json['type'] ?? 'investment',
      time: json['time'] ?? '',
    );
  }
}

class TodayStats {
  final int newInvestors;
  final int newInvestments;
  final int processedPayouts;
  final int pendingKyc;
  final int urgentTickets;

  TodayStats({
    required this.newInvestors,
    required this.newInvestments,
    required this.processedPayouts,
    required this.pendingKyc,
    required this.urgentTickets,
  });

  factory TodayStats.fromJson(Map<String, dynamic> json) {
    return TodayStats(
      newInvestors: json['new_investors'] is int
          ? json['new_investors']
          : int.tryParse(json['new_investors'].toString()) ?? 0,
      newInvestments: json['new_investments'] is int
          ? json['new_investments']
          : int.tryParse(json['new_investments'].toString()) ?? 0,
      processedPayouts: json['processed_payouts'] is int
          ? json['processed_payouts']
          : int.tryParse(json['processed_payouts'].toString()) ?? 0,
      pendingKyc: json['pending_kyc'] is int
          ? json['pending_kyc']
          : int.tryParse(json['pending_kyc'].toString()) ?? 0,
      urgentTickets: json['urgent_tickets'] is int
          ? json['urgent_tickets']
          : int.tryParse(json['urgent_tickets'].toString()) ?? 0,
    );
  }
}