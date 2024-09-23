import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariables {
  static const double defalutRaduis = 40;
  static const double defaultPadding = 20;
  static const double pageSize = 50;
  static const List items = [
    {
      "header": "تأكيد الطلب",
      "description":
          "تأكد من تفاصيل طلبك، اختر طريقة الدفع المفضلة، وتأكد من عنوان التوصيل لإتمام عملية الشراء بنجاح.",
      "image": "assets/2.png"
    },
    {
      "header": "اختر منتجاتك",
      "description":
          "اختر منتجاتك المفضلة من بين مجموعة متنوعة من الخيارات المتاحة. استعرض الفئات، أضفها إلى سلة التسوق، وأكمل عملية الشراء بسهولة.",
      "image": "assets/3.png"
    },
    {
      "header": "تسجيل الدخول",
      "description":
          "تسجيل الدخول يتيح لك الوصول إلى جميع الميزات المتاحة. قم بإدخال اسم المستخدم وكلمة المرور الخاصة بك للوصول السريع والآمن.",
      "image": "assets/1.png"
    },
    // {
    //   "header": "Invest",
    //   "description":
    //       "Online chat which provides its users maximum functionality to simplify the search",
    //   "image": "assets/images/5.png"
    // },
    // {
    //   "header": "Travel",
    //   "description":
    //       "Online chat which provides its users maximum functionality to simplify the search",
    //   "image": "assets/images/4.png"
    // }
  ];
}

Map<String, String> headers(String token) {
  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}

Future<String> getStoredToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  return token;
}

// const uri = 'http://10.0.2.2:10000/api/v1/';
const uri = 'https://alethad-alwatani.onrender.com/api/v1/';

Uri apiUri(String path) {
  return Uri.parse('$uri$path');
}
