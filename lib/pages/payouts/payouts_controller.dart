import 'package:care_kapital_webapp_admin/pages/payouts/payouts_model.dart';
import 'package:care_kapital_webapp_admin/services/api_service.dart';
import 'package:flutter/material.dart';

class AdminPayoutController extends ChangeNotifier {
  List<AdminPayoutModel> allPayouts = [];
  List<AdminPayoutModel> filteredPayouts = [];
  AdminPayoutSummary? summary;
  bool loading = false;
  bool processing = false;
  String? error;
  String statusFilter = 'all';
  String searchQuery = '';

  bool _disposed = false;

  // ← Override dispose to track state
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // ← Safe wrapper — never calls notifyListeners after dispose
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> fetchPayouts() async {
    loading = true;
    error = null;
    _notify();

    try {
      final data = await ApiService.getAdminPayouts();
      if (_disposed) return; // ← bail out if navigated away
      allPayouts = (data['payouts'] as List)
          .map((e) => AdminPayoutModel.fromJson(e))
          .toList();
      summary = AdminPayoutSummary.fromJson(data['summary']);
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
    filteredPayouts = allPayouts.where((p) {
      final matchSearch = searchQuery.isEmpty ||
          p.investorName.toLowerCase().contains(searchQuery) ||
          p.investorEmail.toLowerCase().contains(searchQuery) ||
          p.bondName.toLowerCase().contains(searchQuery);
      final matchStatus =
          statusFilter == 'all' || p.status == statusFilter;
      return matchSearch && matchStatus;
    }).toList();
  }

  Future<void> processPayout(int id) async {
    processing = true;
    _notify();
    try {
      await ApiService.processPayout(id);
      if (_disposed) return;
      await fetchPayouts();
    } catch (e) {
      if (_disposed) return;
      error = e.toString();
      processing = false;
      _notify();
      rethrow;
    }
  }

  Future<int> processAll() async {
    processing = true;
    _notify();
    try {
      final result = await ApiService.processAllPayouts();
      if (_disposed) return 0;
      await fetchPayouts();
      return result['processed'] ?? 0;
    } catch (e) {
      if (_disposed) return 0;
      error = e.toString();
      processing = false;
      _notify();
      rethrow;
    }
  }
}