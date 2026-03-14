import 'package:go_router/go_router.dart';
import '../../features/customer/presentation/screens/customer_home_screen.dart';
import '../../features/customer/presentation/screens/service_selection_screen.dart';
import '../../features/customer/presentation/screens/booking_form_screen.dart';
import '../../features/customer/presentation/screens/booking_summary_screen.dart';
import '../../features/worker/presentation/screens/worker_home_screen.dart';
import '../../features/worker/presentation/screens/worker_profile_screen.dart';
import '../../features/worker/presentation/screens/worker_documents_screen.dart';
import '../../features/worker/presentation/screens/worker_availability_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_workers_screen.dart';
import '../../features/admin/presentation/screens/admin_bookings_screen.dart';
import '../../features/admin/presentation/screens/admin_incidents_screen.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/role_select_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/role-select',
      builder: (context, state) => const RoleSelectScreen(),
    ),
    GoRoute(
      path: '/customer',
      builder: (context, state) => const CustomerHomeScreen(),
    ),
    GoRoute(
      path: '/customer/book',
      builder: (context, state) => const ServiceSelectionScreen(),
    ),
    GoRoute(
      path: '/customer/book/form',
      builder: (context, state) => const BookingFormScreen(),
    ),
    GoRoute(
      path: '/customer/book/summary',
      builder: (context, state) => const BookingSummaryScreen(),
    ),
    GoRoute(
      path: '/worker',
      builder: (context, state) => const WorkerHomeScreen(),
    ),
    GoRoute(
      path: '/worker/profile',
      builder: (context, state) => const WorkerProfileScreen(),
    ),
    GoRoute(
      path: '/worker/documents',
      builder: (context, state) => const WorkerDocumentsScreen(),
    ),
    GoRoute(
      path: '/worker/availability',
      builder: (context, state) => const WorkerAvailabilityScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/workers',
      builder: (context, state) => const AdminWorkersScreen(),
    ),
    GoRoute(
      path: '/admin/bookings',
      builder: (context, state) => const AdminBookingsScreen(),
    ),
    GoRoute(
      path: '/admin/incidents',
      builder: (context, state) => const AdminIncidentsScreen(),
    ),
  ],
);
