import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/app_header.dart';
import '../cubits/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  String _selectedProvince = '';
  String _selectedCity = '';
  final Map<String, List<String>> _provinces = const {
    'Distrito Nacional': ['Distrito Nacional'],
    'Santo Domingo': ['Santo Domingo Este', 'Santo Domingo Norte', 'Santo Domingo Oeste'],
    'Santiago': ['Santiago de los Caballeros'],
    'La Vega': ['La Vega', 'Constanza'],
  };
  
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _streetController = TextEditingController(text: user?.street ?? '');
    _selectedProvince = user?.province ?? '';
    _selectedCity = user?.city ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _save() {
    context.read<AuthCubit>().updateProfile(
      name: _nameController.text,
      phone: _phoneController.text,
      street: _streetController.text,
      province: _selectedProvince,
      city: _selectedCity,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dirección guardada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.currentUser;
    final orders = user?.orderHistory ?? [];

    return Scaffold(
      appBar: const AppHeader(title: 'Perfil', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: 'Calle'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedProvince.isEmpty ? null : _selectedProvince,
              decoration: const InputDecoration(labelText: 'Provincia'),
              items: _provinces.keys
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProvince = value ?? '';
                  _selectedCity = '';
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCity.isEmpty ? null : _selectedCity,
              decoration: const InputDecoration(labelText: 'Ciudad'),
              items: (_provinces[_selectedProvince] ?? [])
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCity = value ?? ''),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: 'República Dominicana',
              enabled: false,
              decoration: const InputDecoration(labelText: 'País'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: user?.email ?? '',
              enabled: false,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: user?.username ?? '',
              enabled: false,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Historial de compras',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ...orders.map(
              (p) => ListTile(
                title: Text(p.name),
                subtitle: Text('RD\$ ${p.price}'),
              ),
            ),
            if (orders.isEmpty)
              const Text('Aún no has realizado compras'),
          ],
        ),
      ),
    );
  }
}
