import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 0;
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
        bottomNavigationBar: FlashyTabBar(
          selectedIndex: _selectedIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            setState(() {
              _selectedIndex = index;
            });
            _goToBranch(_selectedIndex);
          }),
          items: [
            FlashyTabBarItem(
              icon: const Icon(Icons.home_outlined),
              title: const Text('الرئيسية'),
            ),
            FlashyTabBarItem(
              icon: const Icon(Icons.search),
              title: const Text('البحث'),
            ),
            FlashyTabBarItem(
              icon: const Badge(child: Icon(Icons.description_outlined)),
              title: const Text('الفواتير'),
            ),
            // FlashyTabBarItem(
            //   icon: const Icon(Icons.person_3_outlined),
            //   title: const Text('البروفايل'),
            // ),

            FlashyTabBarItem(
              icon: const Badge(
                label: const Text('2'),
                child: Icon(Icons.shopping_cart_outlined),
              ),
              title: const Text('السلة'),
            ),
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: widget.navigationShell,
        ),
      ),
    );
  }
}

/* 


  bottomNavigationBar:
         NavigationBar(
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
 */
