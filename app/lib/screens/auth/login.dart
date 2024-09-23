import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/screens/auth/sign_up.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/enums/field_status.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  LoginScreen({key}) : super(key: key);
  String? value;
  static const String path = "/login";
  static const String name = "login";
  late GSFieldStatusEnum status;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GSForm form;
  UserService _userService = UserService();

  @override
  void initState() {
    widget.status = GSFieldStatusEnum.normal;
    super.initState();
  }

  Future<void> login(User user) async {
    final newUser = await _userService.login(user, context);
    if (newUser != null) {
      await context.read<UserProvider>().checkUser(context, newUser.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل الدخول'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () {
                  context.go(HomeScreen.path);
                },
                child: const Text("تخطي"),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the form
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Adding a logo or title can help balance the layout
                  const Text(
                    'مرحبًا بكم في الإتحاد الوطني',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: form = GSForm.singleSection(
                      style: GSFormStyle(
                        sectionCardPadding: 20,
                        titleStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16.0,
                        ),
                      ),
                      context,
                      fields: [
                        GSField.mobile(
                          tag: 'mobile',
                          title: 'رقم الهاتف',
                          weight: 12,
                          required: true,
                          maxLength: 100,
                          errorMessage: 'يجب ملء رقم الهاتف',
                          hint: "ادخل رقم الهاتف",
                          prefixWidget: const Icon(
                            Icons.phone_android,
                            size: 18,
                          ),
                        ),
                        GSField.password(
                          tag: 'password',
                          title: 'كلمة السر',
                          weight: 12,
                          required: true,
                          maxLength: 100,
                          errorMessage: 'يجب ملء كلمة السر',
                          hint: "ادخل كلمة السر",
                          prefixWidget: const Icon(
                            Icons.password,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                            height: 20), // Add spacing between fields
                        FilledButton(
                          onPressed: () async {
                            bool isValid = form.isValid();
                            if (!isValid) {
                              return;
                            }
                            Map<String, dynamic> map = form.onSubmit();

                            await login(
                              User(
                                id: '',
                                fullName: '',
                                password: map["password"],
                                companyTitle: '',
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                                gender: Gender.man,
                                location: '',
                                mobile: int.parse(map["mobile"]),
                                componeyMobile: 0,
                              ),
                            );
                          },
                          child: const Text("تسجيل الدخول"),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            context.push(SingUpScreen.path);
                          },
                          child: const Text("إنشاء حساب"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
