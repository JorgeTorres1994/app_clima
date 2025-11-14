import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Unidades (°C/°F)')),
          ListTile(title: Text('Formato hora (12/24h)')),
          ListTile(title: Text('Tema (claro/oscuro/sistema)')),
          ListTile(title: Text('Idioma')),
        ],
      ),
    );
  }
}
