import 'package:care_kapital_webapp_admin/pages/BondsListing/bondlisting_models.dart';
import 'package:flutter/material.dart';
import 'package:care_kapital_webapp_admin/services/api_service.dart';

class BondController extends ChangeNotifier {
  List<BondModel> allBonds = [];
  List<BondModel> filteredBonds = [];
  bool loading = false;
  String? error;
  String searchQuery = '';
  String statusFilter = 'all';

  Future<void> fetchBonds() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      allBonds = await ApiService.getBonds();
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
    filteredBonds = allBonds.where((b) {
      final matchesSearch = searchQuery.isEmpty ||
          b.bondName.toLowerCase().contains(searchQuery) ||
          b.issuer.toLowerCase().contains(searchQuery);
      final matchesStatus =
          statusFilter == 'all' || b.status == statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> createBond(Map<String, dynamic> data) async {
    await ApiService.createBond(data);
    await fetchBonds();
  }

  Future<void> updateBond(int id, Map<String, dynamic> data) async {
    await ApiService.updateBond(id, data);
    await fetchBonds();
  }

Future<void> deleteBond(int id) async {
  try {
    await ApiService.deleteBond(id);

    await fetchBonds();

  } catch (e) {
    debugPrint('Delete bond error: $e');
    rethrow;
  }
}

  String formatCrore(double amount) {
    if (amount >= 10000000) return '₹${(amount / 10000000).toStringAsFixed(1)}Cr';
    if (amount >= 100000) return '₹${(amount / 100000).toStringAsFixed(1)}L';
    return '₹${amount.toStringAsFixed(0)}';
  }
}