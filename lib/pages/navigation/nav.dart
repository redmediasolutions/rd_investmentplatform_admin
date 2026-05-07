import 'dart:async';
import 'package:care_kapital_webapp_admin/pages/BondsListing/bond_listing.dart';
import 'package:care_kapital_webapp_admin/pages/investors/investors.dart';
import 'package:care_kapital_webapp_admin/pages/dashboard/dashboard.dart';
import 'package:care_kapital_webapp_admin/pages/navigation/shell.dart';
import 'package:care_kapital_webapp_admin/pages/payouts/payouts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


//final firebaseAuth = FirebaseAuth.instance;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // refreshListenable:
  //     GoRouterRefreshStream(firebaseAuth.authStateChanges()),
 
  // redirect: (context, state) {
  //   final user = firebaseAuth.currentUser;
  //   final loggedIn = user != null;
  //   final isLogin = state.uri.path == '/login';

  //   if (!loggedIn && !isLogin) return '/login';
  //   if (loggedIn && isLogin) return '/home';

  //   return null;
  // },
  routes: [
  //  🔓 AUTH (NO SHELL)
    // GoRoute(
    //   path: '/login',
    //   builder: (context, state) => const LoginPage(),
    // ),
     
   
    // 🔒 APP (SHELL ONCE)
    ShellRoute(
      builder: (context, state, child) {
        return ShellPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          redirect: (_, _) => '/dashboard',
        ),
         GoRoute(
          path: '/dashboard',
           builder: (context, state) => Dashboard(),
        ),
        GoRoute(
          path: '/bondlistings',
           builder: (context, state) => BondListing(),
        ),
         GoRoute(
          path: '/investors',
           builder: (context, state) => Investors(),
        ),
          GoRoute(
          path: '/payouts',
           builder: (context, state) => Payouts(),
        ),
    

       
      ],
    ),
  ],
);

/// 🔁 Forces GoRouter to refresh when Supabase auth changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
