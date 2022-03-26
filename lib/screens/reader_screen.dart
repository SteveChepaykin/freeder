import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:starange_reader/database/texts_database.dart';
import 'package:starange_reader/models/saved_text_model.dart';
import 'package:starange_reader/widgets/bottom_panel.dart';

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
  late AnimationController controller;
  late PanelController pcontroller;
  List<String> textlist = [
    'loading...',
  ];
  String lastText = '';
  int counter = 0;
  bool ispaused = true;
  late Duration dur;
  // final double fabheight = MediaQuery.of(context).size.height * 0.15;
  static const double fabhaightmin = 110;
  double fabheight = fabhaightmin;

  SavedText? thissavedtext;
  bool isLoading = false;

  @override
  void initState() {
    // textlist = widget.currentText.split(' ');
    refreshText().whenComplete(() {
      setState(() {
        counter = thissavedtext!.lastindex;
        textlist = thissavedtext!.wholetext.split(' ');
        lastText = textlist.sublist(0, counter).join(' ');
      });
    });
    // counter = thissavedtext!.lastindex;
    // textlist = thissavedtext!.wholetext.split(' ');
    // lastText = textlist.sublist(0, counter).join(' ');
    dur = const Duration(milliseconds: 800);
    controller = AnimationController(
      vsync: this,
      duration: dur,
    );
    controller.view.addStatusListener(changeword);
    pcontroller = PanelController();
    super.initState();
  }

  Future<void> refreshText() async {
    // setState(() {
    //   isLoading = true;
    // });
    thissavedtext = await TextsDatabase.instance.readText(widget.textid) as SavedText;
    // setState(() {
    //   isLoading = false;
    // });
  }

  void changeword(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.reset();
      lastText += ' ${textlist[counter]}';
      counter++;
      var a = textlist[counter].length;
      if (a > 7) {
        dur = const Duration(milliseconds: 1300);
      }
      if (a > 13) {
        dur = const Duration(milliseconds: 1800);
      }
      if (a > 20) {
        dur = const Duration(milliseconds: 2300);
      } else {
        dur = const Duration(seconds: 1);
      }
      controller.duration = dur;
      controller.forward();
      setState(() {});
    }
  }

  void textpauser() {
    if (!ispaused) {
      controller.stop();
    } else {
      controller.forward();
      pcontroller.close();
    }
    ispaused = !ispaused;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final panelMaxOpenSize = MediaQuery.of(context).size.height * 0.6;
    final panelMinOpenSize = MediaQuery.of(context).size.height * 0.08;
    // final args = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    // textlist = args['text']!.split(' ');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
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
              textpauser();
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
            // minHeight: MediaQuery.of(context).size.height * 0.08,
            // maxHeight: MediaQuery.of(context).size.height * 0.6,
            minHeight: panelMinOpenSize,
            maxHeight: panelMaxOpenSize,
            onPanelOpened: () {
              if (!ispaused) controller.stop();
            },
            onPanelClosed: () {
              if (!ispaused) controller.forward();
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
                if (!ispaused) controller.stop();
              },
              onTapUp: (_) {
                if (!ispaused) controller.forward();
              },
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: SizedBox(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      textlist[counter],
                      key: ValueKey(textlist[counter] + Random(200).toString()),
                      style: const TextStyle(
                        fontSize: 40,
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
    controller.dispose();
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
