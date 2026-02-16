import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../states/auth_state.dart';
import '../../data/datasources/auth_firebase_datasource.dart';

final authDatasourceProvider = Provider<AuthFirebaseDatasource>(
  (ref) => AuthFirebaseDatasource(),
);

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authDatasourceProvider)),
);
