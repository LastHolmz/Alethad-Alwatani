import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/providers/vistits_provider.dart';
import 'package:e_commerce/screens/auth/auth.dart';
import 'package:e_commerce/screens/welcome/welcome_screen.dart';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    Future.microtask(
      () async => context.read<UserProvider>().checkUser(context),
    );
    Future.microtask(() => context.read<VisitProvider>().runAtFirst());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VisitProvider>(
      builder: (context, value, child) {
        final bool isFirstVisit = value.firstVisit;
        return isFirstVisit
            ? WelcomeScreen()
            // return !isFirstVisit
            //     ? const Auth()
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  drawer: Drawer(
                    // Add a ListView to the drawer. This ensures the user can scroll
                    // through the options in the drawer if there isn't enough vertical
                    // space to fit everything.
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,

                      children: [
                        DrawerHeader(
                          decoration: const BoxDecoration(
                              // color: Colors.blue,
                              ),
                          child: Center(
                            child: Image.asset(
                              'assets/logo.png',
                              alignment: Alignment.centerLeft,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Consumer<UserProvider>(
                          builder: (context, value, child) {
                            final _isloding = value.isLoading;

                            return value.user != null
                                ? ListTile(
                                    title: const Text('تسجيل الخروج'),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return _isloding
                                              ? const AlertDialog(
                                                  content: SizedBox(
                                                    height: 100,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircularProgressIndicator
                                                            .adaptive(),
                                                        SizedBox(height: 20),
                                                        Text("جاري التحميل"),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : AlertDialog(
                                                  // titlePadding: EdgeInsets.all(),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                          child:
                                                              const Text('نعم'),
                                                          onPressed: () async {
                                                            value.setLodding(
                                                                true);
                                                            // await context
                                                            //     .read<UserProvider>()
                                                            //     .logout();
                                                            value.logout();
                                                            value.setLodding(
                                                                false);

                                                            // Navigator.of(context).pop();
                                                            context.pop();
                                                            Scaffold.of(context)
                                                                .closeDrawer();
                                                            // context.go(HomeScreen.path);
                                                          },
                                                        ),
                                                        TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                          child:
                                                              const Text('لا'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                  title: const Text(
                                                    "تسجيل الخروج",
                                                    textAlign: TextAlign.end,
                                                  ),
                                                  content: const Text(
                                                    "هل انت متأكد من تسجيل الخروج",
                                                    textAlign: TextAlign.end,
                                                  ),
                                                );
                                        },
                                      );
                                    },
                                  )
                                : ListTile(
                                    title: const Text("تسجيل الدخول"),
                                    onTap: () => context.go(Auth.path),
                                  );
                          },
                        ),
                        ListTile(
                          title: const Text('سياسة الخصوصية'),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                          },
                        ),
                      ],
                    ),
                  ),
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
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Colors.black,
                        icon: const Icon(Icons.home_outlined),
                        title: const Text('الرئيسية'),
                      ),
                      FlashyTabBarItem(
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Colors.black,
                        icon: const Icon(Icons.search),
                        title: const Text('البحث'),
                      ),
                      FlashyTabBarItem(
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Colors.black,
                        icon: const Badge(
                            child: Icon(Icons.description_outlined)),
                        title: const Text('الفواتير'),
                      ),
                      FlashyTabBarItem(
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Colors.black,
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
      },
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
