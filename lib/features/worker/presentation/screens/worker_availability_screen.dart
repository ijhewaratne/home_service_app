import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/worker_viewmodel.dart';

class WorkerAvailabilityScreen extends StatelessWidget {
  const WorkerAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WorkerViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Availability')),
      body: vm.profile == null
          ? const Center(child: Text('Profile not loaded'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Available for work'),
                    subtitle: Text(
                      vm.profile!.isAvailable ? 'You can receive bookings' : 'You are offline',
                    ),
                    value: vm.profile!.isAvailable,
                    onChanged: vm.isLoading
                        ? null
                        : (bool value) {
                            context.read<WorkerViewModel>().toggleAvailability(value);
                          },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Availability Mode'),
                    trailing: DropdownButton<String>(
                      value: vm.profile!.availabilityMode,
                      items: const [
                        DropdownMenuItem(value: 'part_time', child: Text('Part Time')),
                        DropdownMenuItem(value: 'full_time', child: Text('Full Time')),
                      ],
                      onChanged: (String? newValue) {
                        // Normally this would trigger another update call in ViewModel
                      },
                    ),
                  ),
                  if (vm.isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
    );
  }
}
