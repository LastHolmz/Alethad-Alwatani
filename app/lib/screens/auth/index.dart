import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/providers/user_provider.dart';
import 'package:e_commerce/services/user.dart';
import 'package:flutter/material.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/enums/field_status.dart';
import 'package:gsform/gs_form/model/data_model/spinner_data_model.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:gsform/gs_form/widget/section.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.light,
//       locale: const Locale('en', 'US'),
//       supportedLocales: const [Locale('en', 'US'), Locale('fa', 'IR')],
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: Colors.blue,
//         textTheme: null,
//         colorScheme: null,
//       ),
//       darkTheme: ThemeData(brightness: Brightness.dark, colorScheme: null),
//       home: MainTestPage(),
//     );
//   }
// }

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  late GSForm form;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GSForm example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              MultiSectionForm()),
                      (route) =>
                          true, //if you want to disable back feature set to false
                    );
                  },
                  child: const Text('Multi Section form'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                SingleSectionForm()),
                        (route) => true);
                  },
                  child: const Text('Single Section form'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SingleSectionForm extends StatefulWidget {
  SingleSectionForm({Key? key}) : super(key: key);
  String? value;

  late GSFieldStatusEnum status;

  @override
  State<SingleSectionForm> createState() => _SingleSectionFormState();
}

class _SingleSectionFormState extends State<SingleSectionForm> {
  late GSForm form;
  int id = 0;

  @override
  void initState() {
    widget.value = 'dfhbdkfhbdasffffteryuiei577y ';
    widget.status = GSFieldStatusEnum.normal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single section Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: form = GSForm.singleSection(
                      style: GSFormStyle(
                          titleStyle: const TextStyle(
                              color: Colors.black87, fontSize: 16.0)),
                      context,
                      fields: [
                        GSField.email(
                          tag: 'email',
                          title: 'login',
                          weight: 12,
                          required: true,
                          maxLength: 100,
                          errorMessage: 'erro',
                          value: 'dastras.saeed@gmail.com',
                        ),
                        GSField.spinner(
                          tag: 'customer_type',
                          required: false,
                          weight: 12,
                          showTitle: false,
                          onChange: (model) {
                            id = model!.id;
                            setState(() {});
                          },
                          items: [
                            SpinnerDataModel(
                              name: 'm1',
                              id: 0,
                            ),
                            SpinnerDataModel(
                              name: 'm2',
                              id: 1,
                            ),
                            SpinnerDataModel(
                              name: 'm3',
                              id: 2,
                            ),
                          ],
                        ),
                        GSField.spinner(
                          tag: 'customer_type',
                          required: false,
                          weight: 6,
                          title: 'Gender',
                          onChange: (model) {},
                          items: [
                            SpinnerDataModel(
                                name: '3', id: 0, isSelected: id == 0),
                            SpinnerDataModel(
                              name: '4',
                              id: 1,
                              isSelected: id == 1,
                            ),
                            SpinnerDataModel(
                                name: '8', id: 2, isSelected: id == 2),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        bool isValid = form.isValid();
                        Map<String, dynamic> map = form.onSubmit();
                        debugPrint(map.toString());
                        debugPrint(isValid.toString());
                        setState(() {});
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MultiSectionForm extends StatefulWidget {
  MultiSectionForm({Key? key}) : super(key: key);

  @override
  State<MultiSectionForm> createState() => _MultiSectionFormState();
}

class _MultiSectionFormState extends State<MultiSectionForm> {
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
      // context.read<UserProvider>().setUser(newUser);
      // await context.read<UserProvider>().updateToken(user.token);
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
                                    // debugPrint([
                                    //   map["fullName"],
                                    //   map["password"],
                                    //   map["companyTitle"],
                                    //   map["location"],
                                    //   map["mobile"],
                                    //   map["componeyMobile"]["data"],
                                    //   gender
                                    // ].toString());
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
