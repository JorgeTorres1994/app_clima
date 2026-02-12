import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CityMapPreview extends StatefulWidget {
  final String title;
  final double lat;
  final double lon;
  final String condition;
  final double tempC;

  const CityMapPreview({
    super.key,
    required this.title,
    required this.lat,
    required this.lon,
    required this.condition,
    required this.tempC,
  });

  @override
  State<CityMapPreview> createState() => _CityMapPreviewState();
}

class _CityMapPreviewState extends State<CityMapPreview> {
  final _map = MapController();

  void _zoomBy(double delta) {
    final cam = _map.camera;
    final target = (cam.zoom + delta).clamp(5.0, 16.0);
    _map.move(cam.center, target);
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(widget.lat, widget.lon);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 230,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 12.0,
                minZoom: 5.0,
                maxZoom: 16.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.tuapp.clima',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 46,
                      height: 46,
                      child: const Icon(Icons.place, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),

            // ✅ Botones zoom (paso fino)
            Positioned(
              right: 10,
              bottom: 42,
              child: Column(
                children: [
                  _ZoomBtn(icon: Icons.add, onTap: () => _zoomBy(0.6)),
                  const SizedBox(height: 8),
                  _ZoomBtn(icon: Icons.remove, onTap: () => _zoomBy(-0.6)),
                ],
              ),
            ),

            // (Mantén aquí tus overlays/badges/attribution)
          ],
        ),
      ),
    );
  }
}

class _ZoomBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.45),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

