import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _supabase;

  UserService() : _supabase = Supabase.instance.client;

  Future<void> registerUser({
    required String nombre,
    required String email,
    required String password,
    required String role,
    String? adminCode,
  }) async {
    // Registrar usuario en Auth
    final AuthResponse authResponse = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'nombre': nombre,
        'rol': role,
      },
    );

    // Insertar información adicional
    await _supabase.from('usuarios').insert({
      'id': authResponse.user!.id,
      'email': email,
      'nombre': nombre,
      'rol': role,
      'fecha_registro': DateTime.now().toIso8601String(),
    });
  }
}
