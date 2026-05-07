import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  bool loading = false;

  void _safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  void _showError(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    _safeSetState(() => loading = true);

    try {
      // Firebase Login
      final cred = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final token = await cred.user!.getIdToken();

      // Validate backend access
      final response = await http.get(
        Uri.parse('https://api.ip.rd-crm.in/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        await auth.signOut();

        _safeSetState(() => loading = false);

        _showError('Access denied');

        return;
      }

      final data = jsonDecode(response.body);

      final user = data['user'];

      final role = user['role'];

      // Allow ONLY admins
      if (role != 'tenant_admin' &&
          role != 'super_admin') {

        await auth.signOut();

        _safeSetState(() => loading = false);

        _showError(
          'You are not authorized to access admin panel',
        );

        return;
      }

      // Success
      _safeSetState(() => loading = false);

      // Router/auth stream will continue

    } on FirebaseAuthException catch (e) {

      _safeSetState(() => loading = false);

      _showError(_friendlyError(e.code));

    } catch (e) {

      _safeSetState(() => loading = false);

      _showError('Login failed: $e');
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';

      case 'wrong-password':
        return 'Incorrect password';

      case 'invalid-email':
        return 'Invalid email address';

      case 'too-many-requests':
        return 'Too many attempts. Try again later';

      default:
        return 'Login failed';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D63D1),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    'CareKapital',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                'Admin Portal',
                style: TextStyle(
                  color: Color(0xFF0D63D1),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'admin@example.com',
                  filled: true,
                  fillColor:
                      const Color(0xFFF9FAFB),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),

                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: true,
                onSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  filled: true,
                  fillColor:
                      const Color(0xFFF9FAFB),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),

                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      loading ? null : _login,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF0D63D1),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}