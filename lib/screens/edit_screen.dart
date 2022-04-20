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

  @override
  void initState() {
    textedit.text = widget.st.wholetext;
    positionedit.text = (widget.st.lastindex + 1).toString();
    // headeredit.text = widget.st.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await updateText(
                textedit.text,
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
            // TextField(
            //   controller: headeredit,
            //   maxLines: 1,
            //   style: const TextStyle(fontSize: 20, color: Colors.white),
            // ),
            TextField(
              controller: textedit,
              maxLines: null,
              style: const TextStyle(fontSize: 17, color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text('позиция в тексте:', style: TextStyle(fontSize: 20, color: Colors.white),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: positionedit,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const Text('слово', style: TextStyle(fontSize: 20, color: Colors.white),)
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
