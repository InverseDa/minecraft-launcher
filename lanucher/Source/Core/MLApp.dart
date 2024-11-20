
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../MLMain.dart';
import 'MLAppState.dart';

class MLApp extends StatelessWidget {
  const MLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MLAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}