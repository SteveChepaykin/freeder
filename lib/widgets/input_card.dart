import 'package:flutter/material.dart';
import 'package:starange_reader/database/texts_database.dart';
import 'package:starange_reader/models/saved_text_model.dart';
import 'package:starange_reader/screens/reader_screen.dart';

class InputCard extends StatelessWidget {
  final  Future<void> Function() func;
  InputCard({Key? key, required this.func}) : super(key: key);

  final TextEditingController editcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 28, 57, 78),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                  hintText: 'ваш текст...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(255, 17, 35, 49),
                  ))),
              // enabled: false,
              controller: editcont,
              maxLines: 20,
              minLines: 1,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton.icon(
            onPressed: () async {
              if (editcont.text.isNotEmpty) {
                int id = await addText(editcont.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReaderScreen(
                      textid: id,
                    ),
                  ),
                ).whenComplete(func);
              }
              editcont.clear();
            },
            icon: const Icon(
              Icons.textsms,
              color: Colors.white,
            ),
            label: const Text(
              'читать',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<int> addText(String wholetext) async {
    final ttext = SavedText(
      title: '',
      wholetext: wholetext,
      lastindex: 0,
      timecreated: DateTime.now(),
    );
    var a = await TextsDatabase.instance.create(ttext);
    return a.id!;
  }
}
