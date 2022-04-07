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
        // title: const Text('"читальня"'),
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     await refreshNotes();
          //   },
          //   icon: const Icon(Icons.replay),
          // ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              InputCard(
                func: refreshNotes,
              ),
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
                            ).whenComplete(() async {
                              await refreshNotes();
                            });
                          },
                          onLongPressEnd: (details) async {
                            showDialog(context: context, builder: (constext) => dialog(st));
                          },
                          child: SavedTextTile(st: st, funk: refreshNotes,),
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

  Widget dialog(SavedText st) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 17, 35, 49),
        title: const Text('УДАЛЕНИЕ', style: TextStyle(color: Colors.white),),
        content: Text(
          'уверены что хотите удалить текст: ${st.wholetext}',
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded, color: Colors.white,),
            label: const Text('назад', style: TextStyle(color: Colors.white),),
          ),
          TextButton.icon(
            onPressed: () async {
              TextsDatabase.instance.delete(st.id!);
              await refreshNotes();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check_rounded, color: Colors.white,),
            label: const Text('удалить', style: TextStyle(color: Colors.white),),
          ),
        ],
      );
}
