import 'package:flutter/material.dart';
import 'package:starange_reader/database/texts_database.dart';
import 'package:starange_reader/database/user_prefs.dart';
import 'package:starange_reader/models/saved_text_model.dart';
import 'package:starange_reader/screens/reader_screen.dart';
import 'package:starange_reader/screens/settings_screen.dart';
import 'package:starange_reader/widgets/input_card.dart';
import 'package:starange_reader/widgets/saved_text_tile.dart';

class TextsScreen extends StatefulWidget {
  const TextsScreen({Key? key}) : super(key: key);

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
    // s();
    super.initState();
  }

  void s() async {
    await UserPrefs().setPrefs();
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
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                controller: scrollcont,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
                  childAspectRatio: 6 / 10,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  ...savedtexts
                      .map(
                        (st) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReaderScreen(
                                  textid: st.id!,
                                ),
                              ),
                            ).whenComplete(() {
                              setState(() {});
                            });
                          },
                          onLongPress: () {
                            TextsDatabase.instance.delete(st.id!);
                            setState(() {});
                          },
                          child: SavedTextTile(st: st),
                        ),
                      )
                      .toList()
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
