// lib/features/weather/presentation/widgets/home/forecast_section.dart
import 'package:app_clima/features/weather/domain/entities/forecast.dart';
import 'package:app_clima/features/weather/presentation/utils/weather_ui.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ForecastSection extends StatelessWidget {
  final Forecast f;
  const ForecastSection({super.key, required this.f});

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
              final minF = cToF(minC), maxF = cToF(maxC);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: const Icon(Icons.calendar_today, size: 18),
                ),
                title: Text('${d.date.toLocal().toString().substring(0, 10)}'),
                subtitle: Text('${minF.toStringAsFixed(0)}°F / ${maxF.toStringAsFixed(0)}°F'),
                trailing: Text('${minC.toStringAsFixed(0)}°C / ${maxC.toStringAsFixed(0)}°C'),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
