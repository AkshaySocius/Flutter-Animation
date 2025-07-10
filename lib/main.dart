import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Artboard? riveArtBoard;
  SMITrigger? doSquat;
  int count = 0;
  @override
  void initState() {
    rootBundle.load("assets/lumberjack_squats.riv").then((value) async {
      try {
        final file = RiveFile.import(value);
        final art = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(art, "Don't Skip Leg Day");
        if (controller != null) {
          art.addController(controller);
          doSquat = controller.findSMI("Squat");
        }
        setState(() {
          riveArtBoard = art;
        });
      } catch (e) {
        print(e);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffB9F08E),
      body: riveArtBoard == null
          ? const SizedBox()
          : Column(
              children: [
                Expanded(child: Rive(artboard: riveArtBoard!)),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Squat Count $count",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),ElevatedButton(onPressed: (){
                  doSquat?.fire();
                  setState(() {
                    count++;
                  });
                }, child: Text("Common Do Squat"))
              ],
            ),
    );
  }
}
