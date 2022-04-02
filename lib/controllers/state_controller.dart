import 'package:get/get.dart';

class StateController extends GetxController {
  int textSize = 40;
  int speed = 4;

  final Map<int, Map<String, int>> speedsMap = {
    1: {
      'short': 1300,
      'medium': 1700,
      'long': 2100,
    },
    2: {
      'short': 1150,
      'medium': 1550,
      'long': 1950,
    },
    3: {
      'short': 1000,
      'medium': 1400,
      'long': 1800,
    },
    4: {
      'short': 800,
      'medium': 1200,
      'long': 1600,
    },
    5: {
      'short': 500,
      'medium': 900,
      'long': 1300,
    },
  };

  void changeSpeed(int value) {
    if(1 <= (speed += value) && (speed += value) <= 5) speed += value;
  }

  void changeFontSize(int newsize) {
    if(25<newsize && newsize<55) textSize = newsize;
  }
}