import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkerMatchingPage extends StatefulWidget {
  const WorkerMatchingPage({super.key});

  @override
  State<WorkerMatchingPage> createState() => _WorkerMatchingPageState();
}

class _WorkerMatchingPageState extends State<WorkerMatchingPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _searchStage = 0; // 0: Searching, 1: Formatting Top 3, 2: Found

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.fastOutSlowIn,
    ));

    _simulateDispatchEngine();
  }

  void _simulateDispatchEngine() async {
    // Stage 1: Radius calculation
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _searchStage = 1);
    
    // Stage 2: PickMe Matching Algorithm Top 3 broadcast
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _searchStage = 2);

    // Stage 3: Worker Accept -> Route to Live Tracking
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // context.go('/customer/tracking');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _currentStatusText {
    switch (_searchStage) {
      case 0: return 'Querying active zones...';
      case 1: return 'Scoring & dispatching to top candidates...';
      case 2: return 'Worker identified! Awaiting acknowledgment...';
      default: return 'Matching...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () {
            // Cancel booking request
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Animated Pulse Rings
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 250 * _pulseAnimation.value,
                      height: 250 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo.withValues(alpha: (1.0 - _pulseAnimation.value) * 0.3),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 150 * _pulseAnimation.value,
                      height: 150 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo.withValues(alpha: (1.0 - _pulseAnimation.value) * 0.5),
                      ),
                    );
                  },
                ),
                // Static Center Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 40),
                ),
              ],
            ),
            const SizedBox(height: 64),
            Text(
              'Finding your Helper',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _currentStatusText,
                key: ValueKey<int>(_searchStage),
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
