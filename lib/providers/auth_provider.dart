import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, BuildContext context) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/notes');
      _setError(null);
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Sign up failed')));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login(String email, String password, BuildContext context) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/notes');
      _setError(null);
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
