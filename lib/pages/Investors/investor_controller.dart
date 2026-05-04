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

  Future<void> fetchInvestors() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final data = await ApiService.getInvestors();
      allInvestors = (data['investors'] as List)
          .map((e) => InvestorModel.fromJson(e))
          .toList();
      summary = InvestorSummary.fromJson(data['summary']);
      _applyFilters();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void filterByStatus(String status) {
    statusFilter = status;
    _applyFilters();
    notifyListeners();
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
    await fetchInvestors();
  }
}