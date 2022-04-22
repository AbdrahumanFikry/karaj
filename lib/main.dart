import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:karaj/bindings/binding_controllers.dart';
import 'package:karaj/bindings/root_screen/root.dart';
import 'package:karaj/bindings/themes/themes.dart';
import 'package:karaj/services/PushNotificationService.dart';
import 'package:karaj/services/localization_services_lang.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

import 'checkout_view.dart';

bool pushNotificationInited = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await GetStorage.init();
  // await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingControllers(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRight,
      // home: FirebaseInit(),
      home: CheckoutView(),
      theme: Themes.lightTheme,
      themeMode: ThemeMode.dark,
      locale: LocalizationService().getLangLocale(),
      translations: LocalizationService(),
      fallbackLocale: LocalizationService.fallbackLocale,
    );
  }
}

class FirebaseInit extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    print("================================== FirebaseInit()");
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        print(snapshot.error);
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('خطا في قاعدة البيانات \n  Error in Database.'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (FirebaseAuth.instance.currentUser != null &&
              pushNotificationInited != true) {
            PushNotificationService().init();
            pushNotificationInited = true;
          }
          return Root();
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
