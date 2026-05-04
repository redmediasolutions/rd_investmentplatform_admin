import 'package:care_kapital_webapp_admin/pages/dashboard/dashboard_models.dart';
import 'package:care_kapital_webapp_admin/services/api_service.dart';
import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  DashboardModel? data;
  bool loading = false;
  String? error;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> fetchDashboard() async {
    loading = true;
    error = null;
    _notify();
    try {
      data = await ApiService.getDashboard();
      if (_disposed) return;
    } catch (e) {
      if (_disposed) return;
      error = e.toString();
    } finally {
      loading = false;
      _notify();
    }
  }
}