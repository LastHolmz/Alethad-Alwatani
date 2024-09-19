import 'package:e_commerce/providers/cart/index.dart';
import 'package:e_commerce/providers/products/index.dart';
import 'package:e_commerce/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
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
    Future.microtask(() => context.read<CartProvider>().fetchAtFirst());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // de
      title: 'e-commerce',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      routerConfig: AppNavigation.router,
    );
  }
}
