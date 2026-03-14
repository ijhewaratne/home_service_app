import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/worker_viewmodel.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';

class WorkerDocumentsScreen extends StatelessWidget {
  const WorkerDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WorkerViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Documents')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (vm.documentStatus != null)
              Text('Document Verification: ${vm.documentStatus!.status.toUpperCase()}'),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Upload NIC (Front)'),
              trailing: const Icon(Icons.camera_alt),
              onTap: () {
                final user = context.read<AuthViewModel>().currentUser;
                if (user != null) {
                  // Simulate picking a file and uploading
                  context.read<WorkerViewModel>().uploadDocument(user.uid, 'nic_front', '/mock/path.jpg');
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Upload Selfie'),
              trailing: const Icon(Icons.camera_alt),
              onTap: () {
                // Simulate picking a file and uploading
              },
            ),
            const Divider(),
            if (vm.isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
