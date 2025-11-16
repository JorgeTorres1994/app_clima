import 'package:flutter/material.dart';

IconData iconForWeatherCode(int code) {
  // Referencia rápida (simplificada)
  if (code == 0) return Icons.wb_sunny_rounded;              // despejado
  if ({1,2,3}.contains(code)) return Icons.wb_cloudy_rounded; // pocas a nubes
  if ({45,48}.contains(code)) return Icons.foggy;             // niebla
  if ({51,53,55,56,57}.contains(code)) return Icons.grain;    // llovizna
  if ({61,63,65,66,67}.contains(code)) return Icons.beach_access; // lluvia
  if ({71,73,75,77}.contains(code)) return Icons.ac_unit;     // nieve
  if ({80,81,82}.contains(code)) return Icons.grain;          // chubascos
  if ({85,86}.contains(code)) return Icons.ac_unit;           // chubascos de nieve
  if ({95,96,99}.contains(code)) return Icons.thunderstorm;   // tormenta (posible granizo)
  return Icons.wb_cloudy_rounded;
}
