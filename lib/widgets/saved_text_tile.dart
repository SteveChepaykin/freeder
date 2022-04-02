import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:intl/intl.dart';
import 'package:starange_reader/models/saved_text_model.dart';
import 'package:starange_reader/screens/edit_screen.dart';

class SavedTextTile extends StatefulWidget {
  final SavedText st;
  const SavedTextTile({Key? key, required this.st}) : super(key: key);

  @override
  State<SavedTextTile> createState() => _SavedTextTileState();
}

class _SavedTextTileState extends State<SavedTextTile> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Offset distance = isPressed ? Offset(2, 2) : Offset(10, 10);
    // double blur = isPressed ? 5 : 15;
    // return GestureDetector(
    //   onTap: () => setState(() {
    //     isPressed = !isPressed;
    //   }),
    //   child: Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: AnimatedContainer(
    //       duration: const Duration(milliseconds: 100),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(15),
    //         color: const Color.fromARGB(255, 17, 35, 49),
    //         boxShadow: [
    //           BoxShadow(offset: distance, color: const Color.fromARGB(255, 12, 25, 36), blurRadius: blur, inset: isPressed),
    //           BoxShadow(offset: -distance, color: const Color.fromARGB(255, 24, 48, 66), blurRadius: blur, inset: isPressed)
    //         ],
    //       ),
    //       child: Column(
    //         children: [
    //           Text(
    //             DateFormat.yMMMd().format(widget.st.timecreated),
    //           ),
    //           const SizedBox(
    //             height: 5,
    //           ),
    //           Text(widget.st.title),
    //           Text(
    //             widget.st.wholetext,
    //             style: const TextStyle(
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Card(
      color: const Color.fromARGB(255, 28, 57, 78),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMd().format(widget.st.timecreated),
              style: const TextStyle(
                color: Colors.white38,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'SOMETHING',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            Expanded(
              child: Text(
                widget.st.wholetext,
                style: const TextStyle(
                    // overflow: TextOverflow.ellipsis,
                    color: Colors.white70,
                    fontSize: 15),
                // overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(st: widget.st)));
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
