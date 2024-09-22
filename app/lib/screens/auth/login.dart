import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/model/data_model/spinner_data_model.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:gsform/gs_form/widget/section.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const String path = "/login";
  static const String name = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GSForm form;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> createNewUser(User user) async {
    final newUser = await _userService.register(user, context);
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
          title: const Text('إنشاء حساب جديد'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
          child: Consumer<UserProvider>(
            builder: (context, value, child) {
              final isLoading = value.isLoading;
              return isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: form = GSForm.multiSection(
                              context,
                              style: GSFormStyle(
                                titleStyle: const TextStyle(fontSize: 16),
                                fieldTextStyle: const TextStyle(fontSize: 16),
                                sectionCardPadding: 12,
                              ),
                              sections: [
                                GSSection(
                                    sectionTitle: 'بياناتك',
                                    // style: GSFormStyle(sectionCardPadding: 12),
                                    fields: [
                                      GSField.text(
                                        value: 'ادخل اسمك الثلاثي',
                                        tag: 'fullName',
                                        title: 'الاسم الثلاثي',
                                        minLine: 1,
                                        maxLine: 1,
                                        required: true,
                                      ),
                                      GSField.number(
                                        tag: 'age',
                                        value: '18',
                                        title: 'عمرك',
                                        required: true,
                                      ),
                                      GSField.password(
                                        tag: 'password',
                                        title: 'كلمة السر',
                                        maxLength: 11,
                                        value: 'انشىء كلمة السر',
                                        required: true,
                                        errorMessage: 'يجب ادخال رقم الشركة',
                                      ),
                                      GSField.spinner(
                                        tag: 'gender',
                                        required: true,
                                        weight: 6,
                                        title: 'الجنس',
                                        value: SpinnerDataModel(
                                          name: 'رجل',
                                          id: 1,
                                          data: "man",
                                        ),
                                        onChange: (model) {},
                                        items: [
                                          SpinnerDataModel(
                                            name: 'رجل',
                                            id: 1,
                                            data: "man",
                                          ),
                                          SpinnerDataModel(
                                            name: 'امراة',
                                            id: 2,
                                            data: "woman",
                                          ),
                                        ],
                                      ),
                                      GSField.mobile(
                                        tag: 'mobile',
                                        title: 'هاتفك الشخصي',
                                        maxLength: 10,
                                        helpMessage: '921234123',
                                        weight: 6,
                                        required: true,
                                        errorMessage:
                                            'يجب ادخال رقم هاتفك الشخصي',
                                      ),
                                    ]),
                                GSSection(
                                  sectionTitle: 'معلومات شركتك',
                                  style: GSFormStyle(),
                                  fields: [
                                    GSField.text(
                                      tag: 'companyTitle',
                                      title: 'اسم الشركة',
                                      minLine: 1,
                                      maxLine: 1,
                                      weight: 12,
                                      required: true,
                                      errorMessage: 'يجب ادخال اسم الشركة',
                                    ),
                                    GSField.mobile(
                                      tag: 'componeyMobile',
                                      title: 'رقم الشركة',
                                      maxLength: 11,
                                      helpMessage: '921112223',
                                      required: true,
                                      errorMessage: 'يجب ادخال رقم الشركة',
                                    ),
                                    GSField.textPlain(
                                      hint: 'معلومات الموقع',
                                      tag: 'location',
                                      title: 'موقع الشركة',
                                      maxLine: 4,
                                      maxLength: 233,
                                      showCounter: false,
                                      weight: 12,
                                      prefixWidget: const Icon(
                                        Icons.location_city,
                                        color: Colors.blue,
                                      ),
                                      required: false,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FilledButton(
                                  onPressed: () async {
                                    bool isValid = form.isValid();
                                    if (!isValid) {
                                      return;
                                    }
                                    Map<String, dynamic> map = form.onSubmit();
                                    // debugPrint(isValid.toString());
                                    // debugPrint(map.toString());
                                    SpinnerDataModel gender = map["gender"];

                                    await createNewUser(User(
                                      id: '',
                                      fullName: map["fullName"],
                                      password: map["password"],
                                      companyTitle: map["companyTitle"],
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                      gender:
                                          User.getGenderFromString(gender.data),
                                      location: map["location"],
                                      mobile: int.parse(map["mobile"]),
                                      componeyMobile:
                                          int.parse(map["componeyMobile"]),
                                    ));
                                  },
                                  child: const Text('إنشاء الحساب'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
