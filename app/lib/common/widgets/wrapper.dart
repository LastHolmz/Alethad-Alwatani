import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int selectedIndex = 0;
  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: widget.navigationShell,
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            _goToBranch(selectedIndex);
          },
          // indicatorColor: Colors.amber,
          selectedIndex: selectedIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.description_outlined)),
              label: 'الفواتير',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_3_outlined),
              label: 'البروفايل',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text('2'),
                child: Icon(Icons.shopping_cart_outlined),
              ),
              label: 'السلة',
            ),
          ],
        ),
      ),
    );
  }
}
