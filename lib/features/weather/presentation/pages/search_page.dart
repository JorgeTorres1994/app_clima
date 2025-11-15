import 'dart:async';
import 'dart:convert';
import 'package:app_clima/l10n/app_localizations.dart';
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
  Timer? _deb;

  // Sugerencias rápidas (puedes editar esta lista)
  final List<Map<String, dynamic>> _quick = const [
    {"name": "Lima", "lat": -12.0464, "lon": -77.0428},
    {"name": "Cusco", "lat": -13.5167, "lon": -71.9780},
    {"name": "Arequipa", "lat": -16.3989, "lon": -71.5350},
    {"name": "Piura", "lat": -5.1945, "lon": -80.6328},
    {"name": "Trujillo", "lat": -8.1117, "lon": -79.0288},
  ];

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
  void dispose() {
    _deb?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filter(_cities, _query);

    return Scaffold(
      //appBar: AppBar(title: const Text('Buscar ciudad (Perú)')),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.search_title)),
      body: Column(
        children: [
          // Barra de búsqueda con estilo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  //hintText: 'Ej. Lima, Cusco, Piura…',
                  hintText: AppLocalizations.of(context)!.search_hint,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Limpiar',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
                onChanged: (q) {
                  _deb?.cancel();
                  _deb = Timer(const Duration(milliseconds: 350), () {
                    setState(() => _query = q.trim());
                  });
                },
                onSubmitted: (q) => setState(() => _query = q.trim()),
              ),
            ),
          ),

          // Chips de sugerencias (solo cuando no hay query)
          if (_query.isEmpty)
            _SuggestionChips(
              quick: _quick,
              onPick: (city) {
                _controller.text = city['name'] as String;
                setState(() => _query = city['name'] as String);
              },
            ),

          // Resultados
          Expanded(
            child: results.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final c = results[i];
                      final name = c['name'] as String;
                      final lat = (c['lat'] as num).toDouble();
                      final lon = (c['lon'] as num).toDouble();

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: const Icon(Icons.place_outlined, size: 18),
                        ),
                        title: _Highlighted(text: name, query: _query),
                        subtitle: Text(
                          'lat ${lat.toStringAsFixed(4)}, lon ${lon.toStringAsFixed(4)}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        /*onTap: () {
                          ref.read(selectedCityProvider.notifier).state =
                              CitySelection(name, lat, lon);
                          ref.invalidate(currentWeatherByCityProvider);
                          ref.invalidate(forecastByCityProvider);
                          context.pop();
                        },*/
                        onTap: () {
                          final name = c['name'] as String;
                          final lat = (c['lat'] as num).toDouble();
                          final lon = (c['lon'] as num).toDouble();

                          /*ref
                              .read(selectedCityProvider.notifier)
                              .state = CitySelection(
                            name,
                            lat,
                            lon,
                            display: '$name, PE',
                          );*/
                          ref
                              .read(selectedCityProvider.notifier)
                              .state = CitySelection(
                            name,
                            lat,
                            lon,
                            display: '$name, PE',
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

  // --- Helpers ---
  List<Map<String, dynamic>> _filter(List<dynamic> list, String q) {
    final items = list.cast<Map<String, dynamic>>();
    if (q.isEmpty) return items;
    final qq = q.toLowerCase();
    return items
        .where((c) => (c['name'] as String).toLowerCase().contains(qq))
        .toList();
  }
}

// Chips de sugerencias rápidas
class _SuggestionChips extends StatelessWidget {
  final List<Map<String, dynamic>> quick;
  final void Function(Map<String, dynamic>) onPick;
  const _SuggestionChips({required this.quick, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: quick.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = quick[i];
          return ActionChip(
            label: Text(c['name'] as String),
            onPressed: () => onPick(c),
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}

// Resaltado de coincidencias en el nombre
class _Highlighted extends StatelessWidget {
  final String text;
  final String query;
  const _Highlighted({required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text);

    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    final start = lower.indexOf(q);
    if (start < 0) return Text(text);

    final end = start + q.length;
    final before = text.substring(0, start);
    final match = text.substring(start, end);
    final after = text.substring(end);

    final cs = Theme.of(context).colorScheme;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: before),
          TextSpan(
            text: match,
            style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}

// Estado vacío elegante
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 56, color: cs.outline),
            const SizedBox(height: 8),
            //const Text('Sin resultados'),
            Text(AppLocalizations.of(context)!.search_empty_title),
            const SizedBox(height: 4),
            /*Text(
              'Prueba con otra ciudad o revisa las sugerencias.',
              style: TextStyle(color: cs.outline),
            ),*/
            Text(
              AppLocalizations.of(context)!.search_empty_sub,
              style: TextStyle(color: cs.outline),
            ),
          ],
        ),
      ),
    );
  }
}
