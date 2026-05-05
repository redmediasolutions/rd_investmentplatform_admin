import 'package:care_kapital_webapp_admin/pages/Investors/investors_models.dart';
import 'package:flutter/material.dart';
import 'package:care_kapital_webapp_admin/services/api_service.dart';

class InvestorController extends ChangeNotifier {
  List<InvestorModel> allInvestors = [];
  List<InvestorModel> filteredInvestors = [];
  InvestorSummary? summary;
  bool loading = false;
  String? error;
  String searchQuery = '';
  String statusFilter = 'all';
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> fetchInvestors() async {
    loading = true;
    error = null;
    _notify();
    try {
      final data = await ApiService.getInvestors();
      if (_disposed) return;
      allInvestors = (data['investors'] as List)
          .map((e) => InvestorModel.fromJson(e))
          .toList();
      summary = InvestorSummary.fromJson(data['summary']);
      _applyFilters();
    } catch (e) {
      if (_disposed) return;
      error = e.toString();
    } finally {
      loading = false;
      _notify();
    }
  }

  void search(String query) {
    searchQuery = query.toLowerCase();
    _applyFilters();
    _notify();
  }

  void filterByStatus(String status) {
    statusFilter = status;
    _applyFilters();
    _notify();
  }

  void _applyFilters() {
    filteredInvestors = allInvestors.where((inv) {
      final matchSearch = searchQuery.isEmpty ||
          inv.name.toLowerCase().contains(searchQuery) ||
          inv.email.toLowerCase().contains(searchQuery);
      final matchStatus =
          statusFilter == 'all' || inv.status == statusFilter;
      return matchSearch && matchStatus;
    }).toList();
  }

  Future<void> updateStatus(int id, String status) async {
    await ApiService.updateInvestorStatus(id, status);
    if (_disposed) return;
    await fetchInvestors();
  }

  Future<Map<String, dynamic>> createInvestor({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final result = await ApiService.createInvestor(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    if (_disposed) return result;
    await fetchInvestors();
    return result;
  }
}