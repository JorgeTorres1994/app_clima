import 'package:app_clima/core/utils/temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/weather_providers.dart';
import '../../../weather/domain/entities/forecast.dart';
import '../../../weather/domain/entities/weather.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherByCityProvider);
    final forecastAsync = ref.watch(forecastByCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Perú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentWeatherByCityProvider);
          ref.invalidate(forecastByCityProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            weatherAsync.when(
              data: (w) => _CurrentCard(w),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => _ErrorBox(e.toString()),
            ),
            const SizedBox(height: 16),
            forecastAsync.when(
              data: (f) => _ForecastSection(f),
              loading: () => const SizedBox.shrink(),
              error: (e, _) => _ErrorBox(e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentCard extends StatelessWidget {
  final Weather w;
  const _CurrentCard(this.w);

  @override
  Widget build(BuildContext context) {
    final tempC = w.temp;
    final tempF = cToF(tempC);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(w.locationName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            // ← aquí mostramos C y F juntos
            Text(
              '${tempC.toStringAsFixed(0)}°C  |  ${tempF.toStringAsFixed(0)}°F',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(w.condition, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              children: [
                _Metric('Viento', '${w.windKph.toStringAsFixed(0)} km/h'),
                _Metric('Humedad', '${w.humidity.toStringAsFixed(0)}%'),
                _Metric(
                  'Act.',
                  w.updatedAt.toLocal().toString().substring(11, 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ForecastSection extends StatelessWidget {
  final Forecast f;
  const _ForecastSection(this.f);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Próximos días', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...f.daily.take(5).map((d) {
          final minC = d.min;
          final maxC = d.max;
          double cToF(double c) => (c * 9 / 5) + 32;
          final minF = cToF(minC);
          final maxF = cToF(maxC);

          return ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text('${d.date.toLocal().toString().substring(0, 10)}'),
            // C y F lado a lado (dos líneas)
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${minC.toStringAsFixed(0)}°C / ${maxC.toStringAsFixed(0)}°C',
                ),
                Text(
                  '${minF.toStringAsFixed(0)}°F / ${maxF.toStringAsFixed(0)}°F',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String msg;
  const _ErrorBox(this.msg);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text('Error: $msg'),
      ),
    );
  }
}
