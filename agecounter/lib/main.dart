import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Milestone Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  // Increment the counter and notify listeners
  void increment() {
    value += 1;
    notifyListeners();
  }

  // Determine the milestone based on the current counter value
  String get milestoneMessage {
    if (value <= 12) {
      return "You're a child!";
    } else if (value <= 19) {
      return "Teenager time!";
    } else if (value <= 30) {
      return "You're a young adult!";
    } else if (value <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden years!";
    }
  }

  // Determine the background color based on the current counter value
  Color get backgroundColor {
    if (value <= 12) {
      return Colors.lightBlue;
    } else if (value <= 19) {
      return Colors.lightGreen;
    } else if (value <= 30) {
      return Color(0xFFFFF8C2);
    } else if (value <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey[300]!;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Milestone Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Scaffold(
          backgroundColor: counter.backgroundColor, // Update background color
          appBar: AppBar(
            title: const Text('Age Milestone Counter'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You have reached this milestone:'),
                Text(
                  counter.milestoneMessage,  // Show milestone message
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Age: ${counter.value}', // Show current age (counter value)
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              counter.increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}