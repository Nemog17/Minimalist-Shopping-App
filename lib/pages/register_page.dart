import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../components/app_header.dart';
import '../cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _street = TextEditingController();
  String _province = '';
  String _city = '';
  final Map<String, List<String>> _provinces = const {
    'Distrito Nacional': ['Distrito Nacional'],
    'Santo Domingo': ['Santo Domingo Este', 'Santo Domingo Norte', 'Santo Domingo Oeste'],
    'Santiago': ['Santiago de los Caballeros'],
    'La Vega': ['La Vega', 'Constanza'],
  };
  String? _error;

  void _submit() {
    final auth = context.read<AuthCubit>();
    final success = auth.register(
      email: _email.text,
      username: _username.text,
      password: _password.text,
      name: _name.text,
      phone: _phone.text,
      street: _street.text,
      province: _province,
      city: _city,
    );
    if (success) {
      context.push('/home');
    } else {
      setState(() => _error = 'El correo ya está en uso');
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _name.dispose();
    _phone.dispose();
    _street.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Registrarse', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Nombre de usuario'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _street,
              decoration: const InputDecoration(labelText: 'Calle'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _province.isEmpty ? null : _province,
              decoration: const InputDecoration(labelText: 'Provincia'),
              items: _provinces.keys
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _province = value ?? '';
                  _city = '';
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _city.isEmpty ? null : _city,
              decoration: const InputDecoration(labelText: 'Ciudad'),
              items: (_provinces[_province] ?? [])
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _city = value ?? ''),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
