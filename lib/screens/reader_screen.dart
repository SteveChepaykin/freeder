import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:reader_project/controllers/state_controller.dart';
import 'package:reader_project/database/texts_database.dart';
import 'package:reader_project/models/saved_text_model.dart';
import 'package:reader_project/screens/settings_screen.dart';
import 'package:reader_project/widgets/bottom_panel.dart';

class ReaderScreen extends StatefulWidget {
  static const String routeName = '/reader_screen';
  final int textid;
  const ReaderScreen({
    Key? key,
    required this.textid,
  }) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> with SingleTickerProviderStateMixin {
  late AnimationController animcontroller;
  late PanelController pcontroller;
  List<String> textlist = [
    ' ',
  ];
  String lastText = '';
  int counter = 0;
  bool ispaused = true;
  late Duration dur;
  static const double fabhaightmin = 110;
  double fabheight = fabhaightmin;
  SavedText? thissavedtext;
  bool isLoading = false;
  var controller = Get.find<StateController>();

  @override
  void initState() {
    refreshText().whenComplete(() {
      setState(() {
        counter = thissavedtext!.lastindex;
        textlist = thissavedtext!.wholetext.split(' ');
        textlist.add('//конец//');
        textlist.removeWhere((element) => element == '█');
        lastText = textlist.sublist(0, counter).join(' ');
      });
    });
    dur = Duration(milliseconds: controller.speedsMap[controller.getSpeed()]!['short']!);
    animcontroller = AnimationController(
      vsync: this,
      duration: dur,
    );
    animcontroller.view.addStatusListener(changeword);
    pcontroller = PanelController();
    super.initState();
  }

  Future<void> refreshText() async {
    thissavedtext = await TextsDatabase.instance.readText(widget.textid) as SavedText;
  }

  void changeword(AnimationStatus status) {
    if (status == AnimationStatus.completed && counter + 1 != textlist.length) {
      animcontroller.reset();
      lastText += ' ${textlist[counter]}';
      counter++;
      var a = textlist[counter].length;
      if (a > 4) {
        dur = Duration(milliseconds: controller.speedsMap[controller.getSpeed()]!['medium']!);
      }
      if (a > 8) {
        dur = Duration(milliseconds: controller.speedsMap[controller.getSpeed()]!['long']!);
      } else {
        dur = Duration(milliseconds: controller.speedsMap[controller.getSpeed()]!['short']!);
      }
      animcontroller.duration = dur;
      animcontroller.forward();
      setState(() {});
    }
    // } else {
    //   textpauser();
    // }
  }

  void textpauser() {
    if (!ispaused) {
      animcontroller.stop();
    } else {
      animcontroller.forward();
      pcontroller.close();
    }
    ispaused = !ispaused;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final panelMaxOpenSize = MediaQuery.of(context).size.height * 0.6;
    final panelMinOpenSize = MediaQuery.of(context).size.height * 0.08;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
        title: Text(controller.getSpeed().toString()),
        leading: IconButton(
          onPressed: () async {
            await updateText(counter);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              animcontroller.stop();
              ispaused = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              ).whenComplete(() {
                setState(() {});
              });
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          SlidingUpPanel(
            color: const Color.fromARGB(255, 28, 57, 78),
            controller: pcontroller,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15),
            ),
            minHeight: panelMinOpenSize,
            maxHeight: panelMaxOpenSize,
            onPanelOpened: () {
              if (!ispaused) animcontroller.stop();
            },
            onPanelClosed: () {
              if (!ispaused) animcontroller.forward();
            },
            parallaxEnabled: true,
            parallaxOffset: 0.2,
            onPanelSlide: (height) {
              final panelscrollextent = panelMaxOpenSize - panelMinOpenSize;
              setState(() {
                fabheight = height * panelscrollextent + fabhaightmin;
              });
            },
            panelBuilder: (sc) => PanelWidget(
              controller: sc,
              lastText: lastText,
            ),
            body: GestureDetector(
              onTapDown: (_) {
                if (!ispaused) animcontroller.stop();
              },
              onTapUp: (_) {
                if (!ispaused) animcontroller.forward();
              },
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: SizedBox(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 70),
                    child: Text(
                      textlist[counter],
                      key: ValueKey(textlist[counter] + Random(200).toString()),
                      style: TextStyle(
                        fontSize: controller.getSize()!.toDouble(),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: fabheight,
            child: buildFAB(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    animcontroller.dispose();
    super.dispose();
  }

  Widget buildFAB() {
    return FloatingActionButton(
      onPressed: textpauser,
      // isExtended: true,
      backgroundColor: const Color.fromARGB(255, 28, 57, 78),
      child: Icon(
        ispaused ? Icons.play_circle_outline_rounded : Icons.pause_circle_outline_rounded,
        size: 50,
      ),
    );
  }

  Future<void> updateText(int newlastindex) async {
    final updatedtext = thissavedtext!.copy(
      lastindex: newlastindex,
    );
    await TextsDatabase.instance.update(updatedtext);
  }
}
