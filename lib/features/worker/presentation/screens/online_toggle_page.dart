import 'package:flutter/material.dart';

class OnlineTogglePage extends StatefulWidget {
  const OnlineTogglePage({super.key});

  @override
  State<OnlineTogglePage> createState() => _OnlineTogglePageState();
}

class _OnlineTogglePageState extends State<OnlineTogglePage> {
  bool _isOnline = false;
  bool _isInApprovedZone = true; // Simulating Geolocator + ColomboZones check
  
  void _toggleStatus() async {
    // 1. Fetch live GPS via LocationService
    // 2. Check overlap with ColomboZones.allActiveZones
    
    // Simulating a Geofence violation check based on UI state
    if (!_isInApprovedZone && !_isOnline) {
      _showGeofenceError();
      return;
    }

    setState(() {
      _isOnline = !_isOnline;
    });

    // 3. Dispatch new status to WorkerViewModel / Repository
  }

  void _showGeofenceError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Out of Service Area'),
        content: const Text('You currently appear to be outside the authorized Colombo Launch Zones (e.g. Zone A, Zone B). You cannot accept jobs until you enter an active zone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Understood'))
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isOnline ? Colors.indigo.shade50 : Colors.white,
      appBar: AppBar(
        title: const Text('Dispatch Dashboard'),
        actions: [
          // Developer mock toggle
          IconButton(
            icon: Icon(_isInApprovedZone ? Icons.gps_fixed : Icons.gps_off, color: _isInApprovedZone ? Colors.green : Colors.red),
            onPressed: () => setState(() => _isInApprovedZone = !_isInApprovedZone),
            tooltip: 'Mock GPS Zone (Dev Base)',
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isOnline ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isOnline ? 'YOU ARE ONLINE' : 'YOU ARE OFFLINE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isOnline ? Colors.green.shade800 : Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 48),
            
            // Big Toggle Button
            GestureDetector(
              onTap: _toggleStatus,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isOnline ? Colors.green : Colors.indigo,
                  boxShadow: [
                    BoxShadow(
                      color: (_isOnline ? Colors.green : Colors.indigo).withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    )
                  ]
                ),
                child: Center(
                  child: Text(
                    _isOnline ? 'GO\nOFFLINE' : 'GO\nONLINE',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            if (_isOnline)
              const Text(
                'Waiting for incoming jobs...',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            else
              Text(
                _isInApprovedZone 
                  ? 'Tap to start receiving job requests'
                  : 'Move to a launch zone to go online',
                style: TextStyle(color: _isInApprovedZone ? Colors.grey : Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
