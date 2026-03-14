import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../../../shared/ui/branded_widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  void _handleVerify() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid 6-digit OTP')));
      return;
    }

    final vm = context.read<AuthViewModel>();
    await vm.verifyOtp(otp);

    if (vm.errorMessage == null && context.mounted) {
      if (vm.currentUser?.role == null || vm.currentUser!.role.isEmpty) {
        context.go('/role-select');
      } else if (vm.currentUser!.role == 'customer') {
        context.go('/customer');
      } else if (vm.currentUser!.role == 'worker') {
        context.go('/worker');
      } else {
        context.go('/admin');
      }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Icon(
                  Icons.lock_person_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
              ),
              const SizedBox(height: 30),
              Text(
                'Enter Verification Code',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              const SizedBox(height: 10),
              Text(
                'We sent a 6-digit code to your phone.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 40),
              
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '000000',
                  counterText: '',
                ),
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.05),
              
              const SizedBox(height: 32),
              vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : BrandedButton(
                      label: 'Verify & Proceed',
                      onPressed: _handleVerify,
                    ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.9, 0.9)),
            ],
          ),
        ),
      ),
    );
  }
}
