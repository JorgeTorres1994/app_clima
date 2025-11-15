// lib/features/weather/presentation/pages/home_page.dart
import 'package:app_clima/features/weather/settings/application/settings_providers.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../controllers/weather_providers.dart';

/// Helpers locales
double _cToF(double c) => (c * 9 / 5) + 32;

LinearGradient _gradientFor(String condition) {
  final c = condition.toLowerCase();
  if (c.contains('rain') || c.contains('lluv')) {
    return const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF93C5FD)]);
  } else if (c.contains('storm') || c.contains('torment')) {
    return const LinearGradient(colors: [Color(0xFF312E81), Color(0xFF4338CA)]);
  } else if (c.contains('cloud') || c.contains('nubl')) {
    return const LinearGradient(colors: [Color(0xFF64748B), Color(0xFF94A3B8)]);
  }
  return const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)]);
}

class _ShimmerBox extends StatelessWidget {
  final double height, width;
  const _ShimmerBox({required this.height, required this.width});
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.surfaceVariant.withOpacity(.38);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final weatherAsync = ref.watch(currentWeatherByCityProvider);
    final forecastAsync = ref.watch(forecastByCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.home_title),
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
              loading: () => const _CurrentCardSkeleton(),
              error: (e, _) => _ErrorBox(e.toString()),
              data: (w) => _CurrentCard(w),
            ),
            const SizedBox(height: 24),
            forecastAsync.when(
              loading: () => const _ForecastSkeleton(),
              error: (e, _) => _ErrorBox(e.toString()),
              data: (f) => _ForecastSection(f),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== Current card ===================
class _CurrentCard extends ConsumerWidget {
  final Weather w;
  const _CurrentCard(this.w);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    // Título: prioriza el nombre de la entidad (ya mapeado), si no toma el seleccionado
    final sel = ref.watch(selectedCityProvider);
    /*final cityTitle = (w.locationName.isNotEmpty)
        ? w.locationName
        : (sel?.displayName ?? sel?.name ?? '—');*/
    final cityTitle = sel?.displayName ?? sel?.name ?? w.locationName;

    // Hora local usando utcOffsetSeconds del API
    final hourFmt = ref.watch(settingsProvider.select((s) => s.hourFormat));
    final localNow = DateTime.now().toUtc().add(
      Duration(seconds: w.utcOffsetSeconds),
    );
    final timeStr = (hourFmt == HourFormat.h)
        ? DateFormat('HH:mm').format(localNow)
        : DateFormat('h:mm a').format(localNow);

    final tempC = w.temp;
    final tempF = _cToF(tempC);

    return Container(
      decoration: BoxDecoration(
        gradient: _gradientFor(w.condition),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: DefaultTextStyle(
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*Text(
              cityTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),*/
            Text(
              cityTitle, // 👈 ahora verás "Iquitos, PE", "Cusco, PE", etc.
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${tempC.toStringAsFixed(0)}°C  |  ${tempF.toStringAsFixed(0)}°F',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Colors.white,
                letterSpacing: -1,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 8,
              children: [
                _Metric(
                  label: t.home_wind,
                  value: '${w.windKph.toStringAsFixed(0)} km/h',
                ),
                _Metric(
                  label: t.home_humidity,
                  value: '${w.humidity.toStringAsFixed(0)}%',
                ),
                _Metric(
                  label: t.home_updated_short,
                  value: timeStr,
                ), // hora local
              ],
            ),
            const SizedBox(height: 8),
            if (w.condition.isNotEmpty)
              Chip(
                label: Text(w.condition),
                backgroundColor: Colors.white.withOpacity(.18),
                side: BorderSide.none,
                labelStyle: const TextStyle(color: Colors.white),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label, value;
  const _Metric({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _CurrentCardSkeleton extends StatelessWidget {
  const _CurrentCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            _ShimmerBox(height: 18, width: 160),
            SizedBox(height: 12),
            _ShimmerBox(height: 56, width: 240),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ShimmerBox(height: 14, width: 80),
                SizedBox(width: 16),
                _ShimmerBox(height: 14, width: 80),
                SizedBox(width: 16),
                _ShimmerBox(height: 14, width: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =================== Forecast ===================
class _ForecastSection extends StatelessWidget {
  final Forecast f;
  const _ForecastSection(this.f);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.home_next_days, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: f.daily.take(5).map((d) {
              final minC = d.min, maxC = d.max;
              final minF = _cToF(minC), maxF = _cToF(maxC);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: const Icon(Icons.calendar_today, size: 18),
                ),
                title: Text('${d.date.toLocal().toString().substring(0, 10)}'),
                subtitle: Text(
                  '${minF.toStringAsFixed(0)}°F / ${maxF.toStringAsFixed(0)}°F',
                ),
                trailing: Text(
                  '${minC.toStringAsFixed(0)}°C / ${maxC.toStringAsFixed(0)}°C',
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ForecastSkeleton extends StatelessWidget {
  const _ForecastSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ShimmerBox(height: 20, width: 140),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: List.generate(
                5,
                (i) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      _ShimmerBox(height: 40, width: 40),
                      SizedBox(width: 12),
                      Expanded(
                        child: _ShimmerBox(height: 16, width: double.infinity),
                      ),
                      SizedBox(width: 12),
                      _ShimmerBox(height: 16, width: 90),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =================== Error ===================
class _ErrorBox extends StatelessWidget {
  final String msg;
  const _ErrorBox(this.msg);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: cs.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ups: $msg',
                style: TextStyle(color: cs.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
