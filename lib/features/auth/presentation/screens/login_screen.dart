import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../../../shared/ui/branded_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  void _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a phone number')));
      return;
    }

    final vm = context.read<AuthViewModel>();
    await vm.sendOtp(phone);
    if (vm.errorMessage == null && context.mounted) {
      context.push('/otp');
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // Hero Graphic Area
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.home_repair_service_rounded,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              ),
              const SizedBox(height: 40),
              Text(
                'Welcome to Servix',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              const SizedBox(height: 10),
              Text(
                'Premium home care, trusted & verified.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 50),
              
              // Input Segment
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+94 7X XXX XXXX',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.05),
              
              const SizedBox(height: 24),
              vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : BrandedButton(
                      label: 'Send OTP',
                      onPressed: _handleSendOtp,
                    ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.9, 0.9)),
            ],
          ),
        ),
      ),
    );
  }
}
