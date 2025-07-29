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
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.currentUser;
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    context.read<AuthCubit>().updateAddress(_addressController.text);
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
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Dirección de envío'),
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
