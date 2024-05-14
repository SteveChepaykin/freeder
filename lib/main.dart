import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reader_project/controllers/state_controller.dart';
import 'package:reader_project/screens/texts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var stcont = StateController();
  // Get.put<StateController>(stcont);
  Get.putAsync<StateController>(() async {
    var c = StateController();
    await c.init();
    return c;
  },);
  // await UserPrefs().setPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Freeder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TextsScreen(),
    );
  }
}
