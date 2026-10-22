import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

void main() => runApp(const MbgApp());

class MbgApp extends StatelessWidget {
  const MbgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Makan Bergizi Gratis',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: appRouter,
    );
  }
}
