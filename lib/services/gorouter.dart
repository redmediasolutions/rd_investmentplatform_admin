import 'package:care_kapital_webapp_admin/auth/login.dart';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bond_listing.dart';
import 'package:care_kapital_webapp_admin/pages/dashboard/dashboard.dart';
import 'package:care_kapital_webapp_admin/pages/investors/investors.dart';
import 'package:care_kapital_webapp_admin/pages/payouts/payouts.dart';
import 'package:care_kapital_webapp_admin/services/shell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final loggedIn = FirebaseAuth.instance.currentUser != null;
      final isLoginPage = state.matchedLocation == '/login';

      if (!loggedIn && !isLoginPage) return '/login';
      if (loggedIn && isLoginPage) return '/dashboard';
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    routes: [
      // Login — no sidebar
      GoRoute(
        path: '/login',
        builder: (context, state) => const AdminLoginPage(),
      ),

      // All admin pages wrapped in ShellRoute (sidebar)
      ShellRoute(
        builder: (context, state, child) => ShellLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const Dashboard(),
          ),
          GoRoute(
            path: '/bondlistings',
            builder: (context, state) => const BondListing(),
          ),
          GoRoute(
            path: '/investors',
            builder: (context, state) => const Investors(),
          ),
          GoRoute(
            path: '/payouts',
            builder: (context, state) => const Payouts(),
          ),
          // GoRoute(
          //   path: '/support',
          //   builder: (context, state) => const Support(),
          // ),
          // GoRoute(
          //   path: '/reports',
          //   builder: (context, state) => const Reports(),
          // ),
          // GoRoute(
          //   path: '/settings',
          //   builder: (context, state) => const Settings(),
          // ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}