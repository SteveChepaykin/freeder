import 'package:flutter/material.dart';
import 'package:starange_reader/database/texts_database.dart';
import 'package:starange_reader/models/saved_text_model.dart';
import 'package:starange_reader/screens/reader_screen.dart';

class InputCard extends StatelessWidget {
  InputCard({ Key? key }) : super(key: key);

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
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'ваш текст...',
              ),
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
              int id = await addText(editcont.text);
              if (editcont.text.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReaderScreen(textid: id,),
                  ),
                );
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