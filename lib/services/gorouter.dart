import 'package:care_kapital_webapp_admin/auth/login.dart';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bond_listing.dart';
import 'package:care_kapital_webapp_admin/pages/Investors/investors.dart';
import 'package:care_kapital_webapp_admin/pages/payouts/payout_requests_page.dart';
import 'package:care_kapital_webapp_admin/pages/payouts/payouts.dart';
import 'package:care_kapital_webapp_admin/services/shell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/bondlistings',

    redirect: (context, state) {
      final loggedIn = FirebaseAuth.instance.currentUser != null;

      final isLoginPage = state.matchedLocation == '/login';

      if (!loggedIn && !isLoginPage) {
        return '/login';
      }

      if (loggedIn && isLoginPage) {
        return '/bondlistings';
      }

      return null;
    },

    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),

    routes: [
      // LOGIN
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const AdminLoginPage()),
      ),

      // ADMIN SHELL
      ShellRoute(
        builder: (context, state, child) => ShellLayout(child: child),

        routes: [
          // GoRoute(
          //   path: '/dashboard',
          //   pageBuilder: (context, state) =>
          //       NoTransitionPage(key: state.pageKey, child: const Dashboard()),
          // ),

          GoRoute(
            path: '/bondlistings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const BondListing(),
            ),
          ),

          GoRoute(
            path: '/investors',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const Investors()),
          ),

          GoRoute(
            path: '/payouts',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const Payouts()),
          ),

          GoRoute(
            path: '/payout-requests',
            builder: (context, state) => const PayoutRequestsPage(),
          ),
          // GoRoute(
          //   path: '/support',
          //   pageBuilder: (context, state) =>
          //       NoTransitionPage(
          //     key: state.pageKey,
          //     child: const Support(),
          //   ),
          // ),

          // GoRoute(
          //   path: '/reports',
          //   pageBuilder: (context, state) =>
          //       NoTransitionPage(
          //     key: state.pageKey,
          //     child: const Reports(),
          //   ),
          // ),

          // GoRoute(
          //   path: '/settings',
          //   pageBuilder: (context, state) =>
          //       NoTransitionPage(
          //     key: state.pageKey,
          //     child: const Settings(),
          //   ),
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
