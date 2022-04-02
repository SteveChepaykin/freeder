import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starange_reader/controllers/state_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController cont = TextEditingController();
  late int spd;

  @override
  void initState() {
    var a = Get.find<StateController>();
    cont.text = a.textSize.toString();
    spd = a.speed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "25 < ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: cont,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  const Text(
                    " > 55 ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  butn(1),
                  butn(2),
                  butn(3),
                  butn(4),
                  butn(5),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                onPressed: () {
                  var a = Get.find<StateController>();
                  a.changeFontSize(int.parse(cont.text));
                  a.changeSpeed(spd);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save, color: Colors.white,),
                label: const Text('сохранить', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget butn(int v) {
    return ElevatedButton(
      // style: ButtonStyle(backgroundColor: const Color.fromARGB(255, 28, 57, 78),),
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 28, 57, 78))),
      onPressed: () {
        setState(() {
          spd = v;
        });
      },
      child: Text(
        v.toString(),
        style: TextStyle(
          color: spd == v ? Colors.amber : Colors.white,
        ),
      ),
    );
  }
}
