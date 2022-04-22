import 'package:flutter/material.dart';
import 'package:starange_reader/database/texts_database.dart';
import 'package:starange_reader/models/saved_text_model.dart';

class EditScreen extends StatefulWidget {
  final SavedText st;
  const EditScreen({Key? key, required this.st}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController textedit = TextEditingController();
  final TextEditingController positionedit = TextEditingController();
  // final TextEditingController headeredit = TextEditingController();
  List<String> textlist = [];
  int index = 0;
  String alltext = '';
  int untillength = 0;

  @override
  void initState() {
    // textedit.text = widget.st.wholetext;
    // positionedit.text = (widget.st.lastindex + 1).toString();
    index = widget.st.lastindex;
    alltext = widget.st.wholetext;
    // headeredit.text = widget.st.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    untillength = 0;
    textlist = alltext.split(' ');
    for (String a in textlist.sublist(0, index)) {
      untillength += a.length;
    }
    untillength += index;
    // print(untillength);
    // textlist.insert(index, '█');
    // .split(' ').join(
    //       textlist.sublist(index + 1).toString(),
    //     );
    // textedit.text = textlist.join(' ');
    // textedit.selection = TextSelection(baseOffset: 2, extentOffset: 10);
    positionedit.text = (index + 1).toString();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
        actions: [
          TextButton.icon(
            onPressed: () async {
              // alltext.replaceAll(' █ ', ' ');
              await updateText(
                alltext,
                int.parse(positionedit.text) - 1,
              );
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: const Text(
              'save',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 17, color: Colors.white),
                children: [
                  TextSpan(
                    text: alltext.substring(0, untillength),
                  ),
                  TextSpan(
                    text: alltext.substring(untillength, untillength + textlist[index].length),
                    style: const TextStyle(fontSize: 17, backgroundColor: Color.fromARGB(255, 245, 164, 0), color: Colors.black),
                  ),
                  TextSpan(
                    text: alltext.substring(untillength + textlist[index].length),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: textedit,
              maxLines: null,
              style: const TextStyle(fontSize: 17, color: Colors.white),
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                setState(() {
                  // index = int.parse(positionedit.text) - 1;
                  // untillength = 0;
                  alltext += textedit.text;
                  textedit.clear();
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'позиция в тексте:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: positionedit,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    onEditingComplete: () {
                      setState(() {
                        index = int.parse(positionedit.text) - 1;
                        // untillength = 0;
                      });
                    },
                  ),
                ),
                const Text(
                  'слово',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateText(String newlasttext, int newlastindex) async {
    final updatedtext = widget.st.copy(
      wholetext: newlasttext,
      lastindex: newlastindex,
      // title: newheader,
    );
    await TextsDatabase.instance.update(updatedtext);
  }
}
