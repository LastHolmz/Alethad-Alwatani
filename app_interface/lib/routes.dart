import 'package:animations/animations.dart';
import 'package:e_commerce/common/widgets/wrapper.dart';
import 'package:e_commerce/screens/auth/login.dart';
import 'package:e_commerce/screens/auth/sign_up.dart';
import 'package:e_commerce/screens/cart/cart_screen.dart';
import 'package:e_commerce/screens/category/category_screen.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/screens/orders/%5Bid%5D/order_details.dart';
import 'package:e_commerce/screens/orders/new_order/new_order.dart';
import 'package:e_commerce/screens/orders/orders_screen.dart';
import 'package:e_commerce/screens/products/%5Bid%5D/product_details.dart';
import 'package:e_commerce/screens/products/products_screen.dart';
import 'package:e_commerce/screens/welcome/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  AppNavigation._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _rootNavigatorCart =
      GlobalKey<NavigatorState>(debugLabel: 'shellCart');
  static final _rootNavigatorBills =
      GlobalKey<NavigatorState>(debugLabel: 'shellBills');
  // static final _rootNavigatorProfile =
  //     GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

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
      GoRoute(
        path: '/categories/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']; // Get "id" param from URL
          return CategoryScreen(id: id);
        },
      ),
      GoRoute(
        path: '/orders/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']; // Get "id" param from URL
          return OrderDetails(id: id);
        },
      ),
      GoRoute(
        path: SingUpScreen.path,
        builder: (context, state) {
          return SingUpScreen();
        },
      ),
      GoRoute(
        path: LoginScreen.path,
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: WelcomeScreen.path,
        builder: (context, state) {
          return WelcomeScreen();
        },
      ),
      GoRoute(
        path: NewOrderScreen.path,
        builder: (context, state) {
          return const NewOrderScreen();
        },
      ),
      // GoRoute(
      //   name: ProductsScreen.name,
      //   path: ProductsScreen.path,
      //   builder: (context, state) => ProductsScreen(key: state.pageKey),
      // ),

      routeBaseSlideAnimatedSearchProducts(),

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
                name: OrdersScreen.name,
                path: OrdersScreen.path,
                builder: (context, state) => OrdersScreen(key: state.pageKey),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _rootNavigatorCart,
            routes: [
              GoRoute(
                name: CartScreen.name,
                path: CartScreen.path,
                builder: (context, state) => CartScreen(
                  key: state.pageKey,
                ),
              )
              //   pageBuilder: (context, state) =>
              //       MaterialPage(child: const CartScreen(), key: UniqueKey()),
              // ),

              // builder: (context, state) => CartScreen(key: UniqueKey()),
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

RouteBase routeBaseSlideAnimatedSearchProducts() {
  return GoRoute(
    path: '/products',
    pageBuilder: (BuildContext context, GoRouterState state) {
      final data = state.extra as Map<String, dynamic>?;
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: ProductsScreen(
          brandId: data?["brandId"],
          categoryId: data?["categoryId"],
          title: data?['title'],
        ),
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeScaleTransition(
            animation: animation.drive(Tween(begin: 0, end: 1)),
            // position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  );
}
