import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/auth_state.dart';
import '../../data/datasources/auth_firebase_datasource.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthFirebaseDatasource _datasource;

  AuthController(this._datasource) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final user = await _datasource.login(email, password);
      if (!user.isActive) {
        state = AuthError('Tu cuenta esta desactivada. Contacta al administrador.');
        return;
      }
      state = AuthAuthenticated(user);
    } on Exception catch (e) {
      state = AuthError(_mapError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _datasource.logout();
    state = AuthInitial();
  }

  String _mapError(String error) {
    if (error.contains('user-not-found')) {
      return 'No existe una cuenta con ese email';
    }
    if (error.contains('wrong-password') || error.contains('invalid-credential')) {
      return 'Password incorrecta';
    }
    if (error.contains('invalid-email')) {
      return 'Email invalido';
    }
    if (error.contains('network-request-failed')) {
      return 'Sin conexion a internet';
    }
    return 'Error al iniciar sesion. Intenta de nuevo.';
  }
}
