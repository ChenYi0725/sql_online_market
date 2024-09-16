import 'package:database_final/pages/main_page.dart';
import 'package:database_final/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'pages/login_page.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(), // 設置 LoginPage 為首頁
    );
  }
}
