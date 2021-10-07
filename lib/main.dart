import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_transition_screen/view_models/home_model.dart';

import 'view/home_view.dart';
import 'view/home_view_2.dart';
import 'view_models/home_model_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel2(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: HomeView2(),
      ),
    );
  }
}
