import 'package:e_commerce/common/widgets/wrapper.dart';
import 'package:e_commerce/screens/bills/index.dart';
import 'package:e_commerce/screens/cart/index.dart';
import 'package:e_commerce/screens/home/index.dart';
import 'package:e_commerce/screens/products/id/index.dart';
import 'package:e_commerce/screens/profile/index.dart';
import 'package:flutter/cupertino.dart';
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

class AppNavigation {
  AppNavigation._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _rootNavigatorCart =
      GlobalKey<NavigatorState>(debugLabel: 'shellCart');
  static final _rootNavigatorBills =
      GlobalKey<NavigatorState>(debugLabel: 'shellBills');
  static final _rootNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

  static String initRoute = '/';

  static final GoRouter router = GoRouter(
    initialLocation: initRoute,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']; // Get "id" param from URL
          return ProductDetails(id: id);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Wrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _rootNavigatorHome,
            routes: [
              GoRoute(
                name: HomeScreen
                    .name, // Optional, add name to your routes. Allows you navigate by name instead of path
                path: HomeScreen.path,

                builder: (context, state) => HomeScreen(key: state.pageKey),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorBills,
            routes: [
              GoRoute(
                name: BillsSceen.name,
                path: BillsSceen.path,
                builder: (context, state) => BillsSceen(key: state.pageKey),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorProfile,
            routes: [
              GoRoute(
                name: ProfileSceen.name,
                path: ProfileSceen.path,
                builder: (context, state) => ProfileSceen(key: state.pageKey),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorCart,
            routes: [
              GoRoute(
                name: CartScreen.name,
                path: CartScreen.path,
                builder: (context, state) => CartScreen(key: state.pageKey),
              ),
            ],
          ),
          // StatefulShellBranch(
          //   navigatorKey: _rootNavigatorCart,
          //   routes: [
          //     GoRoute(
          //       path: '/products/:id',
          //       builder: (context, state) {
          //         final id =
          //             state.pathParameters['id']; // Get "id" param from URL
          //         return ProductDetails(id: id);
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    ],
  );
}
