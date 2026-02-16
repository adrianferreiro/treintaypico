import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user_entity.dart';

class AuthFirebaseDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUserEntity> login(String email, String password) async {
    // 1. Autenticar con Firebase Auth
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // 2. Buscar datos del usuario en Firestore
    final userDoc = await _firestore
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .get();

    if (userDoc.docs.isEmpty) {
      throw Exception('Usuario no encontrado en Firestore');
    }

    final data = userDoc.docs.first.data();

    // 3. Convertir el string de role al enum
    final role = UserRole.values.firstWhere(
      (r) => r.name == data['role'],
      orElse: () => UserRole.client,
    );

    // 4. Devolver la entidad
    return AppUserEntity(
      id: uid,
      email: data['email'] ?? email,
      name: data['name'] ?? '',
      role: role,
      companyId: data['companyId'],
      venueId: data['venueId'],
      isActive: data['isActive'] ?? true,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // Verificar si hay sesion activa
  User? get currentUser => _auth.currentUser;
}