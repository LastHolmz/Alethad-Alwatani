import 'package:e_commerce/providers/cart_provider.dart';
import 'package:e_commerce/providers/orders_provider.dart';
import 'package:e_commerce/providers/products_provider.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/providers/vistits_provider.dart';
import 'package:e_commerce/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VisitProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BrandsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () async => await context.read<CartProvider>().fetchAtFirst(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // de
      title: 'e-commerce',
      // debugShowCheckedModeBanner: false,
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 5, 244, 240)),
        useMaterial3: true,
      ),
      routerConfig: AppNavigation.router,
    );
  }
}
