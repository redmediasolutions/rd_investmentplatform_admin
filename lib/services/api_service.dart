import 'dart:convert';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bondlisting_models.dart';
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
    final response = await http.delete(
      Uri.parse('$baseUrl/bonds/$id'),
      headers: await _headers(),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete bond: ${response.body}');
    }
  }
}