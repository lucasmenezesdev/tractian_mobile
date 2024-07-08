import 'package:flutter/material.dart';
import 'package:tractian_mobile/app/pages/initial/initial_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRACTIAN',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF17192D),
          primary: const Color(0xFF17192D),
          secondary: const Color(0xFF2188FF),
          surface: const Color(0xFF17192D),
          tertiary: const Color(0xFF52C41A),
          error: const Color(0xFFED3833),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const InitialPage(),
    );
  }
}
