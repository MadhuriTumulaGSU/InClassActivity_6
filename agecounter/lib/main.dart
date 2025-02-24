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

  // Set the age directly from the slider
  void setAge(int newAge) {
    value = newAge;
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
      return Color(0xFFFFF8C2);  // Light yellow defined with hex value
    } else if (value <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey[300]!;
    }
  }

  // Determine the color for the progress bar based on the age range
  Color get progressBarColor {
    if (value <= 33) {
      return Colors.green;
    } else if (value <= 67) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  // Calculate progress for the progress bar
  double get progressValue {
    if (value <= 99) {
      return value / 99; // Normalize the age to the range 0-1 for the progress bar
    } else {
      return 1.0;
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
                const SizedBox(height: 20),
                
                // Slider to adjust age
                Slider(
                  value: counter.value.toDouble(),
                  min: 0,
                  max: 99,
                  divisions: 99,
                  label: '${counter.value}',
                  onChanged: (double newValue) {
                    counter.setAge(newValue.toInt()); // Update age based on slider
                  },
                ),
                const SizedBox(height: 20),
                
                // Progress bar with color changes based on the range
                LinearProgressIndicator(
                  value: counter.progressValue,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(counter.progressBarColor),
                ),
                const SizedBox(height: 20),
                Text(
                  'Progress: ${((counter.progressValue) * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.headlineSmall,
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