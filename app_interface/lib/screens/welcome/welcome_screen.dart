import 'package:e_commerce/constants/global_variables.dart';
import 'package:e_commerce/providers/vistits_provider.dart';
import 'package:e_commerce/screens/auth/login.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String path = '/welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Widget> slides = GlobalVariables.items.reversed
      .map((item) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.fitWidth,
                  width: 220.0,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        item['header'],
                        style: const TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.w300,
                            color: Color(0XFF3F3D56),
                            height: 2.0),
                      ),
                      Text(
                        item['description'],
                        style: const TextStyle(
                          color: Colors.grey,
                          letterSpacing: 1.2,
                          fontSize: 16.0,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            ],
          )))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
              color: currentPage.round() == index
                  ? const Color(0XFF256075)
                  : const Color(0XFF256075).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ));

  double currentPage = 0.0;
  final _pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    // _pageViewController.addListener(() {
    //   setState(() {
    //     currentPage = _pageViewController.page ?? 0;
    //   });
    // });
  }

  void setCurrentPage(double val) {
    setState(() {
      currentPage = val;
    });
    _pageViewController.animateToPage(
      currentPage.toInt(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  context.read<VisitProvider>().setFirstVisit(false);
                  context.push(HomeScreen.path);
                },
                child: const Text("تخطي"),
              ),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: currentPage <= 0
                    ? null
                    : () {
                        if (currentPage > 0) {
                          print(currentPage);
                          setCurrentPage(currentPage - 1);
                          print(currentPage);
                        }
                      },
                child: const Text("السابق"),
              ),
              TextButton(
                onPressed: currentPage <= slides.length - 1
                    ? () {
                        if (currentPage == slides.length - 1) {
                          context.go(LoginScreen.path);
                        }
                        if (currentPage < slides.length) {
                          setCurrentPage(currentPage + 1);
                        }
                      }
                    : null,
                child: const Text("التالي"),
              ),
            ],
          ),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              PageView.builder(
                controller: _pageViewController,
                itemCount: slides.length,
                onPageChanged: (value) => setCurrentPage(value.toDouble()),
                itemBuilder: (BuildContext context, int index) {
                  return slides[index];
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 70.0),
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
