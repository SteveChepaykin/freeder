import 'package:flutter/material.dart';
import 'package:starange_reader/TEXT.dart';
import 'package:starange_reader/database/texts_database.dart';
import 'package:starange_reader/models/saved_text_model.dart';
import 'package:starange_reader/screens/reader_screen.dart';
import 'package:starange_reader/widgets/input_card.dart';
import 'package:starange_reader/widgets/saved_text_tile.dart';

class TextsScreen extends StatefulWidget {
  TextsScreen({Key? key}) : super(key: key);

  @override
  State<TextsScreen> createState() => _TextsScreenState();
}

class _TextsScreenState extends State<TextsScreen> {
  TextEditingController editcont = TextEditingController();
  ScrollController scrollcont = ScrollController();
  List<SavedText> savedtexts = [];
  bool isLoading = false;

  @override
  void initState() {
    refreshNotes().whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    TextsDatabase.instance.closeDB();
    super.dispose();
  }

  Future<void> refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    savedtexts = await TextsDatabase.instance.readAllSavedTexts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
        actions: [
          IconButton(
            onPressed: () {
              // textpauser();
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              InputCard(),
              const SizedBox(
                height: 30,
              ),
              GridView(
                padding: const EdgeInsets.all(10),
                controller: scrollcont,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
                  childAspectRatio: 5 / 8,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: [
                  ...savedtexts.map((st) => SavedTextTile(st: st)).toList()
                  // tile(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
