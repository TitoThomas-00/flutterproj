import 'package:compain_app_web/pages/create_acc.dart';
import 'package:compain_app_web/pages/home_page.dart';
import 'package:compain_app_web/pages/inventory_page.dart';
import 'package:compain_app_web/pages/kioskdata_page.dart';
import 'package:compain_app_web/pages/login_page.dart';
import 'package:compain_app_web/pages/market_page.dart';
import 'package:compain_app_web/pages/orders_page.dart';
import 'package:compain_app_web/pages/sorted_page.dart';
import 'package:compain_app_web/providers/auth_methods.dart';
import 'package:compain_app_web/providers/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';
import 'providers/login_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyB2tOH5SajEuVLkuGPB8xc7Sy1VCvJvtjk",
    projectId: "maxsipcompanion",
    messagingSenderId: "933306178755",
    appId: "1:933306178755:web:b6ab669782f442bfd39676",
    measurementId: "G-E0807XZPQT",
  ));
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthMethods>(
          create: (_) => AuthMethods(),
        ),
        StreamProvider(
            create: (context) => context.read<AuthMethods>().authState,
            initialData: null),
        StreamProvider(
            create: (context) => context.read<AuthMethods>().getCurrentUser,
            initialData: UserModel()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthWrapper(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/requests': (context) =>  OrdersPage(),
        '/marketing':(context) => MarketPage(),
        '/inventory':(context) => InventoryPage(),
        '/createacc': (context) => CreateAcc(),
        '/sortit':(context) => SortPage()

      },
    );
  }
}
