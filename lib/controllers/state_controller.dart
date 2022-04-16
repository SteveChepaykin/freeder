import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateController extends GetxController {
  late int textSize;
  late int speed;
  static const String speedkey = 'speedKey';
  static const String sizekey = 'sizekey';

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    textSize = getSize()!;
    speed = getSpeed()!;
  }

  final Map<int, Map<String, int>> speedsMap = {
    100: {
      'short': 500,
      'medium': 600,
      'long': 800,
    },
    200: {
      'short': 250,
      'medium': 300,
      'long': 400,
    },
    300: {
      'short': 180,
      'medium': 200,
      'long': 300,
    },
    350: {
      'short': 150,
      'medium': 171,
      'long': 271,
    },
    450: {
      'short': 113,
      'medium': 133,
      'long': 200,
    },
  };

  // void changeSpeed(int value) {
  //   if(1 <= (speed += value) && (speed += value) <= 5) speed += value;
  // }

  // void changeFontSize(int newsize) {
  //   if(25<newsize && newsize<55) textSize = newsize;
  // }

   Future<void> setSpeed(int spd) {
    return prefs.setInt(speedkey, spd);
  }

  Future<void> setSize(int size) {
    return prefs.setInt(sizekey, size);
  }

  int? getSize() {
    return prefs.containsKey(sizekey) ? prefs.getInt(sizekey) : 40;
  }
  int? getSpeed() {
    return prefs.containsKey(speedkey) ? prefs.getInt(speedkey) : 2;
  }
}