import 'package:flutter/material.dart';
import '../../presentation/screens/welcome_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/property_catalog_screen.dart';

class AppRouter {
  // Route names
  static const String welcomeScreen = '/';
  static const String homeScreen = '/home';
  static const String catalogScreen = '/catalog';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeScreen:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
        
      case homeScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final animate = args?['animate'] as bool? ?? false;
        
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            HomeScreen(animate: animate),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (animate) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              
              var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));
                
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            } else {
              return child;
            }
          },
        );
        
      case catalogScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final animate = args?['animate'] as bool? ?? false;
        
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            PropertyCatalogScreen(animate: animate),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (animate) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              
              var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));
                
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            } else {
              return child;
            }
          },
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}