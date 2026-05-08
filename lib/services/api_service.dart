import 'dart:convert';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bondlisting_models.dart';
import 'package:care_kapital_webapp_admin/pages/dashboard/dashboard_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseUrl = 'https://api.ip.rd-crm.in';

  static Future<String?> _getToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      return await user.getIdToken();
    } catch (e) {
      debugPrint('Token error: $e');
      return null;
    }
  }

  static Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ── BONDS ──────────────────────────────────────────
  static Future<List<BondModel>> getBonds() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bonds'),
      headers: await _headers(),
    );
    debugPrint('Bonds response: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['bonds'] as List)
          .map((e) => BondModel.fromJson(e))
          .toList();
    }
    throw Exception('Failed to load bonds (${response.statusCode})');
  }

  static Future<void> createBond(Map<String, dynamic> bond) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bonds'),
      headers: await _headers(),
      body: jsonEncode(bond),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create bond: ${response.body}');
    }
  }

  static Future<void> updateBond(int id, Map<String, dynamic> bond) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bonds/$id'),
      headers: await _headers(),
      body: jsonEncode(bond),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update bond: ${response.body}');
    }
  }

static Future<void> deleteBond(int id) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  final token = await user.getIdToken(true);

  final response = await http.delete(
    Uri.parse('$baseUrl/bonds/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  debugPrint('DELETE STATUS: ${response.statusCode}');
  debugPrint('DELETE BODY: ${response.body}');

  if (response.statusCode < 200 ||
      response.statusCode >= 300) {
    throw Exception(
      'Delete failed (${response.statusCode}): ${response.body}',
    );
  }
}


// ── INVESTORS ──────────────────────────────────────────

static Future<Map<String, dynamic>> getInvestors() async {
  final response = await http.get(
    Uri.parse('$baseUrl/admin/investors'),
    headers: await _headers(),
  );
  debugPrint('Investors: ${response.body}');
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  throw Exception('Failed to load investors (${response.statusCode})');
}

static Future<void> updateInvestorStatus(int id, String status) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/admin/investors/$id/status'),
    headers: await _headers(),
    body: jsonEncode({'status': status}),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update status: ${response.body}');
  }
}





// ── ADMIN PAYOUTS ──────────────────────────────────────

static Future<Map<String, dynamic>> getAdminPayouts({
  String status = 'all',
}) async {
  final uri = Uri.parse('$baseUrl/admin/payouts')
      .replace(queryParameters: status != 'all' ? {'status': status} : {});
  final response = await http.get(uri, headers: await _headers());
  debugPrint('Admin payouts: ${response.body}');
  if (response.statusCode == 200) return jsonDecode(response.body);
  throw Exception('Failed to load payouts (${response.statusCode})');
}

static Future<Map<String, dynamic>> processPayout(int id) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/admin/payouts/$id/process'),
    headers: await _headers(),
  );
  if (response.statusCode == 200) return jsonDecode(response.body);
  throw Exception('Failed to process payout: ${response.body}');
}

static Future<Map<String, dynamic>> processAllPayouts() async {
  final response = await http.post(
    Uri.parse('$baseUrl/admin/payouts/process-all'),
    headers: await _headers(),
  );
  if (response.statusCode == 200) return jsonDecode(response.body);
  throw Exception('Failed to process all payouts: ${response.body}');
}

static Future<DashboardModel> getDashboard() async {
  final response = await http.get(
    Uri.parse('$baseUrl/admin/dashboard'),
    headers: await _headers(),
  );
  debugPrint('Dashboard: ${response.body}');
  if (response.statusCode == 200) {
    return DashboardModel.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to load dashboard (${response.statusCode})');
}

static Future<Map<String, dynamic>> assignBond({
  required int userId,
  required int bondId,
  required double amount,
  String? startDate,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/admin/bond-investments'),
    headers: await _headers(),
    body: jsonEncode({
      "user_id": userId,
      "bond_id": bondId,
      "investment_amount": amount,
      "start_date": startDate ??
          DateTime.now().toIso8601String().split('T')[0],
    }),
  );

  debugPrint('Assign Bond: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception('Failed to assign bond: ${response.body}');
}

static Future<List<Map<String, dynamic>>> getUserBondInvestments() async {
  final response = await http.get(
    Uri.parse('$baseUrl/bond-investments'),
    headers: await _headers(),
  );

  debugPrint('User Bond Investments: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['investments']);
  }

  throw Exception('Failed to fetch investments');
}

static Future<List<Map<String, dynamic>>> getAllBondInvestments() async {
  final response = await http.get(
    Uri.parse('$baseUrl/admin/bond-investments'),
    headers: await _headers(),
  );

  debugPrint('All Bond Investments: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['investments']);
  }

  throw Exception('Failed to fetch all investments');
}

static Future<Map<String, dynamic>> getBondInvestment(int id) async {
  final response = await http.get(
    Uri.parse('$baseUrl/bond-investments/$id'),
    headers: await _headers(),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['investment'];
  }

  throw Exception('Failed to fetch investment');
}

static Future<void> updateBondInvestment({
  required int id,
  double? amount,
  String? status,
}) async {
  final body = <String, dynamic>{};
  if (amount != null) body['investment_amount'] = amount;
  if (status != null) body['status'] = status;

  final response = await http.put(
    Uri.parse('$baseUrl/admin/bond-investments/$id'),
    headers: await _headers(),
    body: jsonEncode(body),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update: ${response.body}');
  }
}

static Future<void> deleteBondInvestment(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/admin/bond-investments/$id'),
    headers: await _headers(),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete: ${response.body}');
  }
}

static Future<List<BondModel>> getActiveBonds() async {
  final bonds = await getBonds();
  return bonds.where((b) => b.status == 'active').toList();
}

static double getAvailableAmount(Map bond) {
  return double.parse(bond['total_issue_size'].toString()) -
      double.parse(bond['amount_raised'].toString());
}

static Future<Map<String, dynamic>> getInvestorBondInvestments(int userId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/admin/investors/$userId/bond-investments'),
    headers: await _headers(),
  );

  debugPrint('Investor Investments: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception('Failed to fetch investor investments');
}

static Future<Map<String, dynamic>> createInvestor({
  required String name,
  required String email,
  required String password,
  String? phone,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/admin/investors/create'),
    headers: await _headers(),
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    }),
  );
  if (response.statusCode == 200) return jsonDecode(response.body);
  final error = jsonDecode(response.body);
  throw Exception(error['message'] ?? 'Failed to create investor');
}
}