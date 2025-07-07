import 'package:cally_app/home/screens/home_screen.dart';
import 'package:cally_app/home/screens/onboarding_screen.dart';
import 'package:cally_app/home/screens/testlist_screen.dart';
import 'package:go_router/go_router.dart';
import '../../authentication/screens/language_screem.dart';
import '../../authentication/screens/register_screen.dart';
import '../../authentication/screens/login_screen.dart';
import '../../authentication/screens/otp_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/language', //temparari onbording , permanant /language
  routes: [
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final phoneNumber = extra?['phoneNumber'] ?? '';
        final email = extra?['email'] ?? '';
        return OtpVerificationScreen(phoneNumber: phoneNumber, email: email);
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/testlist',
      builder: (context, state) => const TestListScreen(),
    ),

    // ...other routes...
  ],
);
