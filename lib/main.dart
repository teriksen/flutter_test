import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



void requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (status.isGranted) {
    print("----------------------------");
    print("We already have access.");
    print("----------------------------");
  }
  else if (status.isDenied) {
    status = await Permission.camera.request();
    if (status.isGranted) {
      print("----------------------------");
      print("We now have access.");
      print("----------------------------");
    }
    else {
      print("----------------------------");
      print("We did not get access.");
      print("----------------------------");
    }
  }
}

void requestStoragePermission() async {
  var status = await Permission.storage.status;
  print("--------------------------------------------------------------------------------------------------");
  print(status);
  if (status.isGranted) {
    print("----------------------------------------------------------------------------------------------------");
    print("------------------------Permission is currently granted, so we do nothing.--------------------------");
    print("----------------------------------------------------------------------------------------------------");
  }
  else if (status.isDenied) {
    print("----------------------------------------------------------------------------------------------------");
    print("--------------------Permission is currently denied, so we request permission.-----------------------");
    print("----------------------------------------------------------------------------------------------------");
    if (await Permission.storage.request().isGranted) {
      print("----------------------------------------------------------------------------------------------------");
      print("----------------------------------Permission now granted.-------------------------------------------");
      print("----------------------------------------------------------------------------------------------------");
    }
  }
  else if (status.isPermanentlyDenied) {
    print("----------------------------------------------------------------------------------------------------");
    print("---------------------------------Permission is permanently denied.----------------------------------");
    print("----------------------------------------------------------------------------------------------------"); 
  }
  print("---------------------------- Status is: ------------------------------");
  print(status);
  print("---------------");
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _getStoragePermissionAndroid() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    //bool permissionGranted = await Permission.storage.isGranted;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        setState(() {
        //permissionGranted = true;
        });
      } else if (await Permission.storage.request().isPermanentlyDenied) {
         await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        setState(() {
        //permissionGranted = false;
        });
      }
    } else {
       if (await Permission.photos.request().isGranted) {
            setState(() {
               //permissionGranted = true;
            });
       } else if (await Permission.photos.request().isPermanentlyDenied) {
           await openAppSettings();
       } else if (await Permission.photos.request().isDenied) {
           setState(() {
               //permissionGranted = false;
           });
      }
    }
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _incrementCounter;
          //var status = await Permission.storage.status;
          //if (status.isDenied) {
            //requestCameraPermission();
            //_getStoragePermissionAndroid();
          //}
          //if (status.isGranted) {
            // Either the permission was already granted before or the user just granted it.
            final inputImage = InputImage.fromFilePath("pdfscan.png");
            final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
            final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
            String text = recognizedText.text;
            print("----------------------------------------------------------------------------------------------------");
            print(text);
            print("----------------------------------------------------------------------------------------------------");
            for (TextBlock block in recognizedText.blocks) {
              final Rect rect = block.boundingBox;
              final List<Point<int>> cornerPoints = block.cornerPoints;
              final String text = block.text;
              final List<String> languages = block.recognizedLanguages;   
              //developer.log(text, name: 'mlkit_testing');
              for (TextLine line in block.lines) {
                // Same getters as TextBlock
                for (TextElement element in line.elements) {
                  // Same getters as TextBlock
                }
              }
            }

            // You can request multiple permissions at once.
            //      Map<Permission, PermissionStatus> statuses = await [
            //        Permission.camera,
            //        Permission.storage,
            //      ].request();
          },
          //else {
          //  print("----------------------------------------------------------------------------------------------------");
          //  print("--------------------------------Could not obtain access to storage.---------------------------------");
          //  print("----------------------------------------------------------------------------------------------------");
          //}

          //if (await status.isRestricted) {
          //  print("----------------------------------------------------------------------------------------------------");
          //  print("-------------------------OS restricts the permission from being granted.----------------------------");
          //  print("----------------------------------------------------------------------------------------------------");
          //}
          //_incrementCounter;
          
        
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
