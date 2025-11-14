import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/weather_providers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  List<dynamic> _cities = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/data/peru_cities.json');
    setState(() => _cities = jsonDecode(raw) as List<dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _cities.where((c) {
      if (_query.isEmpty) return true;
      return (c['name'] as String).toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar ciudad (Perú)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ej. Lima, Cusco, Piura…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (q) => setState(() => _query = q),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final c = filtered[i];
                return ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: Text('${c['name']}'),
                  subtitle: Text('lat ${c['lat']}, lon ${c['lon']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref
                        .read(selectedCityProvider.notifier)
                        .state = CitySelection(
                      c['name'],
                      (c['lat'] as num).toDouble(),
                      (c['lon'] as num).toDouble(),
                    );
                    ref.invalidate(currentWeatherByCityProvider);
                    ref.invalidate(forecastByCityProvider);
                    context.pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
