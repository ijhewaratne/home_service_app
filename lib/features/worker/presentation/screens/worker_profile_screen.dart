import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/worker_viewmodel.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WorkerViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: vm.profile == null 
        ? const Center(child: Text('No Profile Data'))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${vm.profile!.name}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('District: ${vm.profile!.district}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Services: ${vm.profile!.serviceTypes.join(', ')}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to an edit form in real app
                  },
                  child: const Text('Edit Profile'),
                )
              ],
            ),
        ),
    );
  }
}
