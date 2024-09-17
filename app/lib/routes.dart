import 'package:e_commerce/screens/home/index.dart';
import 'package:e_commerce/screens/products/id/index.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: HomeScreen
          .name, // Optional, add name to your routes. Allows you navigate by name instead of path
      path: HomeScreen.path,
      builder: (context, state) => const HomeScreen(),
    ),
    // GoRoute(
    //     name: 'page2',
    //     path: '/page2',
    //     builder: (context, state) => Page2Screen(),
    //   ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']; // Get "id" param from URL
        return ProductDetails(id: id);
      },
    )
  ],
);
